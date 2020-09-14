//
//  ATMMapContentView.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 14/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import SwiftUI
import MapKit

struct ATMMapViewModel {
    let viewTitle: String
    let atmLocation: ATMLocation
    let customPinImage: UIImage?
}

struct ATMMapContentView: View {
    
    // ViewModel
    private let viewModel: ATMMapViewModel
    
    // MARK: - Init
    init(withViewModel viewModel: ATMMapViewModel) {
        self.viewModel = viewModel
    }

    private var atmAnnotation: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = viewModel.atmLocation.name
        annotation.subtitle = viewModel.atmLocation.address
        annotation.coordinate = CLLocationCoordinate2D(
            latitude: NSDecimalNumber(decimal: viewModel.atmLocation.coordinate.latitude).doubleValue,
            longitude: NSDecimalNumber(decimal: viewModel.atmLocation.coordinate.longitude).doubleValue
        )
        return annotation
    }

    var body: some View {
        NavigationView {
            ZStack {
                MapView(pointAnnotaion: .constant(atmAnnotation),
                        customPinImage: .constant(viewModel.customPinImage))
                    .frame(minWidth: 0,
                           maxWidth: .infinity,
                           minHeight: 0,
                           maxHeight: .infinity,
                           alignment: .center)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle(Text(viewModel.viewTitle), displayMode: .inline)
    }
}

struct ATMMapContentView_Previews: PreviewProvider {
    
    static let sampleAtmViewModel = ATMMapViewModel(
        viewTitle: "CBA ATM",
        atmLocation: ATMLocation(identifier: "12222",
                                 name: "CBA Circular Quay Staion",
                                 address: "8, Alfred St, Sydney, NSW 2000",
                                 coordinate: Coordinate(latitude: -33.861382,
                                                        longitude: 151.210316)),
        customPinImage: UIImage(named: "CBAFindUsAnnotationIconATM")!)
    
    static var previews: some View {
        ATMMapContentView(withViewModel: ATMMapContentView_Previews.sampleAtmViewModel)
    }
}
