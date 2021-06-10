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
        guard let imageUrl = URL(string: data.icon_url) else { return }
        
        do{
            let image = UIImage(data: try Data(contentsOf: imageUrl))
            
            tagIcon.image = image
            
        } catch {
            print("error: Can't get Tagimage")
        }
        
        self.tagName.text = data.id
        self.tagCount.text = "記事件数：" + String(data.items_count)
        self.tagfollowers.text = "フォロワー数：" + String(data.followers_count)
    }
}
