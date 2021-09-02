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
    var removeFlag = false
    var searchTextDeleteFlag = false
    var searchText = ""
    var url = "https://qiita.com/api/v2/items?count=20"
    var articles: [DataItem] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        qiitaArticle.dataSource = self
        qiitaArticle.delegate = self
        searchBar.delegate = self
        
        searchBar.enablesReturnKeyAutomatically = false
        
        self.request()
    }
    
    func request() {
        page += 1
        
        AF.request(
            url + "&page=\(page)&query=title%3A\(searchText)",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil
        )
        .response { response in
            
            if let isConnected = NetworkReachabilityManager()?.isReachable, !isConnected {
                guard let nextVC: ErrorPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "ErrorPage") as? ErrorPageViewController else { return }
                
                nextVC.receiveErrorTitle = "インターネットエラー"
                nextVC.receiveErrorMessage =  "お手数ですが電波の良い場所で 再度読み込みをお願いします"
                nextVC.modalPresentationStyle = .fullScreen
                self.present(nextVC, animated: true, completion: nil)
            }
            
            guard let data = response.data else { return }
            do {
                let jsonDecoder = JSONDecoder()
                //jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
                // ページネーションの際は記事の中身を削除しないようにするため
                if self.removeFlag {
                    self.articles.removeAll()
                    self.removeFlag = false
                }
                
                if self.searchTextDeleteFlag {
                    self.articles.removeAll()
                    self.searchTextDeleteFlag = false
                }
                
                let dataItem =
                    try jsonDecoder.decode([DataItem].self,from:data)
                
                dataItem.forEach {
                    self.articles.append($0)
                }
                
                self.qiitaArticle.reloadData()
                
            //TODO:エラー用の画面を実装する
            } catch let error {
                print("This is error message -> : \(error)")
                guard let nextVC: ErrorPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "ErrorPage") as? ErrorPageViewController else { return }
                
                //nextVC.receiveErrorMessage = String(error)
                nextVC.modalPresentationStyle = .fullScreen
                self.present(nextVC, animated: true, completion: nil)
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
        
        cell.setArticleCell(data: articles[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //-10:基本的にはcountパラメータで20個の記事を取得してくるように指定しているので、20-10=10の10個目のセル、つまり最初に表示された半分までスクロールされたら、追加で記事を読み込む(ページネーション)するようになっています。
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
        
        self.present(nextVC, animated: true, completion: nil)
    }
    
}

//ワードで検索できるAPIに変更しました
extension FeedPageViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
        guard let text = searchBar.text else { return }
        
        searchText = text
        page = 0
        print(searchText)
        removeFlag = text != ""
        
        if !removeFlag {
            searchTextDeleteFlag = true
        }
        
        self.request()
    }
    
}
