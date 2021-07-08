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
        guard let imageUrl = URL(string: data.user.profileImageUrl) else { return }
        
        do{
            let imageData = try Data(contentsOf: imageUrl)
            guard let image = UIImage(data: imageData) else { return }
            userIcon.image = image
        } catch {
            print("error: Can't get image")
        }
        
        //Dateのフォーマット変更
        let format = DateFormatter()
        let articleDate = SetDataFormat().dateFormat(format: format, defaultFormat: "yyyy-MM-dd'T'HH:mm'+'HH:mm", formatTarget: data.createdAt)
        
        articleTitle.text = data.title
        articleInfo.text = "@\(data.user.id) 投稿日：\(format.string(from: articleDate)) LGTM：\(data.likesCount)"
    }
    
}
