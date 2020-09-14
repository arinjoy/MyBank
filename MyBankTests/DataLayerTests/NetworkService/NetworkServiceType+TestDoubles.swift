//
//  NetworkServiceType+TestDoubles.swift
//  MyBankTests
//
//  Created by Arinjoy Biswas on 14/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import Combine
@testable import MyBank

final class NetworkServiceSpy: NetworkServiceType {
    
    // Spy calls
    var loadReourceCalled = false
    
    // Spy values
    var url: URL?
    var parameters: [String: CustomStringConvertible]?
    var request: URLRequest?
    var isLocalStub: Bool?
    
    func load<T>(_ resource: Resource<T>) -> AnyPublisher<Result<T, NetworkError>, Never> {
        
        loadReourceCalled = true
        
        url = resource.url
        parameters = resource.parameters
        request = resource.request
        isLocalStub = resource.isLocalStub
        
        return Empty<Result<T, NetworkError>, Never>().eraseToAnyPublisher()
    }
}
