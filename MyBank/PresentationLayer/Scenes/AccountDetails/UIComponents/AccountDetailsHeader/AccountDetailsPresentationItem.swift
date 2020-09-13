//
//  AccountDetailsPresentationItem.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 12/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit

struct AccountDetailsPresentationItem {
    
    let accountTypeIcon: UIImage
    
    let accountDisplayName: String
    let accountNumber: String
    
    let availableBalanceLabel: String
    let availableBalanceText: String
    
    let currentBalanceLabel: String
    let currentBalanceText: String
    
    let accessibility: AccessibilityConfiguration?
}
