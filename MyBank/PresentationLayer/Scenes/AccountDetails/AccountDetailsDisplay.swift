//
//  AccountDetailsDisplay.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 13/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

protocol AccountDetailsDisplay: class {
    
    /// Will set the view title in navigation bar
    /// - Parameter title: The title to set
    func setTitle(_ title: String)
    
    /// Will be called to update the account details header
    func updateAccountDetailsHeader()
    
    /// Will be called to update the transaction history
    func updateTransactionList()
    
    /// Will be called to show loading indicator while  account deatils are being fetched
    func showLoadingIndicator()
    
    /// Will be called to hide the loading indicator
    func hideLoadingIndicator()
    
    /// Will be called to show an error alert
    /// - Parameters:
    ///   - title: The title string of the error
    ///   - message: The body string of the error
    ///   - dismissTitle: The dismiss action title string of the error
    func showError(title: String, message: String, dismissTitle: String)
}
