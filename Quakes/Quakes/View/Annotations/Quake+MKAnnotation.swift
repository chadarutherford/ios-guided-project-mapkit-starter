//
//  Quake+MKAnnotation.swift
//  Quakes
//
//  Created by Chad Rutherford on 2/13/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import Foundation
import MapKit

extension Quake: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String? {
        place
    }
    
    var subtitle: String? {
        "Magnitude: \(magnitude)"
    }
}
