//
//  NumberFormatter+Helpers.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 13/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

class NumberFormatterHelper {

    // MARK: - Formatters

    static let signedCurrency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en-AU")
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}
