//
//  asa.swift
//  yalla
//
//  Created by MuhammadAli Yo'lbarsbekov on 31/10/25.
//

import SwiftUI
import IldamSDK
import Core

extension OrderHistoryItem {
    var date: Date? {
        Date.init(timeIntervalSince1970: dateTime)
    }
    
    var time: String {
        date?.toExtendedString(format: "HH:mm") ?? ""
    }
    
    var dateTimeString: String {
        date?.toExtendedString(format: "dd.MM.yyyy, HH:mm") ?? ""
    }
    
    public var dateString: String {
        let date = Date.init(timeIntervalSince1970: dateTime)
        if Calendar.current.isDateInToday(date) {
            return "today".localize
        }
        
        if Calendar.current.isDateInYesterday(date) {
            return "yesterday".localize
        }
        
        return date.toExtendedString(format: "dd.MM.yyyy")
    }
}
