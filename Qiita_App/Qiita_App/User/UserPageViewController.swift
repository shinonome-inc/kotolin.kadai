//
//  UserPageViewController.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/10/04.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit

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
    var page = 1
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userArticlesList.dataSource = self
        userArticlesList.delegate = self
        tabBarController?.tabBar.isHidden = true
        
        CommonApi.userPageRequest(completion: { data in
            data.forEach {
                self.userArticles.append($0)
            }
            self.userArticlesList.reloadData()
        }, url: CommonApi.structUrl(option: .UserPage(page: page, id: id)))
        
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
        }, url: CommonApi.structUrl(option: .UserPageHeader(id: id)))
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x:0, y:0, width: tableView.bounds.width, height: 50))
        label.text = "　　投稿記事"
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.backgroundColor = UIColor {_ in return #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)}
        label.textColor = UIColor {_ in return #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)}
        return label
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
