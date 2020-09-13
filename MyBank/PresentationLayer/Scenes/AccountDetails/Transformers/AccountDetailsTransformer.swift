//
//  AccountDetailsTransformer.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 13/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import UIKit

struct AccountDetailsTransformer: DataTransforming {
    
    func transform(input: AccountDetails) -> AccountDetailsPresentationItem {
        
        // Perform some safety check just in case. And flag them with reasoning message rather than bang crash with force-unwrap
        guard let accountIcon = UIImage(named: "accountsimagetransactional") else {
            fatalError("Icon image cannot be found")
        }
        guard let availableBalanceText = NumberFormatterHelper.signedCurrency.string(from: input.availableBalance as NSNumber) else {
            fatalError("Available balance cannot be formatted")
        }
        guard let currentBalanceText = NumberFormatterHelper.signedCurrency.string(from: input.currentBalance as NSNumber) else {
            fatalError("Current balance cannot be formatted")
        }
        
        let availableBalanceLabel = StringKeys.MyBank.availableFunds.localized()
        let currentBalanceLabel = StringKeys.MyBank.accountBalance.localized()
        
        let accessibility = AccessibilityConfiguration(
            identifier: "accessibilityId.account.details.header",
            label: UIAccessibility.createCombinedAccessibilityLabel(
                from: ["Account \(input.name)",
                       "Account number \(input.number)",
                       "with \(availableBalanceLabel) \(availableBalanceText)",
                       "and \(currentBalanceLabel) \(currentBalanceText)"
                      ]),
            traits: .header)
        
        return AccountDetailsPresentationItem(
            accountTypeIcon: accountIcon,
            accountDisplayName: input.name,
            accountNumber: input.number,
            availableBalanceLabel: availableBalanceLabel,
            availableBalanceText: availableBalanceText,
            currentBalanceLabel: currentBalanceLabel,
            currentBalanceText: currentBalanceText,
            accessibility: accessibility
        )
    }
}
