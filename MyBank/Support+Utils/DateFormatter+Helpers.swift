//
//  DateFormatter+Helpers.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 12/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

class DateFormattingHelper {

    static let mediumDate: DateFormatter = {
        let fomatter = DateFormatter()
        fomatter.locale = Locale(identifier: "en_AU")
        fomatter.dateFormat = "dd MMM yyyy"
        return fomatter
    }()
    
    static let shortDate: DateFormatter = {
        let fomatter = DateFormatter()
        fomatter.locale = Locale(identifier: "en_AU")
        fomatter.dateFormat = "d/MM/yyyy"
        return fomatter
    }()
}

class DateComponentsHelper {
    
    static let yearMonthDayCompact: DateComponentsFormatter = {
        let fomatter = DateComponentsFormatter()
        fomatter.maximumUnitCount = 1
        fomatter.unitsStyle = .full
        fomatter.allowedUnits = [.year, .month, .day]
        return fomatter
    }()
}
