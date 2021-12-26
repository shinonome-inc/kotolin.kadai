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
    @IBOutlet var nonSearchResult: UIView!
    
    var accessToken = ""
    var page = 1
    var titleNum = 0
    var commonApi = CommonApi()
    var errorView = NetworkErrorView()
    var removeFlag = false
    var searchTextDeleteFlag = false
    var searchText = ""
    var articles: [DataItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        qiitaArticle.dataSource = self
        qiitaArticle.delegate = self
        searchBar.delegate = self
        errorView.reloadActionDelegate = self
        commonApi.presentNetworkErrorViewDelegate = self
        
        nonSearchResult.isHidden = true
        searchBar.enablesReturnKeyAutomatically = false
        
        checkNetwork()
        
        CommonApi().feedPageRequest(completion: { data in
            self.articleManagement()
            if data.isEmpty {
                self.presentNetworkErrorView()
            }
            
            data.forEach {
                self.articles.append($0)
            }
            
            self.checkSearchResults(articles: self.articles)
            self.qiitaArticle.reloadData()
        }, url: CommonApi.structUrl(option: .feedPage(page: page, searchTitle: searchText)))
    }
    
    func articleManagement() {
        if self.removeFlag || self.searchTextDeleteFlag {
            self.articles.removeAll()
            self.removeFlag = false
            self.searchTextDeleteFlag = false
        }
    }
    
    func checkSearchResults(articles: [DataItem]) {
        switch articles.count {
        case 0:
            qiitaArticle.isHidden = true
            nonSearchResult.isHidden = false
        default:
            qiitaArticle.isHidden = false
            nonSearchResult.isHidden = true
        }
    }
    
    func checkNetwork() {
        if let isConnected = NetworkReachabilityManager()?.isReachable, !isConnected {
            presentNetworkErrorView()
            return
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
            checkNetwork()
            page += 1
            CommonApi().feedPageRequest(completion: { data in
                self.articleManagement()
                if data.isEmpty {
                    self.presentNetworkErrorView()
                }
                
                data.forEach {
                    self.articles.append($0)
                }
                
                self.qiitaArticle.reloadData()
            }, url: CommonApi.structUrl(option: .feedPage(page: page, searchTitle: searchText)))
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
        page = 1
        removeFlag = text != ""
        
        if !removeFlag {
            searchTextDeleteFlag = true
        }
        
        checkNetwork()
        
        CommonApi().feedPageRequest(completion: { data in
            self.articleManagement()
            if data.isEmpty {
                self.presentNetworkErrorView()
            }
            
            data.forEach {
                self.articles.append($0)
            }
            
            self.checkSearchResults(articles: self.articles)
            self.qiitaArticle.reloadData()
        }, url: CommonApi.structUrl(option: .feedPage(page: page, searchTitle: searchText)))
    }
}

extension FeedPageViewController: ReloadActionDelegate {
    
    func errorReload() {
        if let isConnected = NetworkReachabilityManager()?.isReachable, !isConnected {
            print("Network error has not improved yet.")
        
        } else {
            qiitaArticle.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            CommonApi().feedPageRequest(completion: { data in
                self.articles.removeAll()
                if data.isEmpty {
                    self.presentNetworkErrorView()
                }
                
                data.forEach {
                    self.articles.append($0)
                }
                
                if !self.articles.isEmpty {
                    self.errorView.removeFromSuperview()
                }
                
                self.checkSearchResults(articles: self.articles)
                self.qiitaArticle.reloadData()
            }, url: CommonApi.structUrl(option: .feedPage(page: page, searchTitle: searchText)))
        }
    }
}

extension FeedPageViewController: PresentNetworkErrorViewDelegate {
    
    func presentNetworkErrorView() {
        errorView.center = self.view.center
        errorView.frame = self.view.frame
        self.view.addSubview(errorView)
    }
}
