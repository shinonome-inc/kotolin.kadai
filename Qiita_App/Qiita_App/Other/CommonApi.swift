//
//  CommonApi.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/09/10.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import Alamofire

class CommonApi {
    
    var presentNetworkErrorViewDelegate: PresentNetworkErrorViewDelegate?
    
    enum requestUrl {
        case feedPage(page: Int, searchTitle: String)
        case tagPage(page: Int)
        case tagDetailPage(page: Int, tagTitle: String)
        case myPage(page: Int)
        case myPageHeader
        case userPage(page: Int, id: String)
        case userPageHeader(id: String)
        case followPage
    }
    
    class func structUrl(option: requestUrl) -> String {
        switch option {
        case .feedPage(let page, let searchTitle):
            return "https://qiita.com/api/v2/items?count=20&page=\(page)&query=title%3A\(searchTitle)"
        case .tagPage(let page):
            return "https://qiita.com/api/v2/tags?sort=count&page=\(page)"
        case .tagDetailPage(let page, let tagTitle):
            return "https://qiita.com/api/v2/items?count=20&page=\(page)&query=tag%3A\(tagTitle)"
        case .myPage(let page):
            return "https://qiita.com/api/v2/authenticated_user/items?page=\(page)"
        case .myPageHeader:
            return "https://qiita.com/api/v2/authenticated_user"
        case .userPage(let page, let id):
            return "https://qiita.com/api/v2/users/\(id)/items?page=\(page)"
        case .userPageHeader(let id):
            return "https://qiita.com/api/v2/users/\(id)"
        case .followPage:
            return "https://qiita.com/api/v2/users/"
        }
    }
    
    func feedPageRequest(completion: @escaping([DataItem]) -> Void, url: String) {
        
        AF.request(
            url,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil
        )
        .response { response in
            guard let data = response.data else {
                let emptyData: [DataItem] = []
                completion(emptyData)
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let dataItem = try jsonDecoder.decode([DataItem].self,from:data)
                completion(dataItem)
            } catch let error {
                print("This is error message -> : \(error)")
                let emptyData: [DataItem] = []
                completion(emptyData)
            }
        }
    }
    
    func tagPageRequest(completion: @escaping([TagItem]) -> Void, url: String) {
        var headers: HTTPHeaders?
        let accessToken: HTTPHeaders = [
            "Authorization": "Bearer " + AccessTokenDerivery.shared.getAccessToken()
        ]
        if AccessTokenDerivery.shared.getAccessToken().isEmpty {
            headers = nil
        } else {
            headers = accessToken
        }
        
        AF.request(
            url,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers
        )
        .response { response in
            guard let data = response.data else {
                let emptyData: [TagItem] = []
                completion(emptyData)
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let dataItem = try jsonDecoder.decode([TagItem].self,from:data)
                completion(dataItem)
            } catch let error {
                print("This is error message -> : \(error)")
                let emptyData: [TagItem] = []
                completion(emptyData)
            }
        }
    }
    
    class func tagDetailPageRequest(completion: @escaping([DataItem]) -> Void, url: String) {
        var headers: HTTPHeaders?
        let accessToken: HTTPHeaders = [
            "Authorization": "Bearer " + AccessTokenDerivery.shared.getAccessToken()
        ]
        if AccessTokenDerivery.shared.getAccessToken().isEmpty {
            headers = nil
        } else {
            headers = accessToken
        }
        
        AF.request(
            url,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers
        )
        .response { response in
            guard let data = response.data else {
                let emptyData: [DataItem] = []
                completion(emptyData)
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let dataItem = try jsonDecoder.decode([DataItem].self,from:data)
                completion(dataItem)
            } catch let error {
                print("This is error message -> : \(error)")
                let emptyData: [DataItem] = []
                completion(emptyData)
            }
        }
    }
    
    func myPageRequest(completion: @escaping([UserArticleItem]) -> Void, url: String) {
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
            guard let data = response.data else {
                let emptyData: [UserArticleItem] = []
                completion(emptyData)
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let dataItem = try jsonDecoder.decode([UserArticleItem].self,from:data)
                completion(dataItem)
            } catch let error {
                print("This is error message -> : \(error)")
                let emptyData: [UserArticleItem] = []
                completion(emptyData)
            }
        }
    }
    
    class func myPageHeaderRequest(completion: @escaping(UserHeader) -> Void, url: String) {
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
                let myInfoItem = try jsonDecoder.decode(UserHeader.self,from:data)
                completion(myInfoItem)
            //TODO:エラー用の画面を実装する
            } catch let error {
                print("This is error message -> : \(error)")
            }
        }
    }
    
    class func userPageRequest(completion: @escaping([UserArticleItem]) -> Void, url: String) {
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
                let dataItem = try jsonDecoder.decode([UserArticleItem].self,from:data)
                completion(dataItem)
            } catch let error {
                print("Error: \(error)")
            }
        }
    }
    
    class func userPageHeaderRequest(completion: @escaping(UserHeader) -> Void, url: String) {
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
                let userInfoItem = try jsonDecoder.decode(UserHeader.self,from:data)
                completion(userInfoItem)
            } catch let error {
                print("Error: \(error)")
            }
        }
    }
    
    func myPageHeaderRequest(completion: @escaping(UserHeader) -> Void, url: String) {
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
                let myInfoItem = try jsonDecoder.decode([UserHeader].self,from:data)
                completion(myInfoItem[0])
            } catch let error {
                print("This is error message -> : \(error)")
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
            guard let data = response.data else {
                let emptyData: [UserItem] = []
                completion(emptyData)
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let dataItem = try jsonDecoder.decode([UserItem].self,from:data)
                completion(dataItem)
            } catch let error {
                print("This is error message -> : \(error)")
                let emptyData: [UserItem] = []
                completion(emptyData)
            }
        }
    }
}

protocol PresentNetworkErrorViewDelegate {
    func presentNetworkErrorView()
}
