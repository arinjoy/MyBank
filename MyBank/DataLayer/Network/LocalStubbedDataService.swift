//
//  LocalStubbedDataService.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 13/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import Combine

/// This is a stub implmentation of `NetworkServiceType` to fetch data locally from JSON file after 2 seconds delay
final class LocalStubbedDataService: NetworkServiceType {

    private let localfileName: String

    init(withLocalFile fileName: String) {
        self.localfileName = fileName
    }
    
    // MARK: - NetworkServiceType
    
    func load<T>(_ resource: Resource<T>) -> AnyPublisher<Result<T, NetworkError>, Never> {
        let future = Future<Result<T, NetworkError>, Never> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                if let filePath = Bundle(for: type(of: self)).path(forResource: self.localfileName, ofType: "json") {
                    do {
                        let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
                        let jsonDecoder = JSONDecoder()
                        jsonDecoder.dateDecodingStrategy = .formatted(DateFormattingHelper.shortDate)
                        let decoded = try jsonDecoder.decode(T.self, from: data)
                        promise(.success(.success(decoded)))
                    } catch {
                        promise(.success(.failure(.jsonDecodingError(error: error))))
                    }
                } else {
                    promise(.success(.failure(.unknown)))
                }
            }
        }
        return future.eraseToAnyPublisher()
    }
}
