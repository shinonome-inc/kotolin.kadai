//
//  02-Feed Page_ViewController.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/04/14.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit
import Alamofire

class FeedPageViewController: UIViewController {
    
    @IBOutlet var qiitaArticle: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    var accessToken = ""
    var page = 0
    var titleNum = 0
    var url = "https://qiita.com/api/v2/items?count=20&page="
    var articles: [DataItem] = []
    var searchResult: [DataItem] = []
    var articleTitles: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        qiitaArticle.dataSource = self
        qiitaArticle.delegate = self
        searchBar.delegate = self
        
        searchBar.enablesReturnKeyAutomatically = false
        
        print("accessToken: ", self.accessToken)
        
        self.request()
    }
    
    func request() {
        page += 1
        
        AF.request(
            url + String(page),
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil
        )
        .response { response in
            
            guard let data = response.data else { return }
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let dataItem =
                    try jsonDecoder.decode([DataItem].self,from:data)
                
                dataItem.forEach {
                    self.articles.append($0)
                }
                
                self.qiitaArticle.reloadData()
                
            //TODO:エラー用の画面を実装する
            } catch let error {
                print("Error: \(error)")
            }
        }
    }
    
}

extension FeedPageViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? FeedPageCellViewController else {
            return UITableViewCell()
        }
        
        articleTitles.append(articles[indexPath.row].title)
        
        //TODO:ロジックの中身要修正(修正前に現在のロジックをissueへ記載)
        articleTitles.forEach() { title1 in
            var overlapping = 0
            articleTitles.forEach() { title2 in
                
                if(title1 == title2) {
                    overlapping += 1
                }
                
                if(overlapping > 1) {
                    articleTitles.remove(at: titleNum)
                }
            }
            titleNum += 1
        }
        
        titleNum = 0
        cell.setArticleCell(data: articles[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if articles.count >= 20 && indexPath.row == ( articles.count - 10) {
            self.request()
        }
    }
}

extension FeedPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let nextVC: QiitaArticlePageViewController = self.storyboard?.instantiateViewController(withIdentifier: "ArticlePage") as? QiitaArticlePageViewController else { return }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        nextVC.articleUrl = articles[indexPath.row].url
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

//TODO:ワードで検索できるAPIに変更
extension FeedPageViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchResult.removeAll()
        page = 0
        
        if let text = searchBar.text {
            if text == "" {
                request()
            } else {
                for data in articleTitles {
                    if data.contains(searchBar.text!) {
                        articles.forEach(){nowArticle in
                            if(data == nowArticle.title) {
                                searchResult.append(nowArticle)
                            }
                        }
                    }
                }
            }
            
            articles.removeAll()
            articleTitles.removeAll()
            articles = searchResult
            qiitaArticle.reloadData()
        }
    }
}
