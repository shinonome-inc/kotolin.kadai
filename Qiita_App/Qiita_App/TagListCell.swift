//
//  TagListCell.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/06/05.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit

class TagListCellViewController: UICollectionViewCell {
    
    
    @IBOutlet var tagIcon: UIImageView!
    @IBOutlet var tagName: UILabel!
    @IBOutlet var tagCount: UILabel!
    @IBOutlet var tagfollowers: UILabel!
    
    
    func setTagCell(data: TagItem) {
        tagName.text = data.id
        tagCount.text = "記事件数：" + String(data.itemsCount)
        tagfollowers.text = "フォロワー数：" + String(data.followersCount)
        
        guard let imageUrl = URL(string: data.iconUrl) else { print("error: Can't get Tagimage"); return }
        
        URLSession.shared.dataTask(with: imageUrl) { [weak self] data, response, error in
            
                if error == nil, case .some(let result) = data, let image = UIImage(data: result) {
                    
                    guard let unwrappedSelf = self else { return }
                    
                    DispatchQueue.main.sync {
                        unwrappedSelf.tagIcon.image = image
                    }

                } else {
                    DispatchQueue.main.sync {
                        self?.tagIcon.image = UIImage(named: "errorUserIcon")
                    }
                }
        }.resume()
    }
}
