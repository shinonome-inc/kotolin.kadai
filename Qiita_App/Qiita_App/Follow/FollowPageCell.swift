//
//  FollowPageCell.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/08/05.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit

class FollowPageCellViewController: UITableViewCell {
    
    @IBOutlet var userIcon: EnhancedCircleImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userId: UILabel!
    @IBOutlet var userInfo: UILabel!
    @IBOutlet var userIntroduction: UILabel!
    @IBOutlet var followCell: UIView!
    
    func setArticleCell(data: UserItem) {
        userName.text = data.name
        userId.text = data.id
        userInfo.text = "\(data.followersCount) フォロワー　Posts：\(data.itemsCount)"
        userIntroduction.text = data.description
        followCell.layer.borderColor = UIColor.lightGray.cgColor
        followCell.layer.borderWidth = 0.5
        followCell.layer.cornerRadius = 10
        guard let imageUrl = URL(string: data.profileImageUrl) else { print("error: Can't get Userimage"); return }
        userIcon.setImageByDefault(with: imageUrl)
    }
}
