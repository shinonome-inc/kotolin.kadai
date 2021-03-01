//
//  DataModel.swift
//  QiitaApi_App
//
//  Created by Sakai Syunya on 2021/02/22.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import Foundation

struct DataItem: Codable{
    let body: String
    let id: String
    let rendered_body: String
    let title: String
    let url: String
    var user: User
    struct User: Codable {
        var name: String
    }
}
