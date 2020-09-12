//
//  Resource+AccountDetails.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 12/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

extension Resource {
    
    static func accountDetails(forAccountId accountId: String) -> Resource<FullAccountDetailsResponse> {
        
        // Ideally we should construct the full URL path here like in realistic api call situation
        /*
        let url = ApiConstants.baseUrl
        let parameters: [String : CustomStringConvertible] = ["accountId": accountId]
        */
        
        let url = ApiConstants.remoteAccountDataURL
        
        // Dropbx query param `dl=1` is appended to make the api call work
        return Resource<FullAccountDetailsResponse>(url: url, parameters: ["dl":1])
    }
}
