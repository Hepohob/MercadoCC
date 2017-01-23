//
//  Product+CoreDataProperties.swift
//  
//
//  Created by Aleksei Neronov on 23.01.17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product");
    }

    @NSManaged public var descript: String?
    @NSManaged public var id: String?
    @NSManaged public var image: NSObject?
    @NSManaged public var price: Double
    @NSManaged public var title: String?

}
