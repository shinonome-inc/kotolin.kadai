//
//  MyPageModel.swift/Users/yasyun/mobile_sakai/Qiita_App/Qiita_App
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/07/26.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import Foundation

struct MyItem: Codable {
    let title: String
    let url: String
    let likesCount: Int
    var createdAt: String
}
