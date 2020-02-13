//
//  Quake.swift
//  Quakes
//
//  Created by Chad Rutherford on 2/13/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import Foundation

class Quake: NSObject, Codable {
    
    let magnitude: Double
    let place: String
    let time: Date
    let latitude: Double
    let longitude: Double
    
    enum QuakeKeys: String, CodingKey {
        case magnitude = "mag"
        case properties
        case place
        case time
        case geometry
        case coordinates
        case latitude
        case longitude
    }
    
    required init(from decoder: Decoder) throws  {
        let container = try decoder.container(keyedBy: QuakeKeys.self)
        let properties = try container.nestedContainer(keyedBy: QuakeKeys.self, forKey: .properties)
        let geometry = try container.nestedContainer(keyedBy: QuakeKeys.self, forKey: .geometry)
        var coordinates = try geometry.nestedUnkeyedContainer(forKey: .coordinates)
        magnitude = try properties.decode(Double.self, forKey: .magnitude)
        place = try properties.decode(String.self, forKey: .place)
        time = try properties.decode(Date.self, forKey: .time)
        longitude = try coordinates.decode(Double.self)
        latitude = try coordinates.decode(Double.self)
        super.init()
    }
}

class QuakeResults: Codable {
    let quakes: [Quake]
    
    enum CodingKeys: String, CodingKey {
        case quakes = "features"
    }
}
