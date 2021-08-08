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
        
        let format = DateFormatter()
        let articleDate = SetDataFormat().dateFormat(format: format, defaultFormat: "yyyy-MM-dd'T'HH:mm'+'HH:mm", formatTarget: data.createdAt)
        
        articleTitle.text = data.title
        articleInfo.text = "@\(data.user.id) 投稿日：\(format.string(from: articleDate)) LGTM：\(data.likesCount)"
        
        guard let imageUrl = URL(string: data.user.profileImageUrl) else { return }
        
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
