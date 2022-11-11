//
//  Photo+CoreDataProperties.swift
//  CoreDataTutorial
//
//  Created by Pyae Phyo Oo on 10/11/22.
//  Copyright © 2022 James Rochabrun. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var author: String?
    @NSManaged public var media: String?
    @NSManaged public var tags: String?

}

extension Photo : Identifiable {

}
