//
//  ErrorPageViewController.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/09/02.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit

class ErrorPageViewController: UIViewController {
    
    @IBAction func reloadAction(_ sender: Any) {
        let nextVC = storyboard?.instantiateViewController(identifier: "TopPage")
        nextVC?.modalPresentationStyle = .fullScreen
        self.present(nextVC!, animated: true, completion: nil)
    }
}
