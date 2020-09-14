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
}
