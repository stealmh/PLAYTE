//
//  RecipeInfoEntity+CoreDataProperties.swift
//  
//
//  Created by 김민호 on 2023/08/29.
//
//

import Foundation
import CoreData


extension RecipeInfoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeInfoEntity> {
        return NSFetchRequest<RecipeInfoEntity>(entityName: "RecipeInfoEntity")
    }

    @NSManaged public var comment_count: Int32
    @NSManaged public var created_date: String?
    @NSManaged public var is_saved: Bool
    @NSManaged public var nickname: String?
    @NSManaged public var rating: Double
    @NSManaged public var recipe_id: Int32
    @NSManaged public var recipe_name: String?
    @NSManaged public var recipe_thumnail_img: String?

}
