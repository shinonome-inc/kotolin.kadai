//
//  UserInfoModel.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/08/28.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import Foundation

struct UserInfo: Codable {
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
