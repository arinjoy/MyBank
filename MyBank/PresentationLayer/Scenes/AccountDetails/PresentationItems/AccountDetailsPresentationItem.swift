//
//  AccountDetailsPresentationItem.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 12/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

struct AccountDetailsPresentationItem {
    let nickname: String
    let number: String
    let amount: String
}

extension AccountDetailsPresentationItem: Hashable {
    static func == (lhs: AccountDetailsPresentationItem, rhs: AccountDetailsPresentationItem) -> Bool {
        return lhs.number == rhs.number
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(number)
    }
}
