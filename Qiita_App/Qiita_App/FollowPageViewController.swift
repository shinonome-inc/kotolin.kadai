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
    
    var userId = "0901_yasyun"
    var url = "https://qiita.com/api/v2/users/"
    var userInfos: [UserItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        followList.delegate = self
        followList.dataSource = self
        
        url += "\(userId)/followees"
        request()
    }
    
    @IBAction func switchButton(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            url = "https://qiita.com/api/v2/users/\(userId)/followees"
            userInfos.removeAll()
            request()
        case 1:
            url = "https://qiita.com/api/v2/users/\(userId)/followers"
            userInfos.removeAll()
            request()
        default:
            print("URL Error")
        }
        
    }
    
    func request() {
        //page += 1
        
        AF.request(
            url,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil
        )
        .response { response in
            
            guard let data = response.data else { return }
            do {
                //let jsonDecoder = JSONDecoder()
               // JSONDecoder().keyDecodingStrategy = .convertFromSnakeCase
                
                let dataItem =
                    try JSONDecoder().decode([UserItem].self,from:data)
                
                (0..<dataItem.count).forEach {
                    self.userInfos.append(dataItem[$0])
                    
                    if dataItem[$0].description == nil {
                        self.userInfos[$0].description = ""
                    }
                }
                
                print(self.userInfos)
                self.followList.reloadData()
                
            //TODO:エラー用の画面を実装する
            } catch let error {
                print("Error: \(error)")
            }
        }
    }
}

extension FollowPageViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfos.count//userInfos.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return userInfos.count
    }
    
    internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? FollowPageCellViewController else {
            return UITableViewCell()
        }
        
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 10
        cell.setArticleCell(data: userInfos[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if userInfos.count >= 20 && indexPath.row == ( userInfos.count - 10) {
            self.request()
        }
    }
}

extension FollowPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
