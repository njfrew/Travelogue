//
//  TravelogueEntry+CoreDataProperties.swift
//  Travelogue
//
//  Created by Noah Frew on 12/11/20.
//
//

import Foundation
import CoreData


extension TravelogueEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TravelogueEntry> {
        return NSFetchRequest<TravelogueEntry>(entityName: "TravelogueEntry")
    }

    @NSManaged public var content: String?
    @NSManaged public var date: Date?
    @NSManaged public var rawImage: Data?
    @NSManaged public var title: String?
    @NSManaged public var trip: Trip?

}

extension TravelogueEntry : Identifiable {

}
