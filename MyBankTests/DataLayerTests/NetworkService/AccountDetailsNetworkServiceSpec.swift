//
//  AccountDetailsNetworkServiceSpec.swift
//  MyBankTests
//
//  Created by Arinjoy Biswas on 14/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Combine
@testable import MyBank

final class AccountDetailsNetworkServiceSpec: QuickSpec {
    
    override func spec() {
        
        describe("Account Details Network Service Spec") {
            
            var cancellables: [AnyCancellable] = []
            
            it("should call the load method on `NetworkService` with correct values being set") {
                
                let netwotkServiceSpy = NetworkServiceSpy()
                
                // When
                _ = netwotkServiceSpy
                    .load(Resource<FullAccountDetailsResponse>.accountDetails(forAccountId: ""))
                
                // Then
                
                // Spied call
                expect(netwotkServiceSpy.loadReourceCalled).to(beTrue())
                
                // Spied values
                expect(netwotkServiceSpy.isLocalStub).to(beFalse())
                
                expect(netwotkServiceSpy.url).toNot(beNil())
                expect(netwotkServiceSpy.url?.absoluteString).to(equal("https://www.dropbox.com/s/tewg9b71x0wrou9/data.json"))
                
                expect(netwotkServiceSpy.parameters).toNot(beNil())
                expect(netwotkServiceSpy.parameters?.count).to(equal(1))
                expect(netwotkServiceSpy.parameters?.first?.key).to(equal("dl")) // URL query param `?dl=1` is added
                expect(netwotkServiceSpy.parameters?.first?.value.description).to(equal("1"))
                
                expect(netwotkServiceSpy.request).toNot(beNil())
            }
            
            it("should pass the response from the api client unchanged when succeeds") {
                
                var expectedError: NetworkError?
                var receivedResponse: FullAccountDetailsResponse?
                
                let networkServiceMock = NetworkServiceMock(response: self.sampleAcccountDetailsResponse())
                
                // When
                networkServiceMock
                    .load(Resource<FullAccountDetailsResponse>.accountDetails(forAccountId: ""))
                    .sink(receiveValue: { result in
                        switch result {
                        case .success(let response):
                            receivedResponse = response
                        case .failure(let error):
                            expectedError = error
                        }
                     })
                    .store(in: &cancellables)
                
                // Then
                expect(expectedError).to(beNil())
                
                expect(receivedResponse).toNot(beNil())
                expect(receivedResponse?.accountDetails.name).to(equal("Testing123 Big Saver"))
                expect(receivedResponse?.accountDetails.number).to(equal("062003 29299 9292"))
                expect(receivedResponse?.accountDetails.availableBalance).to(equal(10000.55))
                
                expect(receivedResponse?.clearedTransactions.count).to(equal(4))
                expect(receivedResponse?.clearedTransactions.first?.identifier).to(equal("44e5b2bc484331ea24afd85ecfb212c8"))
                expect(receivedResponse?.clearedTransactions.first?.amount).to(equal(12))
                expect(receivedResponse?.clearedTransactions.first?.narrative).to(equal("Kaching TFR from JOHN CITIZEN<br/>xmas donation"))
                
                expect(receivedResponse?.atmLocations.count).to(equal(2))
                expect(receivedResponse?.atmLocations.first?.identifier).to(equal("129382"))
            }
            
            it("should pass the error from the api client when fails") {
            
                var expectedError: NetworkError?
                var receivedResponse: FullAccountDetailsResponse?
                
                let networkServiceMock = NetworkServiceMock(
                    response: self.sampleAcccountDetailsResponse(),
                    returningError: true,
                    error: NetworkError.timeout)
                
                // When
                networkServiceMock
                    .load(Resource<FullAccountDetailsResponse>.accountDetails(forAccountId: ""))
                    .sink(receiveValue: { result in
                        switch result {
                        case .success(let response):
                            receivedResponse = response
                        case .failure(let error):
                            expectedError = error
                        }
                     })
                    .store(in: &cancellables)
                
                // Then
                expect(expectedError).toNot(beNil())
                // TODO: check exact value as well and needs Nimble matcher for enum error
                expect(receivedResponse).to(beNil())
            }
        }
    }
    
    // MARK: - Test Helpers
    
    private func sampleAcccountDetailsResponse() -> FullAccountDetailsResponse {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(DateFormattingHelper.shortDate)
        let testJSONData = Bundle(for: type(of: self)).jsonData(forResource: "account_details_full")
        let mappedItem = try! jsonDecoder.decode(FullAccountDetailsResponse.self, from: testJSONData)
        return mappedItem
    }
}
