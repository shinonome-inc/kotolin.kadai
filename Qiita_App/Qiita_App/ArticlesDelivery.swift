//
//  ArticlesDelivery.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/09/12.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit

final public class ArticleDerivery {
    var article: [DataItem] = []
    
    private init() {}
    
    public static let articleShared = ArticleDerivery()
    
    func getArticles() -> [DataItem] {
        print("get:\(article)")
        return article
    }
    
    func setArticles(key: [DataItem]) {
        article = key
    }
}
