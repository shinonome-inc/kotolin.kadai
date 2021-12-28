//
//  UIImageView+Extension.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/07/15.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit

extension UIImageView {

    func setImageByDefault(with url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if error == nil, case .some(let result) = data, let image = UIImage(data: result) {
                guard let unwrappedSelf = self else { return }
                DispatchQueue.main.sync {
                    unwrappedSelf.image = image
                }
            } else {
                DispatchQueue.main.sync {
                    self?.image = UIImage(named: "errorUserIcon")
                }
            }
        }.resume()
    }
}
