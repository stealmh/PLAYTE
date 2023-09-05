//
//  ShortFormIngredientEntity+CoreDataProperties.swift
//  
//
//  Created by 김민호 on 2023/08/29.
//
//

import Foundation
import CoreData


extension ShortFormIngredientEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShortFormIngredientEntity> {
        return NSFetchRequest<ShortFormIngredientEntity>(entityName: "ShortFormIngredientEntity")
    }

    @NSManaged public var ingredient_id: Int64
    @NSManaged public var ingredient_name: String?
    @NSManaged public var ingredient_type: String?
    @NSManaged public var ingredient_size: Double?
    @NSManaged public var ingredient_unit: String?
    @NSManaged public var coupang_product_image: String?
    @NSManaged public var coupang_product_name: String?
    @NSManaged public var coupang_product_price: Int64
    @NSManaged public var coupang_product_url: String?
    @NSManaged public var is_rocket_delivery: Bool

}
