//
//  SettingViewController.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/08/21.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit

class SettingsPageViewController: UITableViewController {
    
    enum tableViewType: CaseIterable {
        case appInfoCell
        case otherCell
        
        var numCells: Int {
            switch self {
            case .appInfoCell:
                return 3
            case .otherCell:
                return 1
            }
        }
    }
    
    enum transitionType: CaseIterable {
        case privacyPolicyPage
        case termOfServicePage
        case appVersion
        case logout
        
        var transionIdentifier: String {
            switch self {
            case .privacyPolicyPage:
                return "PrivacyPolicyPage"
            case .termOfServicePage:
                return "TermOfServicePage"
            case .appVersion:
                return "AppVersion"
            case .logout:
                return "TopPage"
            }
        }
    }
    
    var transitionIdentifier: String {
        return transitionInfo.transionIdentifier
    }
    var tableViewInfo: tableViewType = .appInfoCell
    var transitionInfo: transitionType = .privacyPolicyPage
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // セクションの数を返す
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // それぞれのセクション毎に何行のセルがあるかを返す
        tableViewInfo = tableViewType.allCases[section]
        
        return tableViewInfo.numCells
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            transitionInfo = .logout
        } else {
            transitionInfo = transitionType.allCases[indexPath.row]
        }
        
        switch transitionInfo {
        case .appVersion:
            guard let cell = tableView.cellForRow(at:indexPath) else { return }
            cell.selectionStyle = .none
        default:
            guard let nextVC = storyboard?.instantiateViewController(identifier: transitionIdentifier) else { return }
            
            if transitionInfo == .logout {
                nextVC.modalPresentationStyle = .fullScreen
                AccessTokenDerivery.shared.deleteAccessToken()
            }

            self.present(nextVC, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        switch indexPath.row {
        case 3:
            return nil
        default:
            return indexPath
        }
    }
}
