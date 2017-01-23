//
//  Search+CoreDataProperties.swift
//  
//
//  Created by Aleksei Neronov on 23.01.17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Search {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Search> {
        return NSFetchRequest<Search>(entityName: "Search");
    }

    @NSManaged public var price: Double
    @NSManaged public var thumb: NSObject?
    @NSManaged public var title: String?

}
