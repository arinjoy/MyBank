//
//  DateFormatter+Helpers.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 12/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

extension DateFormatter {
    convenience init(format: String) {
        self.init()
        dateFormat = format
        locale = Locale.current
    }
}

extension String {
    func toDate(format: String) -> Date? {
        return DateFormatter(format: format).date(from: self)
    }
}
