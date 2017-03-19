//
//  LastCheckedTableViewController.swift
//  MapViewer
//
//  Created by Damian Ferens on 17.03.2017.
//  Copyright © 2017 Damian Ferens. All rights reserved.
//

import UIKit

class LastCheckedTableViewController: UITableViewController {
    var places: [SelectedPlace] = []
    var index: Int = 0
    var selectedPlace: Place?
    let dataModel = DatabaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        dataModel.allSelectedPlaces { [weak self] (data: [SelectedPlace]) in
            self?.places = data
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = (self.tableView.indexPathForSelectedRow?.row)!
        useSelectedPlace()
        PlaceDetailsViewController.isUsingCoreData = true
        performSegue(withIdentifier: "fromLastToDetailsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController: PlaceDetailsViewController = segue.destination as! PlaceDetailsViewController
        destinationViewController.selectedPlace = selectedPlace
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        let name = places[indexPath.row].name
        let geoCoordinates = "Lng: \(String(places[indexPath.row].lng)), Lat: \(String(places[indexPath.row].lat))"
        cell.placeNameLabel?.text = name
        cell.geographicalCoordinatesLabel.text = geoCoordinates
        return cell
    }
    
    func useSelectedPlace() {
        let name = self.places[self.index].name!
        let latitude = self.places[self.index].lat
        let longitude = self.places[self.index].lng
        let avatar = self.places[self.index].avatar!
        let id = self.places[self.index].identifier!
        self.selectedPlace = Place(avatar: avatar, id: id, latitude: latitude, longitude: longitude, name: name)
    }
}
