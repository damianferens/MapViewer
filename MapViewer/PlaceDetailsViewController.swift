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
    static var isUsingCoreData: Bool?
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (PlaceDetailsViewController.isUsingCoreData == true) {
            loadCoreDataContent()
        } else {
            loadContent()
        }
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
    
    private func saveSelectedPlace(imageUrl: URL) {
        let databaseManager = DatabaseManager()
        selectedPlace?.avatar = imageUrl.absoluteString
        databaseManager.saveSelectedPlace(place: selectedPlace!)
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    private func downloadImage(url: URL) {
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            guard let placeToShow = self.selectedPlace else {
                return
            }
            let fileName = placeToShow.name
            let fileURL = documentsDirectoryURL.appendingPathComponent("\(fileName).png")
            
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    try UIImagePNGRepresentation(UIImage(data: data)!)!.write(to: fileURL)
                    print("Image Added Successfully")
                    self.saveSelectedPlace(imageUrl: fileURL)
                } catch {
                    print(error)
                }
            } else {
                print("Image Not Added")
            }
            
            DispatchQueue.main.sync() { () -> Void in
                self.avatar.image = UIImage(data: data)
            }
        }
    }
    
    func loadCoreDataContent() {
        guard let placeToShow = selectedPlace else {
            return
        }
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath = paths.first {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("\(placeToShow.name).png")
            let image = UIImage(contentsOfFile: imageURL.path)
            self.avatar.image = image
        }
        let latitude = placeToShow.latitude
        let longitude = placeToShow.longitude
        placeName.text = placeToShow.name
        latitudeLabel.text = String(latitude)
        longitudeLabel.text = String(longitude)
    }
}
