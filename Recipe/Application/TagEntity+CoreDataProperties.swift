//
//  TagEntity+CoreDataProperties.swift
//  
//
//  Created by 김민호 on 2023/08/29.
//
//

import Foundation
import CoreData


extension TagEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TagEntity> {
        return NSFetchRequest<TagEntity>(entityName: "TagEntity")
    }

    @NSManaged public var tag: String?

}
