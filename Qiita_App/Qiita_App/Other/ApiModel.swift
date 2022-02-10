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
    var scopes = [String]()
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
    let iconUrl: String?
    let id: String
    let itemsCount: Int
}

struct UserArticleItem: Codable {
    let title: String
    let url: String
    let likesCount: Int
    var createdAt: String
}

struct UserHeader: Codable {
    var id: String
    var name: String
    var description: String?
    var profileImageUrl: String
    var followeesCount: Int
    var followersCount: Int
}

struct UserItem: Codable {
    var description: String?
    var name: String
    var profileImageUrl: String
    var id: String
    var followersCount: Int
    var itemsCount: Int
}
