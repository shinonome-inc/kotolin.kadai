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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setCell(data: DataItem) {
        let imageUrl = URL(string: data.user.profile_image_url as String)
        do{
            let imageData = try Data(contentsOf: imageUrl!)
            var image = UIImage(data: imageData)
            
            image = image?.scaleImage(scaleSize: 0.1)
            
            //print(data.title as String)
            //print(image!.size)
            self.userIcon.image = image
            userIcon.circle()
        } catch {
            print("error: Can't get image")
        }
        self.articleTitle.text = data.title as String
        self.userId.text = "@" + data.user.id as String
        self.postData.text = "投稿日：" + data.created_at as String
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

func trimmingImage(_ image: UIImage, trimmingArea: CGRect) -> UIImage {
    let imgRef = image.cgImage?.cropping(to: trimmingArea)
    let trimImage = UIImage(cgImage: imgRef!, scale: image.scale, orientation: image.imageOrientation)
    return trimImage
}

extension UIImage {
    
    func reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height));
        let reSizeImage:UIImage! = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return reSizeImage;
    }

    func scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
}

extension UIImageView {
    func circle() {
        layer.masksToBounds = false
        layer.cornerRadius = frame.size.width/2
        clipsToBounds = true
    }
}
