//
//  TagModel.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/06/03.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import Foundation

//TODO:後でキャメルメースに変更
struct TagItem: Codable {
    let followers_count: Int
    let icon_url: String
    let id: String
    let items_count: Int
}
