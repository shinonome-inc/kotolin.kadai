//
//  NotLoginPageViewController.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/11/15.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit

class NotLoginPageViewController: UIViewController {
    
    @IBAction func loginButton(_ sender: Any) {
        guard let nextVC = storyboard?.instantiateViewController(withIdentifier: "TopPage") else { return }
        
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
    
}
