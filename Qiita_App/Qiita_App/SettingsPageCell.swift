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
    
    func setSettingsCell(title: String) {
        appInfoTitle.text = title
    }
}
