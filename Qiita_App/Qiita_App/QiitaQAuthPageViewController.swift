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
    let secretKeys = SecretKey()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        QiitaOAuthPage.uiDelegate = self
        QiitaOAuthPage.navigationDelegate = self
        
        let oauthURL = secretKeys.oauth
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
            
            guard let code = QiitaOAuthPageViewController.getQueryStringParameter(url: (navigationAction.request.url?.absoluteString)!, param: "code") else { return }

            let accessTokenUrl = "https://qiita.com/api/v2/access_tokens"
            
            let params: Parameters = [
                "client_id": secretKeys.clientId,
                "client_secret": secretKeys.clientSecret,
                "code": code,
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
                    guard let unwrappedResponse = response.value as? Data else { return }
                    let result = String(data: unwrappedResponse, encoding: .utf8)
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
