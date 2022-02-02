//
//  UserPageCell.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/10/04.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit

class UserPageCellViewController: UITableViewCell {
    
    @IBOutlet var articleTitle: UILabel!
    @IBOutlet var articleInfo: UILabel!
    
    func setUserArticleCell(data: UserArticleItem) {
        articleTitle.text = data.title
        articleInfo.text = "投稿日：\(SetDataFormat().dateFormat(formatTarget: data.createdAt)) LGTM：\(data.likesCount)"
    }
}
