//
//  DatabaseManager.swift
//  MapViewer
//
//  Created by Damian Ferens on 17.03.2017.
//  Copyright © 2017 Damian Ferens. All rights reserved.
//

import UIKit
import CoreData

class DatabaseManager: NSObject {
    var mainManagedObjectContext: NSManagedObjectContext
    var backgroundManagedObjectContext: NSManagedObjectContext

    override init() {
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = Bundle.main.url(forResource: "Model", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
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
            /* The directory the application uses to store the Core Data store file.
             This code uses a file named "DataModel.sqlite" in the application's documents directory.
             */
            let storeURL = docURL.appendingPathComponent("Model")
            do {
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }
    func saveSelectedPlace(place: Place) {
        
        // logit to check if place already in database
        //
        backgroundManagedObjectContext.perform {
            let entity = NSEntityDescription.entity(forEntityName: "SelectedPlace",
                                                    in: self.backgroundManagedObjectContext)!
            
            let placeToSave = NSManagedObject(entity: entity,
                                              insertInto: self.backgroundManagedObjectContext)
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
    
    func allSelectedPlaces() -> [SelectedPlace] {
        let placesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SelectedPlace")
        do {
            let fetchedPlace = try backgroundManagedObjectContext.fetch(placesFetch) as! [SelectedPlace]
        } catch {
            fatalError()
        }
        return []
    }
    
}
//    //MARK: core data stack
//    var mainManagedObjectContext: NSManagedObjectContext {
//        if !(_managedObjectContext != nil) {
//            let coordinator = self.persistentStoreCoordinator
//            _managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
//            _managedObjectContext!.persistentStoreCoordinator = coordinator
//        }
//        return _managedObjectContext!
//    }
//
//    var backgroundManagedObjectContext: NSManagedObjectContext {
//        if !(_managedObjectContext != nil) {
//            let coordinator = self.persistentStoreCoordinator
//            _managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
//            _managedObjectContext!.persistentStoreCoordinator = coordinator
//        }
//        return _managedObjectContext!
//    }
//
//    var _managedObjectContext: NSManagedObjectContext? = nil
//
//    var managedObjectModel: NSManagedObjectModel {
//        if !(_managedObjectModel != nil) {
//            let modelURL = Bundle.main.url(forResource: "Model", withExtension: "xcdatamodeld")
//            _managedObjectModel = NSManagedObjectModel(contentsOf: modelURL!)
//        }
//        return _managedObjectModel!
//    }
//
//    var _managedObjectModel: NSManagedObjectModel? = nil
//
//    var persistentStoreCoordinator: NSPersistentStoreCoordinator {
//        if !(_persistentStoreCoordinator != nil) {
//            let storeURL = self.applicationDocumentsDirectory.appendingPathComponent("MapViewer.sqlite")
//            _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
//            do {
//                try _persistentStoreCoordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
//            }
//            catch {
//
//            }
//        }
//        return _persistentStoreCoordinator!
//    }
//
//    var _persistentStoreCoordinator: NSPersistentStoreCoordinator? = nil
//
//    var applicationDocumentsDirectory: NSURL {
//        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return urls[urls.endIndex-1] as NSURL
//    }
//
//    //MARK: public methods
//    func saveSelectedPlace(place: Place) {
//
//        // logit to check if place already in database
//        //
//        backgroundManagedObjectContext.perform {
//            let entity = NSEntityDescription.entity(forEntityName: "SelectedPlace",
//                                                    in: self.backgroundManagedObjectContext)!
//
//            let placeToSave = NSManagedObject(entity: entity,
//                                         insertInto: self.backgroundManagedObjectContext)
//            placeToSave.setValue(place.avatar, forKey: "avatar")
//            placeToSave.setValue(place.name, forKey: "name")
//            placeToSave.setValue(place.id, forKey: "id")
//            placeToSave.setValue(place.latitude, forKey: "lat")
//            placeToSave.setValue(place.longitude, forKey: "lng")
//
//            do {
//                try self.backgroundManagedObjectContext.save()
//            } catch let error as NSError {
//                print("Could not save. \(error), \(error.userInfo)")
//            }
//        }
//    }
//
//    func allSelectedPlaces() -> [SelectedPlace] {
//        return []
//    }
//}
