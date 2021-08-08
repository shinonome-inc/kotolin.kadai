//
//  setTagDetailCell.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/07/29.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit

class TagDetailPageCellViewController: UITableViewCell {
    
    
    @IBOutlet var userIcon: EnhancedCircleImageView!
    @IBOutlet var articleTitle: UILabel!
    @IBOutlet var articleInfo: UILabel!
    
    func setTagDetailArticleCell(data: DataItem) {
        articleTitle.text = data.title
        articleInfo.text = "@\(data.user.id) 投稿日：\(SetDataFormat().dateFormat(formatTarget: data.createdAt)) LGTM：\(data.likesCount)"
        
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
