//
//  MyPageCellViewController.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/07/26.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit

class MyPageCellViewController: UITableViewCell {
    @IBOutlet var userIcon: UIImageView!
    @IBOutlet var userId: UILabel!
    @IBOutlet var postData: UILabel!
    @IBOutlet var articleTitle: UILabel!
    
    func setMyArticleCell(data: MyItem) {
        guard let imageUrl = URL(string: data.user.profileImageUrl) else { return }
        
        do {
            let imageData = try Data(contentsOf: imageUrl)
            guard let image = UIImage(data: imageData) else { return }
            userIcon.image = image
        } catch {
            print("error: Can't get image")
        }
        
        //ToDo:Dataフォーマット変更
        articleTitle.text = data.title
        userId.text = "@" + data.user.id
        postData.text = "投稿日：" + data.createdAt
    }
}
