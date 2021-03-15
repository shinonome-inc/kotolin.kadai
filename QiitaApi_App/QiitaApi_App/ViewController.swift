//
//  ViewController.swift
//  QiitaApi_App
//
//  Created by Sakai Syunya on 2021/02/22.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet var qiitaArticleTavleView: UITableView!
    
    let table = UITableView()
    var articles: [DataItem] = []
    
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
                let dataItem =
                    try JSONDecoder().decode([DataItem].self,from:data)
                
                
                dataItem.forEach {
                    self.articles.append($0)
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
        
        cell.textLabel?.text = articles[indexPath.row].title
        
        cell.detailTextLabel?.text = articles[indexPath.row].user.name

        return cell
    }
    
}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let nextVC: SecondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SecondView") as? SecondViewController else { return }
        
        nextVC.articleUrl = articles[indexPath.row].url
        
        guard (self.navigationController?.pushViewController(nextVC, animated: true)) != nil else { return }
    }
}
