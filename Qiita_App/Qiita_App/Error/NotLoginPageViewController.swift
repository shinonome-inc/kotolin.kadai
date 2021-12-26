//
//  NotLoginPageViewController.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/11/15.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit

class NotLoginPageViewController: UIView {
    
    var loginActionDelegate: LoginActionDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init() {
        super.init(frame: .zero)

        let view = UINib(nibName: "NotLoginPageViewController", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        addSubview(view)
    }
    
    @IBAction func loginButton(_ sender: Any) {
        guard let loginActionDelegate = loginActionDelegate else { return }
        loginActionDelegate.loginAction()
    }
}

protocol  LoginActionDelegate {
    func loginAction()
}
