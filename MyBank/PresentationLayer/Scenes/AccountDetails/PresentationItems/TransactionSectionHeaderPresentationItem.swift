//
//  TransactionSectionHeaderPresentationItem.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 13/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

struct TransctionSectionHeaderPresentationItem {
    let title: String
    let subtitle: String
}

extension TransctionSectionHeaderPresentationItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }

    static func == (lhs: TransctionSectionHeaderPresentationItem, rhs: TransctionSectionHeaderPresentationItem) -> Bool {
        lhs.title == rhs.title
    }
}
