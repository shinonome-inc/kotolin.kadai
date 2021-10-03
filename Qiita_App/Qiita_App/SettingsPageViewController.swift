//
//  SettingViewController.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/08/21.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit

class SettingsPageViewController: UIViewController {
    
    @IBOutlet var appInfoList: UITableView!
    @IBOutlet var otherList: UITableView!
    
    enum tableViewType: CaseIterable {
        case appInfoCell
        case otherCell
        
        var cellIdentifier: String {
            switch self {
            case .appInfoCell:
                return "AppInfoCell"
            case .otherCell:
                return "OtherCell"
            }
        }
        
        var cellTitle: [String] {
            switch self {
            case .appInfoCell:
                return ["プライバシーポリシー", "利用規約", "アプリバージョン"]
            case .otherCell:
                return ["ログアウトする"]
            }
        }
        
        var cellHeader: String {
            switch self {
            case .appInfoCell:
                return "アプリ情報"
            case .otherCell:
                return "その他"
            }
        }
        
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
        
        var transionIdentifier: String {
            switch self {
            case .privacyPolicyPage:
                return "PrivacyPolicyPage"
            case .termOfServicePage:
                return "TermOfServicePage"
            }
        }
    }
    
    var cellTitle: [String] {
        return tableViewInfo.cellTitle
    }
    var cellIdentifier: String {
        return tableViewInfo.cellIdentifier
    }
    var transitionIdentifier: String {
        return transitionInfo.transionIdentifier
    }
    var tableViewInfo: tableViewType = .appInfoCell
    var transitionInfo: transitionType = .privacyPolicyPage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appInfoList.delegate = self
        appInfoList.dataSource = self
        otherList.delegate = self
        otherList.dataSource = self
    }
}

extension SettingsPageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewInfo = tableViewType.allCases[tableView.tag - 1]
        return tableViewInfo.numCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableViewInfo = tableViewType.allCases[tableView.tag - 1]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SettingsPageCellViewController else {
            return UITableViewCell()
        }
        
        // アプリバージョンのセルのみ選択不可
        if cellIdentifier == "AppInfoCell" && indexPath.row == 2 {
            cell.selectionStyle = .none
        }
        
        cell.setSettingsCell(title: cellTitle[indexPath.row], tableViewType: tableViewInfo)

        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableViewInfo = tableViewType.allCases[tableView.tag - 1]
        
        switch tableViewInfo {
        case .appInfoCell:
            if indexPath.row == 2 {
                return nil
            }
            return indexPath
        case .otherCell:
            return indexPath
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        tableViewInfo = tableViewType.allCases[tableView.tag - 1]
        
        return tableViewInfo.cellHeader
    }
}

extension SettingsPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableViewInfo = tableViewType.allCases[tableView.tag - 1]
        transitionInfo = transitionType.allCases[indexPath.row]
        
        switch tableViewInfo {
        case .appInfoCell:
            guard let nextVC = storyboard?.instantiateViewController(identifier: transitionIdentifier) else { return }
            
            tableView.deselectRow(at: indexPath, animated: true)
            
            self.present(nextVC, animated: true, completion: nil)
            
        case .otherCell:
            guard let nextVC = storyboard?.instantiateViewController(identifier: "TopPage") else { return }
            nextVC.modalPresentationStyle = .fullScreen
            AccessTokenDerivery.shared.deleteAccessToken()
            tableView.deselectRow(at: indexPath, animated: true)
            
            self.present(nextVC, animated: true, completion: nil)
        }
    }
    
}
