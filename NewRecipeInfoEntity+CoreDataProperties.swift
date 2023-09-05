//
//  NewRecipeInfoEntity+CoreDataProperties.swift
//  
//
//  Created by 김민호 on 2023/09/03.
//
//

import Foundation
import CoreData


extension NewRecipeInfoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewRecipeInfoEntity> {
        return NSFetchRequest<NewRecipeInfoEntity>(entityName: "NewRecipeInfoEntity")
    }

    @NSManaged public var comment_count: Int32
    @NSManaged public var cook_time: Int32
    @NSManaged public var created_date: String?
    @NSManaged public var is_saved: Bool
    @NSManaged public var nickname: String?
    @NSManaged public var rating: Double
    @NSManaged public var recipe_id: Int32
    @NSManaged public var recipe_name: String?
    @NSManaged public var recipe_thumbnail_img: String?
    @NSManaged public var writtenid: Int64

}
