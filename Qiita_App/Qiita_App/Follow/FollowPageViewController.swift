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
    var commonApi = CommonApi()
    var errorView = NetworkErrorView()
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        followList.dataSource = self
        followList.delegate = self
        errorView.reloadActionDelegate = self
        commonApi.presentNetworkErrorViewDelegate = self
        checkNetwork()
        selectSegmentedIndex.selectedSegmentIndex = tableViewInfo.settingSeggment
        
        CommonApi.followPageRequest(completion: { data in
            if data.isEmpty {
                self.presentNetworkErrorView()
            }
            data.forEach {
                self.userInfos.append($0)
            }
            self.followList.reloadData()
        }, url: CommonApi.structUrl(option: .followPage) + "\(userId)/\(urlType)")
        configureRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func switchButton(_ sender: UISegmentedControl) {
        tableViewInfo = infoType.allCases[sender.selectedSegmentIndex]
        checkNetwork()
        userInfos.removeAll()
        page = 1
        
        CommonApi.followPageRequest(completion: { data in
            if data.isEmpty {
                self.presentNetworkErrorView()
            }
            data.forEach {
                self.userInfos.append($0)
            }
            self.followList.reloadData()
        }, url: CommonApi.structUrl(option: .followPage) + "\(userId)/\(urlType)")
    }
    
    func checkNetwork() {
        if let isConnected = NetworkReachabilityManager()?.isReachable, !isConnected {
            presentNetworkErrorView()
            return
        }
    }
    
    func configureRefreshControl () {
        followList.refreshControl = UIRefreshControl()
        followList.refreshControl?.addTarget(self, action:#selector(handleRefreshControl), for: .valueChanged)
    }

    @objc func handleRefreshControl() {
        page = 1
        CommonApi.followPageRequest(completion: { data in
            self.userInfos.removeAll()
            if data.isEmpty {
                self.presentNetworkErrorView()
            }
            data.forEach {
                self.userInfos.append($0)
            }
            self.followList.reloadData()
        }, url: CommonApi.structUrl(option: .followPage) + "\(userId)/\(urlType)?page=\(page)")
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? FollowPageCellViewController else {
            return UITableViewCell()
        }
        cell.setArticleCell(data: userInfos[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if userInfos.count >= 20 && indexPath.row == ( userInfos.count - 10) {
            page += 1
            checkNetwork()
            
            CommonApi.followPageRequest(completion: { data in
                data.forEach {
                    self.userInfos.append($0)
                }
                self.followList.reloadData()
            }, url: CommonApi.structUrl(option: .followPage) + "\(userId)/\(urlType)")
        }
    }
}

extension FollowPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let nextVC: UserPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserPage") as? UserPageViewController else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        nextVC.id = userInfos[indexPath.row].id
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension FollowPageViewController: ReloadActionDelegate {
    
    func errorReload() {
        guard let isConnected = NetworkReachabilityManager()?.isReachable else { return }
        if isConnected {
            CommonApi.followPageRequest(completion: { data in
                self.userInfos.removeAll()
                if data.isEmpty {
                    self.presentNetworkErrorView()
                }
                data.forEach {
                    self.userInfos.append($0)
                }
                if !self.userInfos.isEmpty {
                    self.errorView.removeFromSuperview()
                }
                self.followList.reloadData()
            }, url: CommonApi.structUrl(option: .followPage) + "\(userId)/\(urlType)")
        }
    }
}

extension FollowPageViewController: PresentNetworkErrorViewDelegate {
    
    func presentNetworkErrorView() {
        errorView.center = self.view.center
        errorView.frame = self.view.frame
        self.view.addSubview(errorView)
    }
}
