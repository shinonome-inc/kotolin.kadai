//
//  ErrorPageViewController.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/09/02.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit

class ErrorPageViewController: UIViewController {
    
    var receiveErrorTitle = ""
    var receiveErrorMessage = ""
   // var errorContents = ErrorType.OtherError
    
//    enum ErrorType {
//        case SystemError
//        case NetworkError
//        case OtherError
//
//        var decideErrorTitle: String {
//            switch self {
//            case .SystemError:
//                return "システムエラー"
//            case .NetworkError:
//                return "ネットワークエラー"
//            case .OtherError:
//                return "その他のエラー"
//            }
//        }
//
//        var decideErrorMessage: String {
//            switch self {
//            case .SystemError:
//                return "再読み込みしてください"
//            case .NetworkError:
//                return "お手数ですが電波の良い場所で再度読み込みをお願いします"
//            case .OtherError:
//                return "お手数ですが製作者までご連絡ください"
//            }
//        }
//
//        var errorIcon: UIImage? {
//            switch self {
//            case .SystemError:
//                return UIImage(systemName: "exclamationmark.icloud.fill")
//            case .NetworkError:
//                return UIImage(systemName: "wifi.exclamationmark")
//            case .OtherError:
//                return UIImage(systemName: "arrow.2.circlepath.circle.fill")
//            }
//        }
//    }
    
    @IBAction func reloadAction(_ sender: Any) {
        let nextVC = storyboard?.instantiateViewController(identifier: "TopPage")
        nextVC?.modalPresentationStyle = .fullScreen
        
        self.present(nextVC!, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //errorHandling(errorType: errorContents)
    }
    
//    func errorHandling(errorType: ErrorType) {
//        guard errorType.errorIcon != nil else { return }
//
//        errorTitle.text = errorType.decideErrorTitle
//        errorMessage.text = errorType.decideErrorMessage
//        errorIcon.image = errorType.errorIcon
//    }
}
