//
//  ConnectionManager.swift
//  MapViewer
//
//  Created by Damian Ferens on 16.03.2017.
//  Copyright © 2017 Damian Ferens. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class ConnectionManager: NSObject {
    
    struct Places {
        static var placesArray: [Place] = []
        static var selectedPlace: Place? = nil
    }
    
    var urlComponents = URLComponents()
    override init() {
        urlComponents.scheme = "https";
        urlComponents.host = "interview-ready4s.herokuapp.com";
        urlComponents.path = "/geo";
    }
    
    let avatarJSONKey = "avatar"
    let idJSONKey = "id"
    let latitudeJSONKey = "lat"
    let longitudeJSONKey = "lng"
    let nameJSONKey = "name"
    
    func placesForCoordinates(coordinates :CLLocationCoordinate2D, completionHandler :@escaping ([Place])->()) {
        if CLLocationCoordinate2DIsValid(coordinates) {
            let coordinateComponentLatitude = URLQueryItem(name: "lat", value: String(coordinates.latitude))
            let coordinateComponentLongitude = URLQueryItem(name: "lng", value: String(coordinates.longitude))
            urlComponents.queryItems = [coordinateComponentLatitude, coordinateComponentLongitude]
            
            guard let url = urlComponents.url else {
                return
            }
            
            Alamofire.request(url).responseJSON { [weak self] response in
                if let places = response.result.value as? [Dictionary<AnyHashable, Any>] {
                    
                    for placeDictionary in places {
                        let place = Place(avatar: placeDictionary[self!.avatarJSONKey] as! String,
                                          id: placeDictionary[self!.idJSONKey] as! String,
                                          latitude: placeDictionary[self!.latitudeJSONKey] as! Double,
                                          longitude: placeDictionary[self!.longitudeJSONKey] as! Double,
                                          name: placeDictionary[self!.nameJSONKey] as! String)
                        Places.placesArray.append(place)
                    }
                    completionHandler(Places.placesArray)
                }
            }
        }
        
    }
}
