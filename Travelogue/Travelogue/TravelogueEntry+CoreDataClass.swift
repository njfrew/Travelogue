//
//  TravelogueEntry+CoreDataClass.swift
//  Travelogue
//
//  Created by Noah Frew on 12/11/20.
//
//

import Foundation
import CoreData
import UIKit

@objc(TravelogueEntry)
public class TravelogueEntry: NSManagedObject {
   var image: UIImage? {
       get {
           if let rawImage = rawImage {
               return UIImage(data: rawImage)
           } else {
               return nil
           }
       }
       set {
           if let newValue = newValue {
               rawImage = newValue.jpegData(compressionQuality: 1.0)
           }
       }
   }
   
   convenience init?(title: String, content:String, date: Date, image: UIImage?) {
       let appDelegate = UIApplication.shared.delegate as? AppDelegate
       guard let managedContext = appDelegate?.persistentContainer.viewContext else {
           return nil
       }
       
       self.init(entity: TravelogueEntry.entity(), insertInto: managedContext)
       
       self.title = title
       self.content = content
       self.date = date
       self.image = image
   }
}
