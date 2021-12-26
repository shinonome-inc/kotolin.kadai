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
        
        guard let icon = data.iconUrl else { return }
        guard let imageUrl = URL(string: icon) else { print("error: Can't get Tagimage"); return }
        tagIcon.setImageByDefault(with: imageUrl)
    }
}
