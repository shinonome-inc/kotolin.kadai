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

class QiitaOAuthPageViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet var QiitaOAuthPage: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        QiitaOAuthPage.uiDelegate = self
        QiitaOAuthPage.navigationDelegate = self
        
        let oauthURL = URL(string:"https://qiita.com/api/v2/oauth/authorize?client_id=5703a0e3ecb356ae07cc2fec78aa8fe3262f28d9&scope=readqiita&state=da41606a962f9e8b6b554359c3a9801c9cd0dd7c")!

        let request = URLRequest(url: oauthURL)

        QiitaOAuthPage.load(request)
    }
    
    static func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
}

extension QiitaOAuthPageViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            
        if navigationAction.request.url?.scheme == "syunya-app", navigationAction.request.url?.host == "qiitasearch.com" {

            // 認証コード取得
            //let feedPage = storyboard?.instantiateViewController(withIdentifier: "FeedPage") as? FeedPageViewController
            
            let code = QiitaOAuthPageViewController.getQueryStringParameter(url: (navigationAction.request.url?.absoluteString)!, param: "code")

            let accessTokenUrl = "https://qiita.com/api/v2/access_tokens"
            
            let params: Parameters = [
                "client_id": "5703a0e3ecb356ae07cc2fec78aa8fe3262f28d9",
                "client_secret": "da41606a962f9e8b6b554359c3a9801c9cd0dd7c",
                "code": code!,
            ]

            AF.request(
                accessTokenUrl,
                method: .post,
                parameters: params,
                encoding: JSONEncoding.default,
                headers: nil
            )
            .response{ response in
                
                switch response.result {
                case .success:
                    let result = String(data: response.value!!, encoding: .utf8)
                    //var token = ""
                    //token = Dictionary(response.value!!)
                    //feedPage?.accessToken = result!
                    print(result!)
                    
                case .failure(let error):
                    print(error)
                }
            }
            print(params)
            
            let nextVC = storyboard?.instantiateViewController(identifier: "MainTabBar")
            nextVC?.modalPresentationStyle = .fullScreen
            self.present(nextVC!, animated: true, completion: nil)
            
        }
        
        decisionHandler(.allow)
    }
}
