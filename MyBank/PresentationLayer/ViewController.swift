//
//  ViewController.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 12/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    private var cancellables: [AnyCancellable] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.backgroundColor = .yellow
        
        // TEST data loading works via network service
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        // TODO: Handle all of these via VIPER or MVVM logic.
        
        let networkService = ServicesProvider.defaultProvider().network

        let somePublisher = networkService
            .load(Resource<FullAccountDetailsResponse>.accountDetails(forAccountId: ""))
            .subscribe(on: Scheduler.background)
            .receive(on: Scheduler.main)
            .eraseToAnyPublisher()

        somePublisher
            .sink(receiveValue: { result in
                print(result)
            })
            .store(in: &cancellables)
        
    }
}

