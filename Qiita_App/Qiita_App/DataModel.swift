//
//  DataModel.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/05/09.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import Foundation

struct DataItem: Codable {
    let body: String
    let id: String
    let rendered_body: String
    let title: String
    let url: String
    var created_at: String
    var user: User
    struct User: Codable {
        var id: String
        var profile_image_url: String
    }
}
