//
//  QiitaArticlePageViewController.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/05/09.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit
import WebKit

class QiitaArticlePageViewController: UIViewController {
    
    @IBOutlet var qiitaArticle: WKWebView!
    var articleUrl = ""
    var commonApi = CommonApi()
    var errorView = NetworkErrorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qiitaArticle.navigationDelegate = self
        
        errorView.reloadActionDelegate = self
        commonApi.presentNetworkErrorViewDelegate = self
        
        guard let unwrappedUrl = URL(string: articleUrl) else { return }
        let request = URLRequest(url: unwrappedUrl)
        self.qiitaArticle.load(request)
    }
}

extension QiitaArticlePageViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error)
        presentNetworkErrorView()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error)
        presentNetworkErrorView()
    }
}

extension QiitaArticlePageViewController: ReloadActionDelegate {
    
    func errorReload() {
        print("qiitaArticlePage")
        
        guard let unwrappedUrl = URL(string: articleUrl) else { return }
        let request = URLRequest(url: unwrappedUrl)
        self.qiitaArticle.load(request)
        
        // TableView側のネットワーク復旧を確認してからerrorViewを閉じる
        CommonApi().feedPageRequest(completion: { data in
            if !data.isEmpty {
                self.errorView.removeFromSuperview()
            }
        }, url: CommonApi.structUrl(option: .feedPage(page: 1, searchTitle: "")))
    }
}

extension QiitaArticlePageViewController: PresentNetworkErrorViewDelegate {
    
    func presentNetworkErrorView() {
        errorView.center = self.view.center
        errorView.frame = self.view.frame
        self.view.addSubview(errorView)
    }
}
