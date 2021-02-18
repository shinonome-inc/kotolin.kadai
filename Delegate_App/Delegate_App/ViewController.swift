//
//  ViewController.swift
//  Delegate_App
//
//  Created by Sakai Syunya on 2021/02/08.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CustomDelegate {
    
    @IBOutlet var customView: CustomView!
    @IBOutlet weak var width: NSLayoutConstraint!
    @IBOutlet weak var height: NSLayoutConstraint!
    
    /*override func viewDidLoad() {
        super.viewDidLoad()
        
    }*/
    
    func custom() {
        width.constant = 0
        height.constant = 0
        customView.isHidden = true
    }
}
