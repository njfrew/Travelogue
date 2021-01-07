//
//  Trip+CoreDataClass.swift
//  Travelogue
//
//  Created by Noah Frew on 12/11/20.
//
//

import Foundation
import CoreData
import UIKit

@objc(Trip)
public class Trip: NSManagedObject {
    var travelogueEntries: [TravelogueEntry]? {
        return self.rawTravelogueEntries?.array as? [TravelogueEntry]
    }
    
    convenience init?(title: String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let context = appDelegate?.persistentContainer.viewContext else {
            return nil
        }
        
        self.init(entity: Trip.entity(), insertInto: context)
        
        self.title = title
    }
}
