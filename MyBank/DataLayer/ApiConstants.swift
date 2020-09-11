//
//  ApiConstants.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 12/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

struct ApiConstants {
    
    // This is a very simple flat URL for now. :)
    // Ideally, this would be a baseURL followed by accountId. eg. "https://<Banking Base URL Path>/accountId"
    static let remoteAccountDataURL = URL(string: "https://www.dropbox.com/s/tewg9b71x0wrou9/data.json?dl=1")!
}
