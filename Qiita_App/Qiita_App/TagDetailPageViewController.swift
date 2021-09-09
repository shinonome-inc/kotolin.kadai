//
//  TagDetailViewController.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/07/29.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit
import Alamofire

class TagDetailPageViewController: UIViewController {
    
    @IBOutlet var tagDetailArticle: UITableView!
    
    var tagName = ""
    var page = 0
    let url = "https://qiita.com/api/v2/items?count=20"
    var articles: [DataItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = tagName
        
        tagDetailArticle.delegate = self
        tagDetailArticle.dataSource = self
        
        self.request()
    }
    
    //TODO: Alamofire部分共通化
    func request() {
        page += 1
        
        AF.request(
            url + "&page=\(page)&query=tag%3A\(tagName)",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil
        )
        .response { response in
            
            if let isConnected = NetworkReachabilityManager()?.isReachable, !isConnected {
                self.transitionErrorPage(errorTitle: "NetworkError")
            }
            
            guard let data = response.data else { return }
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let dataItem =
                    try jsonDecoder.decode([DataItem].self,from:data)
                
                dataItem.forEach {
                    self.articles.append($0)
                }
                
                self.tagDetailArticle.reloadData()
                
            } catch let error {
                print("This is error message -> : \(error)")
                self.transitionErrorPage(errorTitle: "SystemError")
            }
        }
    }
    
}

extension TagDetailPageViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? TagDetailPageCellViewController else {
            return UITableViewCell()
        }
        
        cell.setTagDetailArticleCell(data: articles[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //-10:基本的にはcountパラメータで20個の記事を取得してくるように指定しているので、20-10=10の10個目のセル、つまり最初に表示された半分までスクロールされたら、追加で記事を読み込む(ページネーション)するようになっています。
        if articles.count >= 20 && indexPath.row == ( articles.count - 10) {
            self.request()
        }
    }
}

extension TagDetailPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let nextVC: QiitaArticlePageViewController = self.storyboard?.instantiateViewController(withIdentifier: "ArticlePage") as? QiitaArticlePageViewController else { return }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        nextVC.articleUrl = articles[indexPath.row].url
        
        self.present(nextVC, animated: true, completion: nil)
    }
    
}
