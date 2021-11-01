//
//  CommonApi.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/09/10.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit
import Alamofire

class CommonApi {
    
    enum requestUrl {
        case FeedPage(page: Int, searchTitle: String)
        case tagPage(page: Int)
        case tagDetailPage(page: Int, tagTitle: String)
        case myPage(page: Int)
        case FollowPage
    }

    class func structUrl(option: requestUrl) -> String {
        switch option {
        case .FeedPage(let page, let searchTitle):
            return "https://qiita.com/api/v2/items?count=20&page=\(page)&query=title%3A\(searchTitle)"
        case .tagPage(let page):
            return "https://qiita.com/api/v2/tags?sort=count&page=\(page)"
        case .tagDetailPage(let page, let tagTitle):
            return "https://qiita.com/api/v2/items?count=20&page=\(page)&query=tag%3A\(tagTitle)"
        case .myPage(let page):
            return "https://qiita.com/api/v2/authenticated_user/items?page=\(page)"
        case .FollowPage:
            return "https://qiita.com/api/v2/users/"
        }
    }
    
    class func feedPageRequest(completion: @escaping([DataItem]) -> Void, url: String) {
        
        AF.request(
            url,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil
        )
        .response { response in

            guard let data = response.data else { return }
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let dataItem = try jsonDecoder.decode([DataItem].self,from:data)
                completion(dataItem)
            //TODO:エラー用の画面を実装する
            } catch let error {
                print("Error: \(error)")
            }
        }
    }
    
    class func tagPageRequest(completion: @escaping([TagItem]) -> Void, url: String) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + AccessTokenDerivery.shared.getAccessToken()
        ]
        
        AF.request(
            url,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers
        )
        .response { response in

            guard let data = response.data else { return }
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let dataItem = try jsonDecoder.decode([TagItem].self,from:data)
                completion(dataItem)
            //TODO:エラー用の画面を実装する
            } catch let error {
                print("Error: \(error)")
            }
        }
    }
    
    class func tagDetailPageRequest(completion: @escaping([DataItem]) -> Void, url: String) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + AccessTokenDerivery.shared.getAccessToken()
        ]
        
        AF.request(
            url,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers
        )
        .response { response in

            guard let data = response.data else { return }
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let dataItem = try jsonDecoder.decode([DataItem].self,from:data)
                completion(dataItem)
            //TODO:エラー用の画面を実装する
            } catch let error {
                print("Error: \(error)")
            }
        }
    }
    
    class func myPageRequest(completion: @escaping([MyItem]) -> Void, url: String) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + AccessTokenDerivery.shared.getAccessToken()
        ]
        
        AF.request(
            url,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers
        )
        .response { response in

            guard let data = response.data else { return }
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let dataItem = try jsonDecoder.decode([MyItem].self,from:data)
                
                completion(dataItem)
            //TODO:エラー用の画面を実装する
            } catch let error {
                print("Error: \(error)")
            }
        }
    }
    
    class func myPageHeaderRequest(completion: @escaping(UserInfo) -> Void, url: String) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + AccessTokenDerivery.shared.getAccessToken()
        ]
        
        AF.request(
            url,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers
        )
        .response { response in

            guard let data = response.data else { return }
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let myInfoItem = try jsonDecoder.decode([UserInfo].self,from:data)
                
                completion(myInfoItem[0])
            //TODO:エラー用の画面を実装する
            } catch let error {
                print("Error: \(error)")
            }
        }
    }
    
    class func followPageRequest(completion: @escaping([UserItem]) -> Void, url: String) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + AccessTokenDerivery.shared.getAccessToken()
        ]
        
        AF.request(
            url,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers
        )
        .response { response in
            
            guard let data = response.data else { return }
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let dataItem =
                    try jsonDecoder.decode([UserItem].self,from:data)
                
                completion(dataItem)
                
            //TODO:エラー用の画面を実装する
            } catch let error {
                print("Error: \(error)")
            }
        }
    }
}
