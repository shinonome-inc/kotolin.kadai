//
//  MyPageModel.swift/Users/yasyun/mobile_sakai/Qiita_App/Qiita_App
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/07/26.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import Foundation

struct MyItem: Codable {
    let body: String
    let id: String
    let renderedBody: String
    let title: String
    let url: String
    var createdAt: String
    var user: User
    struct User: Codable {
        var id: String
        var name: String
        var description: String
        var profileImageUrl: String
        var followeesCount: Int
        var followersCount: Int
    }
}
