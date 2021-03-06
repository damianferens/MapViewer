//
//  DatabaseManager.swift
//  MapViewer
//
//  Created by Damian Ferens on 17.03.2017.
//  Copyright © 2017 Damian Ferens. All rights reserved.
//

import CoreData

class DatabaseManager: NSObject {
    var mainManagedObjectContext: NSManagedObjectContext
    var backgroundManagedObjectContext: NSManagedObjectContext
    
    override init() {
        guard let modelURL = Bundle.main.url(forResource: "Model", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainManagedObjectContext.persistentStoreCoordinator = psc
        backgroundManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundManagedObjectContext.persistentStoreCoordinator = psc
        DispatchQueue.global().async() {
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let docURL = urls[urls.endIndex-1]
            let storeURL = docURL.appendingPathComponent("Model")
            do {
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }
    
    func saveSelectedPlace(place: Place) {
        backgroundManagedObjectContext.perform {
            let entity = NSEntityDescription.entity(forEntityName: "SelectedPlace", in: self.backgroundManagedObjectContext)!
            
            let placeToSave = NSManagedObject(entity: entity, insertInto: self.backgroundManagedObjectContext)
            placeToSave.setValue(place.avatar, forKey: "avatar")
            placeToSave.setValue(place.name, forKey: "name")
            placeToSave.setValue(place.id, forKey: "identifier")
            placeToSave.setValue(place.latitude, forKey: "lat")
            placeToSave.setValue(place.longitude, forKey: "lng")
            
            do {
                try self.backgroundManagedObjectContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func allSelectedPlaces(completionHandler: @escaping ([SelectedPlace]) -> ()){
        mainManagedObjectContext.perform {
            let fetchRequest: NSFetchRequest<SelectedPlace> = SelectedPlace.fetchRequest()
            do {
                let fetchResult = try self.mainManagedObjectContext.fetch(fetchRequest)
                completionHandler(fetchResult)
            } catch {
                print("Could not load data from database")
            }
        }
    }
    
}
