//
//  SettingsPageCell.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/08/21.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit

class SettingsPageCellViewController: UITableViewCell {
    
    @IBOutlet var appInfoTitle: UILabel!
    @IBOutlet var otherTitle: UILabel!
    @IBOutlet var cellIcon: UILabel!
    
    func setSettingsCell(title: String, tag: Int) {
        switch tag {
        case 1:
            appInfoTitle.text = title
            if title == "アプリバージョン" {
                cellIcon.text = "v1.0.0"
            }
        case 2:
            otherTitle.text = title
        default:
            print("error")
        }
    }
}
