//
//  UIImageView+Extension.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/06/10.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit

extension UIImageView {
    func circle() {
        layer.masksToBounds = false
        layer.cornerRadius = frame.size.width/2
        clipsToBounds = true
    }
}
