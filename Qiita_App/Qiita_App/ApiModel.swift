//
//  ApiModel.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/09/16.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import Foundation

// ネストしているstructにはインデントあけてます
struct OauthItem: Codable {
    let client_id: String
    let scopes = [String]()
    let token: String
}

struct DataItem: Codable {
    let title: String
    let url: String
    var likesCount: Int
    var createdAt: String
    var user: User
}

    struct User: Codable {
        var id: String
        var profileImageUrl: String
    }

struct TagItem: Codable {
    let followersCount: Int
    let iconUrl: String
    let id: String
    let itemsCount: Int
}

struct MyItem: Codable {
    let title: String
    let url: String
    let likesCount: Int
    var createdAt: String
}

struct UserInfo: Codable {
    var user: MyHeader
}

    struct MyHeader: Codable {
        var id: String
        var name: String
        var description: String
        var profileImageUrl: String
        var followeesCount: Int
        var followersCount: Int
    }
