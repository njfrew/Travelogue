//
//  Trip+CoreDataProperties.swift
//  Travelogue
//
//  Created by Noah Frew on 12/11/20.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var title: String?
    @NSManaged public var rawTravelogueEntries: NSOrderedSet?

}

// MARK: Generated accessors for rawTravelogueEntries
extension Trip {

    @objc(insertObject:inRawTravelogueEntriesAtIndex:)
    @NSManaged public func insertIntoRawTravelogueEntries(_ value: TravelogueEntry, at idx: Int)

    @objc(removeObjectFromRawTravelogueEntriesAtIndex:)
    @NSManaged public func removeFromRawTravelogueEntries(at idx: Int)

    @objc(insertRawTravelogueEntries:atIndexes:)
    @NSManaged public func insertIntoRawTravelogueEntries(_ values: [TravelogueEntry], at indexes: NSIndexSet)

    @objc(removeRawTravelogueEntriesAtIndexes:)
    @NSManaged public func removeFromRawTravelogueEntries(at indexes: NSIndexSet)

    @objc(replaceObjectInRawTravelogueEntriesAtIndex:withObject:)
    @NSManaged public func replaceRawTravelogueEntries(at idx: Int, with value: TravelogueEntry)

    @objc(replaceRawTravelogueEntriesAtIndexes:withRawTravelogueEntries:)
    @NSManaged public func replaceRawTravelogueEntries(at indexes: NSIndexSet, with values: [TravelogueEntry])

    @objc(addRawTravelogueEntriesObject:)
    @NSManaged public func addToRawTravelogueEntries(_ value: TravelogueEntry)

    @objc(removeRawTravelogueEntriesObject:)
    @NSManaged public func removeFromRawTravelogueEntries(_ value: TravelogueEntry)

    @objc(addRawTravelogueEntries:)
    @NSManaged public func addToRawTravelogueEntries(_ values: NSOrderedSet)

    @objc(removeRawTravelogueEntries:)
    @NSManaged public func removeFromRawTravelogueEntries(_ values: NSOrderedSet)

}

extension Trip : Identifiable {

}
