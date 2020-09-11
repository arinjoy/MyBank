//
//  AccessibilityIdentifiers.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 12/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

public struct AccessibilityIdentifiers {
    
    public struct AccountDetails {
        public static let rootViewId = "\(AccountDetails.self).root"
        public static let transactionTableViewId = "\(AccountDetails.self).transaction.table"
        public static let accountHeaderViewId = "\(AccountDetails.self).account.header"
        public static let transactionGroupHeaderId = "\(AccountDetails.self).transaction.group.header"
        public static let transactionCellId = "\(AccountDetails.self).transaction.cell"
    }
}
