//
//  DataFormate.swift
//  Qiita_App
//
//  Created by Sakai Syunya on 2021/07/01.
//  Copyright © 2021 Sakai Syunya. All rights reserved.
//

import UIKit

class SetDataFormat {
    
    func dateFormat(formatTarget: String) -> String {
        let format = DateFormatter()
        format.dateFormat = formatTarget
        format.timeStyle = .none
        format.dateStyle = .medium
        format.locale = Locale(identifier: "ja_JP")
        return format.string(from: StringToDate(dateValue: formatTarget, format: "yyyy-MM-dd'T'HH:mm'+'HH:mm"))
    }

    func StringToDate(dateValue: String, format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: dateValue) ?? Date()
    }
}
