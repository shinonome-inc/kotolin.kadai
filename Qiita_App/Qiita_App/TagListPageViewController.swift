//
//  TagListPageViewController.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/06/03.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit
import Alamofire

class TagListPageViewController: UIViewController {
    
    @IBOutlet var qiitaTag: UICollectionView!
    var tagInfo: [TagItem] = []
    var url = "https://qiita.com/api/v2/tags?sort=count"
    var page = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        qiitaTag.dataSource = self
        qiitaTag.delegate = self
        
        self.request()
    }
    
    
    func request() {
        
        page += 1
        
        AF.request(
            url,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil
        )
        .response { response in
            
            guard let data = response.data else { return }
            do {
                //let jsonDecoder = JSONDecoder()
                //jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let tagItem =
                    try JSONDecoder().decode([TagItem].self,from:data)
                
                tagItem.forEach {
                    self.tagInfo.append($0)
                }
                
                self.qiitaTag.reloadData()
                
            //TODO:エラー用の画面を実装する
            } catch let error {
                print("Error: \(error)")
            }
        }
    }
}

extension TagListPageViewController: UICollectionViewDelegate {
    /*private func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }*/
}

extension TagListPageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as? TagListCellViewController else {
            return UICollectionViewCell()
        }
        
        cell.setTagCell(data: tagInfo[indexPath.row])
        
        return cell
    }
    
    
}
