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
    
    @Binding var pointAnnotaion: MKPointAnnotation
    @Binding var customPinImage: UIImage?
        
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.addAnnotation(pointAnnotaion)
        let region = mapView.regionThatFits(MKCoordinateRegion(center: pointAnnotaion.coordinate,
                                                               latitudinalMeters: 200,
                                                               longitudinalMeters: 200))
        mapView.setRegion(region, animated: true)
        mapView.delegate = context.coordinator
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
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            view.canShowCallout = true
            view.animatesDrop = false
            if let pinImage = parent.customPinImage {
                view.image = pinImage
            }
            return view
        }
    }
}
