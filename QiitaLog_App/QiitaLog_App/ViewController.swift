//
//  ViewController.swift
//  QiitaLog_App
//
//  Created by Sakai Syunya on 2020/12/20.
//  Copyright © 2020 Sakai Syunya. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    func request(){
        AF.request(
            "https://qiita.com/api/v2/items",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil
        )
        .response { response in
            guard let data = response.data else { return }
            do {let dataItem: [DataItem] = try JSONDecoder().decode([DataItem].self, from: data)
                print(dataItem)
            }
            catch let error {
                print("Error: \(error)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        request()
        
    }


}

