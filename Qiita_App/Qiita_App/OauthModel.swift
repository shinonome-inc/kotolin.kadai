//
//  OauthModel.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/07/26.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import Foundation

struct OauthItem: Codable {
    let client_id: String
    let scopes = [String]()
    let token: String
}
