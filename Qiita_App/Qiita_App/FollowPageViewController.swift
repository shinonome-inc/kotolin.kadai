//
//  File.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/08/04.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit
import Alamofire

class FollowPageViewController: UIViewController {

    @IBOutlet var selectSegmentedIndex: UISegmentedControl!
    @IBOutlet var followList: UITableView!
    
    enum infoType {
        case followers
        case followees
    }
    
    var userId = ""
    var urlType = ""
    var settingSegment: infoType = .followers
    var userInfos: [UserItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        followList.dataSource = self
        
        switch settingSegment {
        case .followers:
            selectSegmentedIndex.selectedSegmentIndex = 0
            urlType = "followers"
        case .followees:
            selectSegmentedIndex.selectedSegmentIndex = 1
            urlType = "followees"
        }
        
        CommonApi.followPageRequest(completion: { data in
            self.createUserInfos(userData: data)
            self.followList.reloadData()
        }, url: CommonApi.structUrl(option: .FollowPage) + "\(userId)/\(urlType)")
    }
    
    @IBAction func switchButton(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            urlType = "followers"
            userInfos.removeAll()
            CommonApi.followPageRequest(completion: { data in
                self.createUserInfos(userData: data)
                self.followList.reloadData()
            }, url: CommonApi.structUrl(option: .FollowPage) + "\(userId)/\(urlType)")
        case 1:
            urlType = "followees"
            userInfos.removeAll()
            CommonApi.followPageRequest(completion: { data in
                self.createUserInfos(userData: data)
                self.followList.reloadData()
            }, url: CommonApi.structUrl(option: .FollowPage) + "\(userId)/\(urlType)")
        default:
            //TODO:エラー用の画面を実装する
            print("URL Error")
        }
    }
    
    func createUserInfos(userData: [UserItem]) {
        (0..<userData.count).forEach {
            self.userInfos.append(userData[$0])
            
            if userData[$0].description == nil {
                self.userInfos[$0].description = ""
            }
        }
    }
}

extension FollowPageViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? FollowPageCellViewController else {
            return UITableViewCell()
        }
        
        cell.setArticleCell(data: userInfos[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if userInfos.count >= 20 && indexPath.row == ( userInfos.count - 10) {
            CommonApi.followPageRequest(completion: { data in
                self.createUserInfos(userData: data)
                self.followList.reloadData()
            }, url: CommonApi.structUrl(option: .FollowPage) + "\(userId)/\(urlType)")
        }
    }
}
