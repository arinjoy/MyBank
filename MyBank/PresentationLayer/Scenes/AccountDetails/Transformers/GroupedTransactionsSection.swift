//
//  GroupedTransactionSectionPresentationItem.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 13/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

struct GroupedTransactionSectionPresentationItem {

    var headerItem: TransctionSectionHeaderPresentationItem
    var transactionItems: [TransactionPresentationItem]
}

extension GroupedTransactionSectionPresentationItem: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(headerItem)
    }

    static func == (lhs: GroupedTransactionSectionPresentationItem, rhs: GroupedTransactionSectionPresentationItem) -> Bool {
        lhs.headerItem == rhs.headerItem
    }
}
