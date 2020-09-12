//
//  TransactionPresentationItem.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 12/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

struct TransactionPresentationItem {
    let id: String
    let description: String
    let amount: String
    let isAtmTransaction: Bool

    init(_ transaction: Transaction) {
        self.id = transaction.identifier
        self.description = transaction.narrative
        self.amount = "$ \(transaction.amount)" // TODO: properly via number formatter
        self.isAtmTransaction = transaction.atmId != nil
    }
}

extension TransactionPresentationItem: Hashable {
    static func == (lhs: TransactionPresentationItem, rhs: TransactionPresentationItem) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
