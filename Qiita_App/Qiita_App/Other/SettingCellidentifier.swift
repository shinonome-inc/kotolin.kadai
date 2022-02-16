//
//  SettingCellidentifier.swift
//  Qiita_App
//
//  Created by 堺俊也 on 2022/02/16.
//  Copyright © 2022 Sakai Syunya. All rights reserved.
//

import UIKit

class SettingCellidentifier {
    
    enum cellType {
        case feedPage
        case tagPage
        case tagDetailPage
        case myPage
        case userPage
        case followPage
        
        var identifier: String {
            switch self {
            case .feedPage:
                return "ArticleCell"
            case .tagPage:
                return "TagCell"
            case .tagDetailPage:
                return "ArticleCell"
            case .myPage:
                return "MyArticleCell"
            case .userPage:
                return "UserArticleCell"
            case .followPage:
                return "UserCell"
            }
        }
    }
}
