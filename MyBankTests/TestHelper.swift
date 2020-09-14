//
//  TestHelper.swift
//  MyBankTests
//
//  Created by Arinjoy Biswas on 14/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
@testable import MyBank

class TestHelper {
    
    func sampleAccountDetailsFullResponse() -> FullAccountDetailsResponse {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(DateFormattingHelper.shortDate)
        let testJSONData = Bundle(for: type(of: self)).jsonData(forResource: "account_details_full")
        let mappedItem = try! jsonDecoder.decode(FullAccountDetailsResponse.self, from: testJSONData)
        return mappedItem
    }
    
    static func dateFromString(_ string: String) -> Date? {
        return DateFormattingHelper.shortDate.date(from: string)
    }
    
    static func sampleTransactionGroups() -> [TransactionGroup] {
        let group1 = TransactionGroup(
            date: TestHelper.dateFromString("20/02/2020")!,
            transactions: [
                TransactionModel(id: "1111",
                                 processingDate: TestHelper.dateFromString("20/02/2020")!,
                                 narrativeText: "A long description",
                                 amount: -5555.44,
                                 isPending: true,
                                 atmLocation: nil),
                TransactionModel(id: "222222",
                                 processingDate: TestHelper.dateFromString("20/02/2020")!,
                                 narrativeText: "A short description is enough",
                                 amount: 120.23,
                                 isPending: false,
                                 atmLocation: TestHelper().sampleAccountDetailsFullResponse().atmLocations.first!),
            ]
        )
        let group2 = TransactionGroup(
            date: TestHelper.dateFromString("12/06/2019")!,
            transactions: [
                TransactionModel(id: "333333",
                                 processingDate: TestHelper.dateFromString("12/06/2019")!,
                                 narrativeText: "A long description with NPP 🚗🚌🚎",
                                 amount: 12244.233,
                                 isPending: true,
                                 atmLocation: nil)
            ]
        )
        return [group1, group2]
    }
}
