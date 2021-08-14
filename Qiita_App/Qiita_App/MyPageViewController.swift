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
    
    var url = "https://qiita.com/api/v2/authenticated_user/items"
    var myArticles: [MyItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myArticlesList.dataSource = self
        myArticlesList.delegate = self
        
        self.request()
    }
    
    func request() {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + AccessTokenDerivery.shared.getAccessToken()
        ]
        
        print(headers)
        
        AF.request(
            url,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers
        )
        .response { response in
            
            guard let data = response.data else { return }
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let dataItem =
                    try jsonDecoder.decode([MyItem].self,from:data)
                
                dataItem.forEach {
                    self.myArticles.append($0)
                }
                
                self.myArticlesList.reloadData()
                
            //TODO:エラー用の画面を実装する
            } catch let error {
                print("Error: \(error)")
            }
        }
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
        
        let myData = myArticles[0].user
        
        myName.text = myData.name
        myId.text = "@\(myData.id)"
        myIntroduction.text = myData.description
        followCount.setTitle("\(myData.followeesCount) フォロー中", for: .normal)
        followerCount.setTitle("\(myData.followersCount) フォロワー", for: .normal)
        
        guard let imageUrl = URL(string: myData.profileImageUrl) else { return UITableViewCell() }
        
        do {
            let imageData = try Data(contentsOf: imageUrl)
            myIcon.image = UIImage(data: imageData)
            myIcon.circle()
        } catch {
            print("error: Can't get image")
        }
        
        cell.setMyArticleCell(data: myArticles[indexPath.row])

        return cell
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
