//
//  Resource.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 12/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

struct Resource<T: Decodable> {
    
    /// The URL to request data for this resource
    let url: URL
    
    /// The optional parmeters to construct the full URL path
    let parameters: [String: CustomStringConvertible]
    
    
    var request: URLRequest? {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        components.queryItems = parameters.keys.map { key in
            URLQueryItem(name: key, value: parameters[key]?.description)
        }
        guard let url = components.url else {
            return nil
        }
        return URLRequest(url: url)
    }

    // MARK: - Init
    
    init(url: URL, parameters: [String: CustomStringConvertible] = [:]) {
        self.url = url
        self.parameters = parameters
    }
}
