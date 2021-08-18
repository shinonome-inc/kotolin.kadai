//
//  TagModel.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/06/25.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import Foundation

struct TagItem: Codable {
    //TODO:後でキャメルメースに変更
    let followersCount: Int
    let iconUrl: String
    let id: String
    let itemsCount: Int
}
