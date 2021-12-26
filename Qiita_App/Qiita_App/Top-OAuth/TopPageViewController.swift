//
//  ViewController.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/04/08.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

class TopPageViewController: UIViewController, WKNavigationDelegate {
    
    @IBAction func loginButton(_ sender: Any) {
        let storyboard: UIStoryboard = self.storyboard!
        let OAuthPage = storyboard.instantiateViewController(withIdentifier: "OAuthPage")

        self.present(OAuthPage, animated: true, completion: nil)
    }
    
    @IBAction func notLoguinButton(_ sender: Any) {
        guard let nextVC = storyboard?.instantiateViewController(identifier: "MainTabBar") else { return }
        nextVC.modalPresentationStyle = .fullScreen
        AccessTokenDerivery.shared.deleteAccessToken()
        
        self.present(nextVC, animated: true, completion: nil)
    }
}
