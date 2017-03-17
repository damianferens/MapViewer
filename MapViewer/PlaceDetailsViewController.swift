//
//  PlaceDetailsViewController.swift
//  MapViewer
//
//  Created by Damian Ferens on 16.03.2017.
//  Copyright © 2017 Damian Ferens. All rights reserved.
//

import UIKit

class PlaceDetailsViewController: UIViewController {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var placeName: UILabel!
    
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContent()
    }
    
    func loadContent() {
        if let checkedURL = NSURL(string: urlString()) {
            avatar.contentMode = .scaleAspectFit
            downloadImage(url: checkedURL as URL)
        }
        let place = ConnectionManager.Places.selectedPlace?.name
        let latitude = (ConnectionManager.Places.selectedPlace?.latitude)!
        let longitude = (ConnectionManager.Places.selectedPlace?.longitude)!
        placeName.text = place
        latitudeLabel.text = String(latitude)
        longitudeLabel.text = String(longitude)
    }
    func urlString() -> String {
        let outText =  ConnectionManager.Places.selectedPlace?.avatar
        return outText!
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { (data, response, error)  in
            DispatchQueue.main.sync() { () -> Void in
                guard let data = data, error == nil else { return }
                self.avatar.image = UIImage(data: data)
            }
        }
    }
}
