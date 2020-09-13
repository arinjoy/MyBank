//
//  MyBank+StringKeys.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 12/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

extension StringKeys {
    
    enum MyBank: String, LocalizationKeys {
        
        case accountDetailsHeading = "account.details.heading"
        case availableFunds = "account.details.available.funds"
        case accountBalance = "account.details.balance"
        
        case prendingTransactionPrefix = "pending.transaction.prefix"
        case datesAgoSuffix = "dates.ago.suffix"

        case findATM = "find.atm.pin"

        // MARK: - LocalizationKeys
        
        var table: String? { return "MyBank" }
    }
}
