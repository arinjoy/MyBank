//
//  GroupedTransactionsSection.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 13/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

struct GroupedTransactionSection {

    var headerItem: TransctionSectionHeaderPresentationItem
    var transactionItems: [TransactionPresentationItem]
}

extension GroupedTransactionSection: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(headerItem)
    }

    static func == (lhs: GroupedTransactionSection, rhs: GroupedTransactionSection) -> Bool {
        lhs.headerItem == rhs.headerItem
    }
}
