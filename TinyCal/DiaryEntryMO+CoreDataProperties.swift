//
//  DiaryEntryMO+CoreDataProperties.swift
//  
//
//  Created by ERIC on 10/2/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension DiaryEntryMO {

    @NSManaged var date: NSDate?
    @NSManaged var emotion: String?
    @NSManaged var text: String?

}
