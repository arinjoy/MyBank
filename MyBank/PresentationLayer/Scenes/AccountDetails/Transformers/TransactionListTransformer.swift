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
    
    func transform(input: [TransactionGroup]) -> [GroupedTransactionSectionPresentationItem] {
        
        var sections: [GroupedTransactionSectionPresentationItem] = []
        for group in input {
            let items = group.transactions.map { tranformTransaction($0) }

            let formattedDateText = DateFormattingHelper.mediumDate.string(from: group.date)
            
            var datesAgoText: String = ""
            if let text = DateComponentsHelper.yearMonthDayCompact.string(from: group.date, to: Date()) {
                datesAgoText = text + " " + StringKeys.MyBank.datesAgoSuffix.localized()
            }
            
            let headerAccessibility = AccessibilityConfiguration(
                identifier: "accessibilityId.account.details.transaction.section.header",
                label: UIAccessibility.createCombinedAccessibilityLabel(from: [formattedDateText, datesAgoText]),
                traits: .header)
  
            let section = GroupedTransactionSectionPresentationItem(
                headerItem: TransctionSectionHeaderPresentationItem(title: formattedDateText,
                                                                    subtitle: datesAgoText,
                                                                    accessibility: headerAccessibility),
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
        
        var attributedDescription = NSAttributedString(string: transaction.narrativeText)
        if transaction.isPending {
            let attributedText = NSMutableAttributedString(string: StringKeys.MyBank.prendingTransactionPrefix.localized(),
                                                              attributes: [.font: Theme.Font.subheading])
            attributedText.append(NSAttributedString(string: " "))
            attributedText.append(attributedDescription)
            attributedDescription = attributedText
        }
        
        let isAtmTransaction = transaction.atmLocation != nil
        
        let accessibility = AccessibilityConfiguration(
            identifier: "accessibilityId.account.details.transaction.cell",
            label: UIAccessibility.createCombinedAccessibilityLabel(
                from: [transaction.isPending ? "Pending transaction" : "Cleared transaction",
                       transaction.narrativeText,
                       "amount \(signedAmount)"]),
                hint: isAtmTransaction ? "Double click to see the ATM location on map" : "",
                traits: isAtmTransaction ? .button : .staticText)
        
        return TransactionPresentationItem(
            id: transaction.id,
            description: attributedDescription,
            amountText: signedAmount,
            atmIcon: isAtmTransaction ? Theme.Icon.atmTransaction.image : nil,
            accessibility: accessibility)
    }
}
