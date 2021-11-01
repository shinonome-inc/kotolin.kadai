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
    
    func setSettingsCell(title: String, tableViewType: SettingsPageViewController.tableViewType) {
        switch tableViewType {
        case .appInfoCell:
            appInfoTitle.text = title
            if title == "アプリバージョン" {
                cellIcon.text = "v\(String(describing: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")))"
            }
        case .otherCell:
            otherTitle.text = title
        }
    }
}
