//
//  TransactionListTransformer.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 12/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import UIKit

struct TransactionListTransformer: DataTransforming {
    
    func transform(input: [TransactionGroup]) -> [GroupedTransactionSection] {
        
        var sections: [GroupedTransactionSection] = []
        for group in input {
            let items = group.transactions.map { tranformTransaction($0) }

            let formattedDate = DateFormattingHelper.mediumDate.string(from: group.date)
            let section = GroupedTransactionSection(
                headerItem: TransctionSectionHeaderPresentationItem(title: formattedDate, subtitle: "12 days ago"),
                transactionItems: items)
            sections.append(section)
        }
        return sections
    }
    
    
    // MARK: - Private Helpers
    
    private func tranformTransaction(_ transaction: TransactionModel) -> TransactionPresentationItem {
        guard
            let signedAmount = NumberFormatterHelper.signedCurrency.string(from: transaction.amount as NSNumber)
        else {
            // This should never happen. Doing it to avoid force-unwrap.
            fatalError("Number fomatter could not format currency amount")
        }
        
        // TODO: handle "PENDING" with bold attributed text
        var narrative: String = transaction.isPending ? "PENDING " : ""
        narrative += transaction.narrativeText
        
        return TransactionPresentationItem(id: transaction.id,
                                           description: narrative,
                                           amount: signedAmount,
                                           isAtmTransaction:transaction.atmLocation != nil)
    }
}
