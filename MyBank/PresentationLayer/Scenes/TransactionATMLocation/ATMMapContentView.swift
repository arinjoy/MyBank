//
//  ATMMapContentView.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 14/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import SwiftUI
import MapKit

struct ATMMapContentView: View {

    private var atmAnnotation: MKPointAnnotation
    
    init(withAtmLocation atmLocation: ATMLocation) {
        let annotation = MKPointAnnotation()
        annotation.title = atmLocation.name
        annotation.subtitle = atmLocation.address
        annotation.coordinate = CLLocationCoordinate2D(
            latitude: NSDecimalNumber(decimal: atmLocation.coordinate.latitude).doubleValue,
            longitude: NSDecimalNumber(decimal: atmLocation.coordinate.longitude).doubleValue
        )
        self.atmAnnotation = annotation
    }

    var body: some View {
        NavigationView {
            MapView(annoation: .constant(MKPointAnnotation.example))
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       minHeight: 0,
                       maxHeight: .infinity,
                       alignment: .center)
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle(Text(atmAnnotation.title ?? ""), displayMode: .inline)
    }
}
