//
//  MyPageCellViewController.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/07/26.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit

class MyPageCellViewController: UITableViewCell {
    @IBOutlet var userId: UILabel!
    @IBOutlet var articleTitle: UILabel!
    @IBOutlet var articleInfo: UILabel!
    
    func setMyArticleCell(data: MyItem) {
        articleTitle.text = data.title
        userId.text = "@\(data.user.id)"
        articleInfo.text = "投稿日：\(SetDataFormat().dateFormat(formatTarget: data.createdAt)) LGTM：\(data.likesCount)"
    }
}
