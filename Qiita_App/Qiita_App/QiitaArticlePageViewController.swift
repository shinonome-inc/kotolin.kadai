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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = NSURLRequest(url: NSURL(string: articleUrl)! as URL)
        
        self.qiitaArticle.load(request as URLRequest)
    }
}
