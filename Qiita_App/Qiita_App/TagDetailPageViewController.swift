//
//  TagDetailViewController.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/07/29.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit
import Alamofire

class TagDetailPageViewController: UIViewController {
    
    @IBOutlet var tagDetailArticle: UITableView!
    
    var tagName = ""
    var page = 1
    var articles: [DataItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = tagName
        
        tagDetailArticle.delegate = self
        tagDetailArticle.dataSource = self
        
        CommonApi.tagDetailPageRequest(completion: { data in
            data.forEach {
                self.articles.append($0)
            }
            
            self.tagDetailArticle.reloadData()
        }, url: CommonApi.structUrl(option: .tagDetailPage(page: page, tagTitle: tagName)))
    }
}

extension TagDetailPageViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? TagDetailPageCellViewController else {
            return UITableViewCell()
        }
        
        cell.setTagDetailArticleCell(data: articles[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //-10:基本的にはcountパラメータで20個の記事を取得してくるように指定しているので、20-10=10の10個目のセル、つまり最初に表示された半分までスクロールされたら、追加で記事を読み込む(ページネーション)するようになっています。
        if articles.count >= 20 && indexPath.row == ( articles.count - 10) {
            page += 1
            CommonApi.tagDetailPageRequest(completion: { data in
                data.forEach {
                    self.articles.append($0)
                }
                
                self.tagDetailArticle.reloadData()
            }, url: CommonApi.structUrl(option: .tagDetailPage(page: page, tagTitle: tagName)))
        }
    }
}

extension TagDetailPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let nextVC: QiitaArticlePageViewController = self.storyboard?.instantiateViewController(withIdentifier: "ArticlePage") as? QiitaArticlePageViewController else { return }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        nextVC.articleUrl = articles[indexPath.row].url
        
        self.present(nextVC, animated: true, completion: nil)
    }
    
}
