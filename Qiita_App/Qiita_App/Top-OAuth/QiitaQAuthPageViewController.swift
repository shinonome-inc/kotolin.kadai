//
//  QiitaQAuthPageViewController.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/05/09.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

class QiitaOAuthPageViewController: UIViewController {
    
    @IBOutlet var qiitaOAuthPage: WKWebView!
    let secretKeys = SecretKey()
    var commonApi = CommonApi()
    var errorView = NetworkErrorView()
    var urlRequestFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qiitaOAuthPage.navigationDelegate = self
        
        errorView.reloadActionDelegate = self
        commonApi.presentNetworkErrorViewDelegate = self
        
        checkNetwork()
        
        let oauthURL = secretKeys.oauth
        let request = URLRequest(url: oauthURL)
        qiitaOAuthPage.load(request)
        urlRequestFlag = true
    }
    
    static func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
    func checkNetwork() {
        if let isConnected = NetworkReachabilityManager()?.isReachable, !isConnected {
            presentNetworkErrorView()
            return
        }
    }
}

extension QiitaOAuthPageViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.request.url?.scheme == "syunya-app", navigationAction.request.url?.host == "qiitasearch.com" {
            guard
                let url = navigationAction.request.url?.absoluteString,
                let code = QiitaOAuthPageViewController.getQueryStringParameter(url: url, param: "code") else {
                    return
            }
            let accessTokenUrl = "https://qiita.com/api/v2/access_tokens"
            let params: Parameters = [
                "client_id": secretKeys.clientId,
                "client_secret": secretKeys.clientSecret,
                "code": code,
            ]

            checkNetwork()
            
            AF.request(
                accessTokenUrl,
                method: .post,
                parameters: params,
                encoding: JSONEncoding.default,
                headers: nil
            )
            .response{ response in
                guard let data = response.data else {
                    self.presentNetworkErrorView()
                    return
                }
                do {
                    let dataItem = try JSONDecoder().decode(OauthItem.self,from:data)
                    AccessTokenDerivery.shared.setAccessToken(key: dataItem.token)
                } catch let error {
                    print("This is error message -> : \(error)")
                    
                }
            }
            let nextVC = storyboard?.instantiateViewController(identifier: "MainTabBar")
            nextVC?.modalPresentationStyle = .fullScreen
            self.present(nextVC!, animated: true, completion: nil)
        }
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error)
        presentNetworkErrorView()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error)
        presentNetworkErrorView()
    }
}

extension QiitaOAuthPageViewController: ReloadActionDelegate {
    
    func errorReload() {
        print("qiitaArticlePage")
        
        // 認証ページを開くタイミングでネットワークエラーが発生した場合
        if urlRequestFlag {
            let oauthURL = secretKeys.oauth
            let request = URLRequest(url: oauthURL)
            qiitaOAuthPage.load(request)
            urlRequestFlag = true
        
        // 認証ページで「認証」ボタンを押したタイミングでネットワークエラーが発生した場合
        } else if !urlRequestFlag {
            urlRequestFlag = false
        }
        
        self.errorView.removeFromSuperview()
    }
}

extension QiitaOAuthPageViewController: PresentNetworkErrorViewDelegate {
    
    func presentNetworkErrorView() {
        errorView.center = self.view.center
        errorView.frame = self.view.frame
        self.view.addSubview(errorView)
    }
}


