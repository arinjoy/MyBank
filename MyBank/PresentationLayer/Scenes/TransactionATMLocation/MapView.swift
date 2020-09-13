//
//  MapView.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 13/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    @Binding var annoation: MKPointAnnotation
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.addAnnotation(annoation)
        let region = mapView.regionThatFits(MKCoordinateRegion(center: annoation.coordinate,
                                                               latitudinalMeters: 200,
                                                               longitudinalMeters: 200))
        mapView.setRegion(region, animated: true)
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        // Do if needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }
    }
}

extension MKPointAnnotation {
    static var example: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = "Circular Quay Station"
        annotation.subtitle = "8 Alfred St, Sydney, NSW 2000"
        annotation.coordinate = CLLocationCoordinate2D(latitude: -33.861382, longitude: 151.210316)
        return annotation
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(annoation: .constant(MKPointAnnotation.example))
            .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
    }
}
