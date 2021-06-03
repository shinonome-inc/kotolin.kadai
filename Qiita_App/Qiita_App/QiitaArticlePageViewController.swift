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
        
        guard let unwrappedUrl = URL(string: articleUrl) else { return }
        let request = URLRequest(url: unwrappedUrl)
        self.qiitaArticle.load(request)
    }
}
