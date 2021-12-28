//
//  AccessTokenDelivery.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/07/26.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit

final public class AccessTokenDerivery {
    
    var token = ""
    private init() {}
    public static let shared = AccessTokenDerivery()
    
    public func getAccessToken() -> String {
        return token
    }
    
    public func setAccessToken(key: String) {
        token = key
    }
    
    public func deleteAccessToken() {
        token = ""
    }
}
