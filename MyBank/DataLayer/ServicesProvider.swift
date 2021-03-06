//
//  ServicesProvider.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 12/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

/// Can provide misc services such as - network data loading, local file data loading, image loading, core-data/caching
/// For now there is only service of `NetworkServiceType` which does HTTP based data loading
class ServicesProvider {

    /// The underlying network service to load HTTP network based data
    let network: NetworkServiceType
    
    init(network: NetworkServiceType) {
        self.network = network
    }

    /// The deafult provider used for production code to fetch from remote
    static func defaultProvider() -> ServicesProvider {
        let sessionConfig = URLSessionConfiguration.ephemeral
        
        // Set 10 seconds timeout for the request,
        // otherwise defaults to 60 seconds which is too long.
        // This helps in network disconnection and error testing.
        sessionConfig.timeoutIntervalForRequest = 10
        sessionConfig.timeoutIntervalForResource = 10
        
        let network = NetworkService(with: sessionConfig)
        
        return ServicesProvider(network: network)
    }
    
    /// The helping provider to fetch locally from stub JSON file
    static func localStubbedProvider() -> ServicesProvider {
        // Slightly modified version with more recent dates used for testing
        let localStubbedNetwork = LocalStubbedDataService(withLocalFile: "account_data")
        return ServicesProvider(network: localStubbedNetwork)
    }


}
