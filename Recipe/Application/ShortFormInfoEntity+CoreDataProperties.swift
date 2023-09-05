//
//  ShortFormInfoEntity+CoreDataProperties.swift
//  
//
//  Created by 김민호 on 2023/08/29.
//
//

import Foundation
import CoreData


extension ShortFormInfoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShortFormInfoEntity> {
        return NSFetchRequest<ShortFormInfoEntity>(entityName: "ShortFormInfoEntity")
    }

    @NSManaged public var comments_count: Int64?
    @NSManaged public var created_date: String?
    @NSManaged public var is_liked: Bool
    @NSManaged public var is_saved: Bool
    @NSManaged public var likes_count: Int64
    @NSManaged public var saved_count: Int64
    @NSManaged public var shortform_description: String?
    @NSManaged public var shortform_d: Int64
    @NSManaged public var shortform_name: String?
    @NSManaged public var video_time: String?
    @NSManaged public var writtenBy: String?
    @NSManaged public var ingredients: ShortFormIngredientEntity?

}
