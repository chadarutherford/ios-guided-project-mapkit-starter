//
//  EarthquakesViewController.swift
//  Quakes
//
//  Created by Paul Solt on 10/3/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import UIKit
import MapKit

class EarthquakesViewController: UIViewController {
		
	// NOTE: You need to import MapKit to link to MKMapView
	@IBOutlet var mapView: MKMapView!
    
    var quakeFetcher = QuakeFetcher()
	
	override func viewDidLoad() {
		super.viewDidLoad()
        setupMapView()
		fetchQuakes()
	}
    
    private func setupMapView() {
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "QuakeView")
    }
    
    private func fetchQuakes() {
        quakeFetcher.fetchQuakes { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print("Error fetching quakes: \(error)")
            case .success(var quakes):
                print("Quakes: \(quakes.count)")
                
                // Setup MKMapView
                DispatchQueue.main.async {
                    quakes = quakes.sorted { $0.magnitude > $1.magnitude }
                    self.mapView.addAnnotations(quakes)
                    guard let quake = quakes.first else { return }
                    let coordinateSpan = MKCoordinateSpan(latitudeDelta: 4, longitudeDelta: 4)
                    let region = MKCoordinateRegion(center: quake.coordinate, span: coordinateSpan)
                    self.mapView.setRegion(region, animated: true)
                }
            }
        }
    }
}

extension EarthquakesViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let quake = annotation as? Quake else { fatalError("Only quake objects are supported right now.") }
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "QuakeView") as? MKMarkerAnnotationView else { fatalError("Missing a registered annotation view") }
        annotationView.glyphImage = UIImage(named: "QuakeIcon")
        if quake.magnitude >= 5 {
            annotationView.markerTintColor = .systemRed
        } else if quake.magnitude >= 3 && quake.magnitude < 5 {
            annotationView.markerTintColor = .systemOrange
        } else {
            annotationView.markerTintColor = .systemYellow
        }
        annotationView.canShowCallout = true
        let detailView = QuakeDetailView()
        detailView.quake = quake
        annotationView.detailCalloutAccessoryView = detailView
        
        return annotationView
    }
}
