//
//  NetworkErrorView.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/11/08.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit

class NetworkErrorView: UIView {
    
    var reloadActionDelegate: ReloadActionDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(frame: .zero)
        
        let view = UINib(nibName: "NetworkErrorView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        addSubview(view)
    }
    
    @IBAction func reloadButton(_ sender: Any) {
        guard let reloadActionDelegate = reloadActionDelegate else { print("echo"); return}
        reloadActionDelegate.errorReload()
    }
}

protocol ReloadActionDelegate {
    func errorReload()
}
