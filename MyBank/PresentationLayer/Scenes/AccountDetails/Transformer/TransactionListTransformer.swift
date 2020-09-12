//
//  TransactionListTransformer.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 12/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import UIKit

struct GroupedTransactionSection: Hashable {
    
    var id = UUID()

    var headerItem: TransctionSectionHeaderPresentationItem
    var transactionItems: [TransactionPresentationItem]

    init(headerItem: TransctionSectionHeaderPresentationItem,
         transactionItems: [TransactionPresentationItem]
    ) {
        self.headerItem = headerItem
        self.transactionItems = transactionItems
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: GroupedTransactionSection, rhs: GroupedTransactionSection) -> Bool {
        lhs.id == rhs.id
    }
}

struct TransactionListTransformer: DataTransforming {
    
    func transform(input: [Transaction]) -> [GroupedTransactionSection] {
        
        let items = input.map {  return TransactionPresentationItem($0) }
        
        return [GroupedTransactionSection(
            headerItem: TransctionSectionHeaderPresentationItem(title: "12 Aug 2020", subtitle: "12 days ago"),
            transactionItems: items)]
    }
}

