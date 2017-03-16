//
//  MapViewController.swift
//  MapViewer
//
//  Created by Damian Ferens on 15.03.2017.
//  Copyright © 2017 Damian Ferens. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire

class MapViewController: UIViewController, CLLocationManagerDelegate {
    lazy var locationManager = CLLocationManager()
    @IBOutlet weak var mapView: GMSMapView!
    let connectionManager = ConnectionManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        showPlacesForCoordinates(coordinates: CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude))
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                              longitude: userLocation!.coordinate.longitude, zoom: 13.0)
        mapView.camera = camera
        locationManager.stopUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
    }
    
    private func showPlacesForCoordinates(coordinates :CLLocationCoordinate2D) {
        connectionManager.placesForCoordinates(coordinates: coordinates) { [weak self] (places: [Place]) in
            for place in places {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
                marker.title = place.name
                marker.map = self!.mapView
            }
        }
    }
}
