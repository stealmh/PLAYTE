//
//  ShortFormInfoEntity+CoreDataProperties.swift
//  
//
//  Created by 김민호 on 2023/09/03.
//
//

import Foundation
import CoreData


extension ShortFormInfoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShortFormInfoEntity> {
        return NSFetchRequest<ShortFormInfoEntity>(entityName: "ShortFormInfoEntity")
    }

    @NSManaged public var comments_count: Int64
    @NSManaged public var created_date: String?
    @NSManaged public var is_liked: Bool
    @NSManaged public var is_saved: Bool
    @NSManaged public var likes_count: Int64
    @NSManaged public var saved_count: Int64
    @NSManaged public var shortform_d: Int64
    @NSManaged public var shortform_description: String?
    @NSManaged public var shortform_name: String?
    @NSManaged public var video_time: String?
    @NSManaged public var video_url: String?
    @NSManaged public var writtenBy: String?
    @NSManaged public var writtenid: Int64
    @NSManaged public var ingredients: NSSet?

}

// MARK: Generated accessors for ingredients
extension ShortFormInfoEntity {

    @objc(addIngredientsObject:)
    @NSManaged public func addToIngredients(_ value: ShortFormIngredientEntity)

    @objc(removeIngredientsObject:)
    @NSManaged public func removeFromIngredients(_ value: ShortFormIngredientEntity)

    @objc(addIngredients:)
    @NSManaged public func addToIngredients(_ values: NSSet)

    @objc(removeIngredients:)
    @NSManaged public func removeFromIngredients(_ values: NSSet)

}
