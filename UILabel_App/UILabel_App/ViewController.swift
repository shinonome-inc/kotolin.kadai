//
//  ViewController.swift
//  UILabel_App
//
//  Created by Sakai Syunya on 2020/11/01.
//  Copyright © 2020 Sakai Syunya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    @IBOutlet weak var label_1: UILabel!
    @IBOutlet weak var label_2: UILabel!
    @IBOutlet weak var label_3: UILabel!
    @IBOutlet weak var label_4: UILabel!
    @IBOutlet weak var label_5: UILabel!
    @IBOutlet weak var label_6: UILabel!
    @IBOutlet weak var label_7: UILabel!
    @IBOutlet weak var label_8: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label_1.layer.borderWidth = 2.0
        label_1.layer.borderColor = UIColor(hex: "5AC8FA").cgColor
        label_1.layer.cornerRadius = 20.0
        label_1.clipsToBounds = true
        
        label_2.layer.borderWidth = 2.0
        label_2.layer.borderColor = UIColor(hex: "5AC8FA").cgColor
        
        label_3.layer.borderWidth = 2.0
        
        label_5.font = UIFont.boldSystemFont(ofSize: 20)
        
        label_6.shadowColor = UIColor.black
        label_6.layer.shadowOffset = CGSize(width: 2, height: 2)
        label_6.layer.shadowRadius = 4
        label_6.layer.shadowOpacity = 0.2
        
        label_8.numberOfLines = 3
    }


}

