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
    
    var cellTitle: [String] = []
    
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
        switch tableView.tag {
        case 1: return 3
        case 2: return 1
        default: return 0
        }
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier = ""
        
        switch tableView.tag {
        case 1:
            cellIdentifier = "AppInfoCell"
            cellTitle = ["プライバシーポリシー", "利用規約", "アプリバージョン"]
            print(cellTitle[indexPath.row])
        case 2:
            cellIdentifier = "OtherCell"
            cellTitle = ["ログアウトする"]
        default:
            print("error")
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SettingsPageCellViewController else {
            return UITableViewCell()
        }
        
        cell.setSettingsCell(title: cellTitle[indexPath.row])

        return cell
    }
}

extension SettingsPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var identifier = ""
        
        switch tableView.tag {
        case 1:
            if indexPath.row == 0 {
                identifier = "PrivacyPolicyPage"
                
            } else if indexPath.row == 1 {
                identifier = "TermOfServicePage"
            }
            
            guard let nextVC = storyboard?.instantiateViewController(identifier: identifier) else { return }
            
            tableView.deselectRow(at: indexPath, animated: true)
            
            self.present(nextVC, animated: true, completion: nil)
            
        case 2:
            guard let nextVC = storyboard?.instantiateViewController(identifier: "TopPage") else { return }
            nextVC.modalPresentationStyle = .fullScreen
            tableView.deselectRow(at: indexPath, animated: true)
            
            self.present(nextVC, animated: true, completion: nil)
            
        default:
            print("error")
        }
    }
    
}
