//
//  ShortFormContentEntity+CoreDataProperties.swift
//  
//
//  Created by 김민호 on 2023/08/29.
//
//

import Foundation
import CoreData


extension ShortFormContentEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShortFormContentEntity> {
        return NSFetchRequest<ShortFormContentEntity>(entityName: "ShortFormContentEntity")
    }

    @NSManaged public var content: ShortFormInfoEntity?

}
