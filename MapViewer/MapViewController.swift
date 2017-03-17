//
//  MapViewController.swift
//  MapViewer
//
//  Created by Damian Ferens on 15.03.2017.
//  Copyright © 2017 Damian Ferens. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    lazy var locationManager = CLLocationManager()
    @IBOutlet weak var mapView: GMSMapView!
    let connectionManager = ConnectionManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                              longitude: userLocation!.coordinate.longitude, zoom: 13.0)
        showPlacesForCoordinates(coordinates: CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude))
        
        mapView.camera = camera
        locationManager.stopUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
    }
    
    private func showPlacesForCoordinates(coordinates: CLLocationCoordinate2D) {
        connectionManager.placesForCoordinates(coordinates: coordinates) { [weak self] (places: [Place]) in
            let path = GMSMutablePath()
            
            for place in places {
                let marker = GMSMarker()
                let coordinates = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
                marker.position = coordinates
                marker.title = place.name
                marker.map = self!.mapView
                path.add(coordinates)
            }
            self!.animateToBounds(bounds: GMSCoordinateBounds(path: path))
        }
    }
    
    private func animateToBounds(bounds :GMSCoordinateBounds) {
        self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let placeName = mapView.selectedMarker?.title
        let latitude = mapView.selectedMarker?.position.latitude
        let longitude = mapView.selectedMarker?.position.longitude
        useSelectedPlace(name: placeName!, lat: latitude!, lng: longitude!)
        performSegue(withIdentifier: "fromMapToDetailsSegue", sender: self)
    }
    
    func useSelectedPlace(name: String, lat: Double, lng: Double) {
        for place in ConnectionManager.Places.placesArray {
            guard place.name == name else {
                continue
            }
            guard place.latitude == lat else {
                continue
            }
            guard place.longitude == lng else {
                continue
            }
            ConnectionManager.Places.selectedPlace = place
        }
    }
}
