//
//  ViewController.swift
//  QiitaApi_App
//
//  Created by Sakai Syunya on 2021/02/22.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet var qiitaArticleTavleView: UITableView!
    
    let decoder: JSONDecoder = JSONDecoder()
    let table = UITableView()
    var articles: [[String: String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.frame = view.frame
        view.addSubview(table)
        table.dataSource = self
        table.delegate = self
        
        request()
    }
    
    func request() {
        
        AF.request(
            "https://qiita.com/api/v2/items",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil
        )
        .response { response in
            guard let data = response.data else { return }
            do {
                let dataItem: [DataItem] =
                    try JSONDecoder().decode([DataItem].self,from:data)
                
                var count = 0
                
                while count < dataItem.count {
                    let article: [String: String] =  ["title": dataItem[count].title,  "userName": dataItem[count].user.name, "url": dataItem[count].url]
                    
                    self.articles.append(article)
                    
                    count += 1
                }
                
                self.table.reloadData()
                
            } catch let error {
                print("Error: \(error)")
            }
        }
    }

}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let article = articles[indexPath.row]
               
        cell.textLabel?.text = article["title"]!
        cell.detailTextLabel?.text = article["userName"]!

        return cell
    }
    
}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SecondView") as! SecondViewController
        let article = articles[indexPath.row]
        
        nextVC.articleUrl = article["url"]!
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
