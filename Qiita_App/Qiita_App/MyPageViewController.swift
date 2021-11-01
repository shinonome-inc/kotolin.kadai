//
//  MyPageViewController.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/07/26.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit
import Alamofire

class MyPageViewController: UIViewController {
    @IBOutlet var myArticlesList: UITableView!
    @IBOutlet var myIcon: UIImageView!
    @IBOutlet var myName: UILabel!
    @IBOutlet var myId: UILabel!
    @IBOutlet var myIntroduction: UILabel!
    @IBOutlet var followCount: UIButton!
    @IBOutlet var followerCount: UIButton!
    @IBOutlet var myPageErrorView: UIView!
    @IBOutlet var networkErrorView: UIView!
    
    var myArticles: [MyItem] = []
    var myInfo: UserInfo?
    var page = 1
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myArticlesList.dataSource = self
        myArticlesList.delegate = self
        
        self.myPageErrorView.isHidden = true
        self.networkErrorView.isHidden = true
        
        if let isConnected = NetworkReachabilityManager()?.isReachable, !isConnected {
            self.transitionErrorPage(errorTitle: "NetworkError")
            self.networkErrorView.isHidden = false
            return
        }
        
        CommonApi.myPageRequest(completion: { data in
            if data.isEmpty {
                self.myPageErrorView.isHidden = false
                return
            }
            
            data.forEach {
                self.myArticles.append($0)
            }
            
            self.myArticlesList.reloadData()
        }, url: CommonApi.structUrl(option: .myPage(page: page)))
        
        CommonApi.myPageHeaderRequest(completion: { data in
            self.myInfo = data
            
            guard let myData = self.myInfo?.user else { return }
            
            guard let imageUrl = URL(string: myData.profileImageUrl) else { return }
            
            do {
                let imageData = try Data(contentsOf: imageUrl)
                self.myIcon.image = UIImage(data: imageData)
            } catch {
                self.myIcon.image = UIImage(named: "errorUserIcon")
                print("error: Can't get image")
            }
            
            self.myName.text = myData.name
            self.myId.text = "@\(myData.id)"
            self.id = myData.id
            self.myIntroduction.text = myData.description
            self.followCount.setTitle("\(myData.followeesCount) フォロー中", for: .normal)
            self.followerCount.setTitle("\(myData.followersCount) フォロワー", for: .normal)
        }, url: CommonApi.structUrl(option: .myPage(page: page)))
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

extension MyPageViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyArticleCell", for: indexPath) as? MyPageCellViewController else {
            return UITableViewCell()
        }
        
        cell.setMyArticleCell(data: myArticles[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "投稿記事"
    }
}

extension MyPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let nextVC: QiitaArticlePageViewController = self.storyboard?.instantiateViewController(withIdentifier: "ArticlePage") as? QiitaArticlePageViewController else { return }
        
        tableView.deselectRow(at: indexPath, animated: true)
        nextVC.articleUrl = myArticles[indexPath.row].url
        self.present(nextVC, animated: true, completion: nil)
    }
    
}
