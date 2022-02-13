//
//  UserPageViewController.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/10/04.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit
import Alamofire

class UserPageViewController: UIViewController {
    
    @IBOutlet var userArticlesList: UITableView!
    @IBOutlet var userIcon: EnhancedCircleImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userId: UILabel!
    @IBOutlet var userIntroduction: UILabel!
    @IBOutlet var followCount: UIButton!
    @IBOutlet var followerCount: UIButton!
    var userArticles: [UserArticleItem] = []
    var userInfo: UserHeader?
    var commonApi = CommonApi()
    var errorView = NetworkErrorView()
    var page = 1
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userArticlesList.dataSource = self
        userArticlesList.delegate = self
        errorView.reloadActionDelegate = self
        commonApi.presentNetworkErrorViewDelegate = self
        MyPageViewController().settingHeader(userArticlesList)
        checkNetwork()
        
        CommonApi.userPageRequest(completion: { data in
            if data.isEmpty {
                self.checkNetwork()
            }
            data.forEach {
                self.userArticles.append($0)
            }
            self.userArticlesList.reloadData()
        }, url: CommonApi.structUrl(option: .userPage(page: page, id: id)))
        
        CommonApi.userPageHeaderRequest(completion: { data in
            self.userInfo = data
            guard let userData = self.userInfo else { return }
            guard let imageUrl = URL(string: userData.profileImageUrl) else { return }
            do {
                let imageData = try Data(contentsOf: imageUrl)
                self.userIcon.image = UIImage(data: imageData)
            } catch {
                self.userIcon.image = UIImage(named: "errorUserIcon")
                print("error: Can't get image")
            }
            self.userName.text = userData.name
            self.userId.text = "@\(userData.id)"
            self.id = userData.id
            if userData.description == nil {
                self.userIntroduction.text = "(設定されていません。)"
                self.userIntroduction.textColor = UIColor {_ in return #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)}
            } else {
                self.userIntroduction.text = userData.description
            }
            self.followCount.setTitle("\(userData.followeesCount) フォロー中", for: .normal)
            self.followerCount.setTitle("\(userData.followersCount) フォロワー", for: .normal)
        }, url: CommonApi.structUrl(option: .userPageHeader(id: id)))
        configureRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func pushFollowCount(_ sender: Any) {
        guard let nextVC: FollowPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "FollowPage") as? FollowPageViewController else { return }
        nextVC.tableViewInfo = .followees
        nextVC.userId = id
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func pushFollowerCount(_ sender: Any) {
        guard let nextVC: FollowPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "FollowPage") as? FollowPageViewController else { return }
        nextVC.tableViewInfo = .followers
        nextVC.userId = id
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func checkNetwork() {
        guard let isConnected = NetworkReachabilityManager()?.isReachable else { return }
        if !isConnected {
            presentNetworkErrorView()
            return
        }
    }
    
    func configureRefreshControl () {
        userArticlesList.refreshControl = UIRefreshControl()
        userArticlesList.refreshControl?.addTarget(self, action:#selector(handleRefreshControl), for: .valueChanged)
    }

    @objc func handleRefreshControl() {
        page = 1
        checkNetwork()
        
        CommonApi.userPageRequest(completion: { data in
            self.userArticles.removeAll()
            if data.isEmpty {
                self.checkNetwork()
            }
            data.forEach {
                self.userArticles.append($0)
            }
            self.userArticlesList.reloadData()
        }, url: CommonApi.structUrl(option: .userPage(page: page, id: id)))
        
        CommonApi.userPageHeaderRequest(completion: { data in
            self.userInfo = data
            guard let userData = self.userInfo else { return }
            guard let imageUrl = URL(string: userData.profileImageUrl) else { return }
            do {
                let imageData = try Data(contentsOf: imageUrl)
                self.userIcon.image = UIImage(data: imageData)
            } catch {
                self.userIcon.image = UIImage(named: "errorUserIcon")
                print("error: Can't get image")
            }
            self.userName.text = userData.name
            self.userId.text = "@\(userData.id)"
            self.id = userData.id
            if userData.description == nil {
                self.userIntroduction.text = "(設定されていません。)"
                self.userIntroduction.textColor = UIColor {_ in return #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)}
            } else {
                self.userIntroduction.text = userData.description
            }
            self.followCount.setTitle("\(userData.followeesCount) フォロー中", for: .normal)
            self.followerCount.setTitle("\(userData.followersCount) フォロワー", for: .normal)
        }, url: CommonApi.structUrl(option: .userPageHeader(id: id)))
        DispatchQueue.main.async {
            self.userArticlesList.refreshControl?.endRefreshing()
        }
    }
}

extension UserPageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserArticleCell", for: indexPath) as? UserPageCellViewController else {
            return UITableViewCell()
        }
        cell.setUserArticleCell(data: userArticles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //-10:基本的にはcountパラメータで20個の記事を取得してくるように指定しているので、20-10=10の10個目のセル、つまり最初に表示された半分までスクロールされたら、追加で記事を読み込む(ページネーション)するようになっています。
        if userArticles.count >= 20 && indexPath.row == ( userArticles.count - 10) {
            page += 1
            checkNetwork()
            
            CommonApi.userPageRequest(completion: { data in
                if data.isEmpty {
                    self.checkNetwork()
                }
                data.forEach {
                    self.userArticles.append($0)
                }
                self.userArticlesList.reloadData()
            }, url: CommonApi.structUrl(option: .userPage(page: page, id: id)))
        }
    }
}

extension UserPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let nextVC: QiitaArticlePageViewController = self.storyboard?.instantiateViewController(withIdentifier: "ArticlePage") as? QiitaArticlePageViewController else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        nextVC.articleUrl = userArticles[indexPath.row].url
        self.present(nextVC, animated: true, completion: nil)
    }
}

extension UserPageViewController: ReloadActionDelegate {
    
    func errorReload() {
        guard let isConnected = NetworkReachabilityManager()?.isReachable else { return }
        if isConnected {
            CommonApi.userPageRequest(completion: { data in
                self.userArticles.removeAll()
                if data.isEmpty {
                    self.checkNetwork()
                }
                data.forEach {
                    self.userArticles.append($0)
                }
                if !self.userArticles.isEmpty {
                    self.errorView.removeFromSuperview()
                }
                self.userArticlesList.reloadData()
            }, url: CommonApi.structUrl(option: .userPage(page: page, id: id)))
            
            CommonApi.userPageHeaderRequest(completion: { data in
                self.userInfo = data
                guard let userData = self.userInfo else { return }
                guard let imageUrl = URL(string: userData.profileImageUrl) else { return }
                do {
                    let imageData = try Data(contentsOf: imageUrl)
                    self.userIcon.image = UIImage(data: imageData)
                } catch {
                    self.userIcon.image = UIImage(named: "errorUserIcon")
                    print("error: Can't get image")
                }
                self.userName.text = userData.name
                self.userId.text = "@\(userData.id)"
                self.id = userData.id
                if userData.description == nil {
                    self.userIntroduction.text = "(設定されていません。)"
                    self.userIntroduction.textColor = UIColor {_ in return #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)}
                } else {
                    self.userIntroduction.text = userData.description
                }
                self.followCount.setTitle("\(userData.followeesCount) フォロー中", for: .normal)
                self.followerCount.setTitle("\(userData.followersCount) フォロワー", for: .normal)
            }, url: CommonApi.structUrl(option: .userPageHeader(id: id)))
        }
    }
}

extension UserPageViewController: PresentNetworkErrorViewDelegate {
    
    func presentNetworkErrorView() {
        errorView.center = self.view.center
        errorView.frame = self.view.frame
        self.view.addSubview(errorView)
    }
}
