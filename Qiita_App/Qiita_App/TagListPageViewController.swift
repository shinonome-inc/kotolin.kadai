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
    var page = 1
    let margin: CGFloat = 16
    var viewWidth: CGFloat {
        return view.frame.width
    }
    let cellWidth: CGFloat = 162
    let cellHeight: CGFloat = 138
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        qiitaTag.dataSource = self
        qiitaTag.delegate = self
        
        CommonApi.tagPageRequest(completion: { data in
            data.forEach {
                self.tagInfo.append($0)
            }
            
            self.qiitaTag.reloadData()
        }, url: CommonApi.structUrl(option: .tagPage(page: page)))
    }

    func calcItemsPerRows() -> Int {
        let maxItemsPerRows = (viewWidth + margin) / (cellWidth + margin)
        let minItemsPerRows = (viewWidth - cellWidth) / (cellWidth + margin)
        let hasDecimal = (Int(minItemsPerRows + 1) == Int(maxItemsPerRows))
        let itemsperRows = hasDecimal ? Int(maxItemsPerRows) : Int(minItemsPerRows)
        return itemsperRows
    }
        
    func calcLeftAndRightInsets(itemsPerRows: Int) -> CGFloat {
        let inset = 0.5 * (viewWidth + margin - CGFloat(itemsPerRows) * (cellWidth + margin))
        return inset
    }
    
}

extension TagListPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let itemsPerRow = calcItemsPerRows()
        let inset = calcLeftAndRightInsets(itemsPerRows: itemsPerRow)
        
        return UIEdgeInsets(top: 16, left: inset, bottom: 16, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension TagListPageViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let nextVC: TagDetailPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "TagDetailPage") as? TagDetailPageViewController else { return }
        
        nextVC.tagName = tagInfo[indexPath.row].id
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        page += 1
        // TODO: レイアウトが崩れる原因ここの閾値にあるかも
        if tagInfo.count >= 20 && indexPath.row == ( tagInfo.count - 10) {
            CommonApi.tagPageRequest(completion: { data in
                data.forEach {
                    self.tagInfo.append($0)
                }
                
                self.qiitaTag.reloadData()
            }, url: CommonApi.structUrl(option: .tagPage(page: page)))
        }
    }
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
        cell.contentView.layer.borderColor = (UIColor {_ in return #colorLiteral(red: 0.9022639394, green: 0.9022851586, blue: 0.9022737145, alpha: 1)}).cgColor
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layoutIfNeeded()
        
        return cell
    }
    
}
