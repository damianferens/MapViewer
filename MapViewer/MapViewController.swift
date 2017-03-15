//
//  MapViewController.swift
//  MapViewer
//
//  Created by Damian Ferens on 15.03.2017.
//  Copyright © 2017 Damian Ferens. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GMSServices.provideAPIKey("AIzaSyA9lxg88Ib46SBS9XnPdPXZdgZlXJ1y8qo")
        
        let latitude = 50.070211
        let longitude = 19.932971
        let camera = GMSCameraPosition.camera(withLatitude: latitude , longitude: longitude, zoom: 12)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = "House"
        marker.map = mapView
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
