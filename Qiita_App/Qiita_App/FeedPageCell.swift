//
//  FeedPageCellViewController.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/05/09.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit

class FeedPageCellViewController: UITableViewCell {
    
    @IBOutlet var userIcon: UIImageView!
    @IBOutlet var articleTitle: UILabel!
    @IBOutlet var articleInfo: UILabel!
    
    func setArticleCell(data: DataItem) {
        articleTitle.text = data.title
        articleInfo.text = "@\(data.user.id) 投稿日：\(SetDataFormat().dateFormat(formatTarget: data.createdAt)) LGTM：\(data.likesCount)"
        
        guard let imageUrl = URL(string: data.user.profileImageUrl) else { print("error: Can't get Userimage"); return }
        userIcon.setImageByDefault(with: imageUrl)
    }
    
}
