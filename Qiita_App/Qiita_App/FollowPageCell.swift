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
    
    func setArticleCell(data: UserItem) {
        guard let imageUrl = URL(string: data.profileImageUrl) else { return }
        
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
        
        userName.text = data.name
        userId.text = data.id
        userInfo.text = "\(data.followersCount) フォロワー　Posts：\(data.itemsCount)"
        userIntroduction.text = data.description
    }
}
