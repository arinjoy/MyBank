//
//  AccountDetailsPresenting.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 12/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

protocol AccountDetailsPresenting: class {

    /// Will load the account details along with transactions list
    ///
    /// - Parameter isRereshingNeeded: Whether data refreshing is needed
    func loadAccountDetails(isRereshingNeeded: Bool)

}
