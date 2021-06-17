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
    @IBOutlet var userId: UILabel!
    @IBOutlet var postData: UILabel!
    
    //TODO:UserIconの画像のサイズはこれから要調整
    func setArticleCell(data: DataItem) {
        guard let imageUrl = URL(string: data.user.profileImageUrl) else { return }
        
        do{
            let imageData = try Data(contentsOf: imageUrl)
            guard let image = UIImage(data: imageData)?.scaleImage(scaleSize: 0.1) else { return }
            //print(data.title as String)
            //print(image!.size)
            userIcon.image = image
            userIcon.circle()
        } catch {
            print("error: Can't get image")
        }
        
        //ToDo:Dataフォーマット変更
        articleTitle.text = data.title
        userId.text = "@" + data.user.id
        postData.text = "投稿日：" + data.createdAt
    }
    
}

func trimmingImage(_ image: UIImage, trimmingArea: CGRect) -> UIImage {
    guard let imgRef = image.cgImage?.cropping(to: trimmingArea) else { return UIImage() }
    let trimImage = UIImage(cgImage: imgRef, scale: image.scale, orientation: image.imageOrientation)
    return trimImage
}
