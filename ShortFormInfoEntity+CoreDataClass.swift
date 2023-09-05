//
//  ShortFormInfoEntity+CoreDataClass.swift
//  
//
//  Created by 김민호 on 2023/09/03.
//
//

import Foundation
import CoreData

@objc(ShortFormInfoEntity)
public class ShortFormInfoEntity: NSManagedObject {

    @NSManaged public var writtenid: Int64
}
