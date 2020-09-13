//
//  TransactionPresentationItem.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 12/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import UIKit

struct TransactionPresentationItem {
    
    let id: String
    let description: NSAttributedString
    let amountText: String
    
    /// `nil` would indicate its a non-atm transaction
    let atmIcon: UIImage?
    
    let accessibility: AccessibilityConfiguration?
}

extension TransactionPresentationItem: Hashable {
    static func == (lhs: TransactionPresentationItem, rhs: TransactionPresentationItem) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
