//
//  NewRecipeInfoEntity+CoreDataClass.swift
//  
//
//  Created by 김민호 on 2023/08/29.
//
//

import Foundation
import CoreData

@objc(NewRecipeInfoEntity)
public class NewRecipeInfoEntity: NSManagedObject {
    @NSManaged public var writtenid: Int64
}
