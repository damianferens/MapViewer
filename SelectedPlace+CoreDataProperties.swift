//
//  SelectedPlace+CoreDataProperties.swift
//  
//
//  Created by Damian Ferens on 17.03.2017.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension SelectedPlace {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SelectedPlace> {
        return NSFetchRequest<SelectedPlace>(entityName: "SelectedPlace");
    }

    @NSManaged public var identifier: String?
    @NSManaged public var name: String?
    @NSManaged public var avatar: String?
    @NSManaged public var lat: Double
    @NSManaged public var lng: Double

}
