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
    var userId = "0901_yasyun"
    var url = "https://qiita.com/api/v2/users/"
    var userInfos: [userInfo] = []
    
    struct userInfo: Decodable {
        var description: String?
        var name: String
        var profile_image_url: String
        var id: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                    try JSONDecoder().decode([userInfo].self,from:data)
                
                (0..<dataItem.count).forEach {
                    self.userInfos.append(dataItem[$0])
                    
                    if dataItem[$0].description == nil {
                        self.userInfos[$0].description = ""
                    }
                }
                
                print(self.userInfos)
                //self.qiitaArticle.reloadData()
                
            //TODO:エラー用の画面を実装する
            } catch let error {
                print("Error: \(error)")
            }
        }
    }
    
    func checkNum(_ number: String?) -> String {
        var numAnswer = ""
        if let num = number { //※ここが重要
            numAnswer = num
        }
        
        return numAnswer
    }
}
