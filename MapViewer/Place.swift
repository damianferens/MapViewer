//
//  Place.swift
//  MapViewer
//
//  Created by Damian Ferens on 16.03.2017.
//  Copyright © 2017 Damian Ferens. All rights reserved.
//

import UIKit

class Place: NSObject {
    var avatar: String
    var id: String
    var latitude: Double
    var longitude: Double
    var name: String
    
    init(avatar: String, id: String, latitude: Double, longitude: Double, name: String) {
        self.avatar = avatar
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
    }
}
