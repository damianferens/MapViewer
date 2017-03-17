//
//  PlaceDetailsViewController.swift
//  MapViewer
//
//  Created by Damian Ferens on 16.03.2017.
//  Copyright © 2017 Damian Ferens. All rights reserved.
//

import UIKit

class PlaceDetailsViewController: UIViewController {
    var selectedPlace: Place?
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var placeName: UILabel!
    
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContent()
    }
    
    func loadContent() {
        guard let placeToShow = selectedPlace else {
            return
        }
        
        if let checkedURL = NSURL(string: placeToShow.avatar) {
            avatar.contentMode = .scaleAspectFit
            downloadImage(url: checkedURL as URL)
        }
        
        let latitude = placeToShow.latitude
        let longitude = placeToShow.longitude
        placeName.text = placeToShow.name
        latitudeLabel.text = String(latitude)
        longitudeLabel.text = String(longitude)
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    private func saveSelectedPlace(imageUrl: URL) {
        let databaseManager = DatabaseManager()
        selectedPlace?.avatar = imageUrl.absoluteString
        databaseManager.saveSelectedPlace(place: selectedPlace!)
    }
    
    private func downloadImage(url: URL) {
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            // create a name for your image
            guard let placeToShow = self.selectedPlace else {
                return
            }
            let fileName = placeToShow.name
            let fileURL = documentsDirectoryURL.appendingPathComponent("\(fileName).png")
            
            
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    try UIImagePNGRepresentation(UIImage(data: data)!)!.write(to: fileURL)
                    print("Image Added Successfully")
                } catch {
                    print(error)
                }
            } else {
                print("Image Not Added")
            }
            
            self.saveSelectedPlace(imageUrl: fileURL)
            DispatchQueue.main.sync() { () -> Void in
                self.avatar.image = UIImage(data: data)
            }
        }
    }
}
