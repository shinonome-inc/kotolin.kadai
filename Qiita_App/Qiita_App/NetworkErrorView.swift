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
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        loadNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        loadNib()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()

        loadNib()
    }
    
    private func loadNib() {
        guard let errorView = UINib(nibName: "NetworkErrorView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else { return }
        errorView.frame = self.bounds
        addSubview(errorView)
    }
    
    @IBAction func reloadButton(_ sender: Any) {
        print("a")
        guard let reloadActionDelegate = reloadActionDelegate else { print("echo"); return}
        
        print(reloadActionDelegate)
        
        reloadActionDelegate.errorReload()
        self.isHidden = true
    }
}

protocol ReloadActionDelegate {
    func errorReload()
}
