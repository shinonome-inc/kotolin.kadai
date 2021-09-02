//
//  ErrorPageViewController.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/09/02.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit

class ErrorPageViewController: UIViewController {
    
    @IBOutlet var errorTitle: UILabel!
    @IBOutlet var errorMessage: UILabel!
    
    var receiveErrorTitle = ""
    var receiveErrorMessage = ""
    
    override func viewDidLoad() {
        errorTitle.text = receiveErrorTitle
        errorMessage.text = receiveErrorMessage
    }
    
    
}
