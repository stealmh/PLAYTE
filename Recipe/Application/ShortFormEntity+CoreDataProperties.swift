//
//  ShortFormEntity+CoreDataProperties.swift
//  
//
//  Created by 김민호 on 2023/08/29.
//
//

import Foundation
import CoreData


extension ShortFormEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShortFormEntity> {
        return NSFetchRequest<ShortFormEntity>(entityName: "ShortFormEntity")
    }

    @NSManaged public var code: String?
    @NSManaged public var data: ShortFormContentEntity?

}
