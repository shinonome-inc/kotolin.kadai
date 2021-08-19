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
        //ToDo:Dataフォーマット変更
        articleTitle.text = data.title
        userId.text = "@\(data.user.id)"
        postData.text = "投稿日：\(SetDataFormat().dateFormat(formatTarget: data.createdAt))"
        
        guard let imageUrl = URL(string: data.user.profileImageUrl) else { print("error: Can't get Tagimage"); return }
        
        URLSession.shared.dataTask(with: imageUrl) { [weak self] data, response, error in
            
                if error == nil, case .some(let result) = data, let image = UIImage(data: result) {
                    
                    guard let unwrappedSelf = self else { return }
                    
                    DispatchQueue.main.sync {
                        unwrappedSelf.userIcon.image = image
                    }

                } else {
                    DispatchQueue.main.sync {
                        self?.userIcon.image = UIImage(named: "errorUserIcon")
                    }
                }
        }.resume()
    }
}
