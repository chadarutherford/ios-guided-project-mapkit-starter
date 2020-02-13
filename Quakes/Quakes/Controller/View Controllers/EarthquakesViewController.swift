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
		fetchQuakes()
	}
    
    private func fetchQuakes() {
        quakeFetcher.fetchQuakes { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print("Error fetching quakes: \(error)")
            case .success(let quakes):
                print("Quakes: \(quakes.count)")
                
                // Setup MKMapView
                DispatchQueue.main.async {
                    self.mapView.addAnnotations(quakes)
                }
            }
        }
    }
}
