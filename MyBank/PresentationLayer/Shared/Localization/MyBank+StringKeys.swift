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
        
        case accountDetailsViewTitle = "account.details.view.title"
        case availableFunds = "account.details.available.funds"
        case accountBalance = "account.details.balance"
        
        case prendingTransactionPrefix = "pending.transaction.prefix"
        case datesAgoSuffix = "dates.ago.suffix"

        case atmMapViewTitle = "atm.map.view.title"
        
        // MARK: - Errors
        
        case genericErrorTitle = "error.generic.title"
        case genericErrorMessage = "error.generic.message"
        case errorDismissActionTitle = "error.dismiss.action.title"
        case networkConnectionErrorTitle = "error.networkConnection.title"
        case networkConnectionErrorMessage = "error.networkConnection.message"

        // MARK: - LocalizationKeys
        
        var table: String? { return "MyBank" }
    }
}
