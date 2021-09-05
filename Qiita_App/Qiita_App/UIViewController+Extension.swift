//
//  UIViewController+Extension.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/09/05.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit

extension UIViewController {
    func transitionNetworkError() {
        guard let nextVC: ErrorPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "ErrorPage") as? ErrorPageViewController else { return }
        
        nextVC.errorContents = .NetworkError
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
}
