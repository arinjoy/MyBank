//
//  AccountDetails.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 12/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

/// A wrapper of all account details, transaction list and  extra bank related info such as ATM locations
/// Ideally these could be fetched individually from different api calls
struct FullAccountDetailsResponse: Decodable {
    let accountDetails: AccountDetails
    let clearedTransactions: [Transaction]
    let pendingTransactions: [Transaction]
    let atmLocations: [ATMLocation]
    
    private enum CodingKeys: String, CodingKey {
        case accountDetails = "account"
        case clearedTransactions = "transactions"
        case pendingTransactions = "pending"
        case atmLocations = "atms"
    }
}

struct AccountDetails: Decodable {
    let name: String
    let number: String
    let availableBalance: Decimal
    let currentBalance: Decimal
    
    private enum CodingKeys: String, CodingKey {
        case name = "accountName"
        case number = "accountNumber"
        case availableBalance = "available"
        case currentBalance = "balance"
    }
}

struct Transaction: Decodable {
    
    let identifier: String
    
    // In realistic environment there could different types of dates related to a transaction.
    // Such as cleared date, posted date, processed date etc.
    // Here it is simple as the main effective date to convey back to the user on UI.
    // We could treat this as `timestamp` too with time components in it.
    let date: Date
    
    let description: String
    let amount: Decimal
    
    /// Optional atm identifier if the transaction was done via an ATM
    let atmId: String?
    
    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case date = "effectiveDate"
        case description
        case amount
        case atmId
    }
}

struct ATMLocation: Decodable {
    let identifier: String
    let name: String
    let address: String
    let coordinate: Coordinate
    
    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case address
        case coordinate = "location"
    }
}

struct Coordinate: Decodable {
    let latitude: Decimal
    let longitude: Decimal
    
    private enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
    }
}
