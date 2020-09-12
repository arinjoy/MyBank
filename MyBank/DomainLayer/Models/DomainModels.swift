//
//  DomainModels.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 12/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

/// A `Domain` level model to represent a transaction that is varied from the lower level Data model after
/// some buiness logic has been applied to them
struct TransactionModel {
    
    let id: String
    
    /// The main effective/processing date or timestamp of the transaction to calculate UI handing
    let processingDate: Date
    
    /// The narrative text to appear (after any santisation of data coming from backend such `<br/>` to `/n` conversion and trimming whitespaces
    let narrativeText: String
    
    let amount: Decimal
    
    /// Indicator of this transaction is pdning or not
    let isPending: Bool
    
    /// Instead of keeping referene to atmId, keep the entire atmLocation object for convenience
    /// Note: This might not be a good practice to keep the full data structure embedded here this way, ideally the just link to the identifier should be
    /// enough and atm location object could have feen fetched from a different array linking the atmId.
    let atmLocation: ATMLocation?
}

/// A group of transactions processed on a same day
struct TransactionGroup {
    
    /// The date where all the transactions in this group are same
    let date: Date
    
    /// The list of transactions domain models
    let transactions: [TransactionModel]
}

/// A combined data structure that has account details alongisde transaction history grouped into sections using individual dates
struct AccountDetailsWithTransactionHistory {
    let accountDetails: AccountDetails
    let transactionsGroups: [TransactionGroup]
}
