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
    
    enum infoType: CaseIterable {
        case followers
        case followees
        
        var urlType: String {
            switch self {
            case .followers:
                return "followers"
            case .followees:
                return "followees"
            }
        }
        
        var settingSeggment: Int {
            switch self {
            case .followers:
                return 0
            case .followees:
                return 1
            }
        }
    }
    
    var userId = ""
    var urlType: String {
        return tableViewInfo.urlType
    }
    var tableViewInfo: infoType = .followers
    var userInfos: [UserItem] = []
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        followList.dataSource = self
        
        selectSegmentedIndex.selectedSegmentIndex = tableViewInfo.settingSeggment
        CommonApi.followPageRequest(completion: { data in
            data.forEach {
                self.userInfos.append($0)
            }
            self.followList.reloadData()
        }, url: CommonApi.structUrl(option: .FollowPage) + "\(userId)/\(urlType)?page=\(page)")
        
        configureRefreshControl()
    }
    
    @IBAction func switchButton(_ sender: UISegmentedControl) {
        tableViewInfo = infoType.allCases[sender.selectedSegmentIndex]
        userInfos.removeAll()
        page = 1
        CommonApi.followPageRequest(completion: { data in
            data.forEach {
                self.userInfos.append($0)
            }
            self.followList.reloadData()
        }, url: CommonApi.structUrl(option: .FollowPage) + "\(userId)/\(urlType)?page=\(page)")
    }
    
    func configureRefreshControl () {
        //RefreshControlを追加する処理
        followList.refreshControl = UIRefreshControl()
        followList.refreshControl?.addTarget(self, action:#selector(handleRefreshControl), for: .valueChanged)
    }

    @objc func handleRefreshControl() {
        
        if let isConnected = NetworkReachabilityManager()?.isReachable, !isConnected {
            print("Network error has not improved yet.")
        
        } else {
            page = 1
            CommonApi.followPageRequest(completion: { data in
                self.userInfos.removeAll()
                
                data.forEach {
                    self.userInfos.append($0)
                }
                self.followList.reloadData()
            }, url: CommonApi.structUrl(option: .FollowPage) + "\(userId)/\(urlType)?page=\(page)")
        }
        
        //上記の処理が終了したら下記が実行される
        DispatchQueue.main.async {
            self.followList.refreshControl?.endRefreshing()
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
            page += 1
            CommonApi.followPageRequest(completion: { data in
                data.forEach {
                    self.userInfos.append($0)
                }
                self.followList.reloadData()
            }, url: CommonApi.structUrl(option: .FollowPage) + "\(userId)/\(urlType)?page=\(page)")
        }
    }
}
