//
//  AccountDetailsRouter.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 14/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit
import SwiftUI

protocol AccountDetailsRouting: class {
    
    /// Will route to the `ATM location map` scene
    func routeToAtmLocationMap(withWithAtmLocation atmLocation: ATMLocation)
    
    // There could be poetentally many more actions/navigations and other types of views navigate to
    // Presenter can make a call of that and calls the correct method of the router to get the job done
}

final class AccountDetailsRouter: AccountDetailsRouting {
    
    weak var sourceViewController: UIViewController?
    
    // MARK: - Init
    
    init(sourceViewController: UIViewController?) {
        self.sourceViewController = sourceViewController
    }

    
    // MARK: - AccountDetailsRouting
    
    func routeToAtmLocationMap(withWithAtmLocation atmLocation: ATMLocation) {
        let atmMapView = ATMMapContentView(withAtmLocation: atmLocation)

        let hostingVC = UIHostingController(rootView: atmMapView)
        sourceViewController?.navigationController?.pushViewController(hostingVC, animated: true)
    }
}
