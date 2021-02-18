//
//  UIView.swift
//  Delegate_App
//
//  Created by Sakai Syunya on 2021/02/12.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//
import UIKit

extension UIView {

    // 角丸設定
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
