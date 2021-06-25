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
    
    //UserIconの画像のサイズの調整はこれで良いのか
    func setArticleCell(date: DataItem) {
        guard let imageUrl = URL(string: date.user.profileImageUrl) else { return }
        
        do{
            let imageData = try Data(contentsOf: imageUrl)
            guard let image = UIImage(data: imageData) else { return }
            
            var remakeImage = image
            
            if image.size.height > 300 && image.size.width > 300 {
                while(remakeImage.size.height > 50 && remakeImage.size.width > 50) {
                    
                    //ここもう少しいい書き方があるはず
                    guard let resizeImage = remakeImage.resized(withPercentage: 0.9) else { return }
                    
                    remakeImage = resizeImage
                }
            
            } else {
                if image.size.height > 50 && image.size.width > 50 {
                    remakeImage = trimmingImage(image, trimmingArea: CGRect(x: (image.size.width/2)-25, y: (image.size.height/2)-25, width: 50, height: 50))
                }
            }
            
            print(date.user.id)
            print(image.size)
            userIcon.image = remakeImage
            userIcon.circle(image: remakeImage)
        } catch {
            print("error: Can't get image")
        }
        
        //Dateのフォーマット変更
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = date.createdAt
        dateFormat.timeStyle = .none
        dateFormat.dateStyle = .medium
        dateFormat.locale = Locale(identifier: "ja_JP")
        
        let formattedDate = StringToDate(dateValue: date.createdAt, format: "yyyy-MM-dd'T'HH:mm'+'HH:mm")
        
        articleTitle.text = date.title
        articleInfo.text = "@" + date.user.id + " 投稿日：" + dateFormat.string(from: formattedDate) + " LGTM：" + String(date.likesCount)
    }
    
}

func trimmingImage(_ image: UIImage, trimmingArea: CGRect) -> UIImage {
    guard let imgRef = image.cgImage?.cropping(to: trimmingArea) else { return UIImage() }
    let trimImage = UIImage(cgImage: imgRef, scale: image.scale, orientation: image.imageOrientation)
    return trimImage
}

func StringToDate(dateValue: String, format: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = Calendar(identifier: .gregorian)
    dateFormatter.dateFormat = format
    return dateFormatter.date(from: dateValue) ?? Date()
}
