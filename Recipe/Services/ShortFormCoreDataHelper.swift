//
//  ShortFormCoreDataHelper.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/29.
//
import CoreData
import UIKit

class ShortFormCoreDataHelper {
    
    static let shared = ShortFormCoreDataHelper()
    
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    // 1. 저장 함수
    func saveShortForm(code: ShortFormInfo) -> Bool {
        let request: NSFetchRequest<ShortFormInfoEntity> = ShortFormInfoEntity.fetchRequest()
            request.predicate = NSPredicate(format: "shortform_d == %d", code.shortform_id)
        
        do {
            let fetchResults = try context.fetch(request)
            if fetchResults.count > 0 {
                print("데이터가 이미 존재합니다.")
                return false
            }
        } catch {
            print("중복 체크 중 오류 발생: \(error)")
            return false
        }
        
        let shortForm = ShortFormInfoEntity(context: context)
        shortForm.comments_count = Int64(code.comments_count)
        shortForm.created_date = code.created_date
        shortForm.is_liked = code.is_liked
        shortForm.is_saved = code.is_saved
        shortForm.likes_count = Int64(code.likes_count)
        shortForm.saved_count = Int64(code.saved_count)
        shortForm.shortform_d = Int64(code.shortform_id)
        shortForm.shortform_description = code.shortform_description
        shortForm.shortform_name = code.shortform_name
        shortForm.video_time = code.video_time
        shortForm.video_url = code.video_url
        shortForm.writtenBy = code.writtenBy
        
        let ingredientsArray = convertToEntity(ingredient: code.ingredients, context: context)
        let ingredientSet = NSSet(array: ingredientsArray)
        shortForm.ingredients = ingredientSet
        // 다른 필드들도 설정할 수 있습니다.

        do {
            try context.save()
            print("성공적으로 저장!!!!!")
            return true
        } catch {
            print("Failed saving: \(error)")
            return false
        }
    }

    // 2. 검색 함수
    func fetchAllShortForms() -> [ShortFormInfoEntity]? {
        print(#function)
        let fetchRequest = NSFetchRequest<ShortFormInfoEntity>(entityName: "ShortFormInfoEntity")

        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            print("Failed fetching: \(error)")
            return nil
        }
    }

    // 3. 삭제 함수
    func deleteShortForm(byCode id: Int) -> Bool {
        let fetchRequest = NSFetchRequest<ShortFormInfoEntity>(entityName: "ShortFormInfoEntity")
        fetchRequest.predicate = NSPredicate(format: "shortform_d == %d", id)

        do {
            let result = try context.fetch(fetchRequest)
            
            if let objectToDelete = result.first {
                context.delete(objectToDelete)
                try context.save()
                return true
            }
        } catch {
            print("Failed deleting: \(error)")
            return false
        }
        return false
    }
    
    func convertToEntity(ingredient: [ShortFormDetailIngredient], context: NSManagedObjectContext) -> [ShortFormIngredientEntity] {
        
        return ingredient.map { ingredient in
            let ingredientEntity = ShortFormIngredientEntity(context: context)
            ingredientEntity.ingredient_id = Int64(ingredient.ingredient_id)
            ingredientEntity.ingredient_name = ingredient.ingredient_name
            ingredientEntity.ingredient_size = ingredient.ingredient_size ?? 0.0
            ingredientEntity.ingredient_type = ingredient.ingredient_type
            ingredientEntity.is_rocket_delivery = ingredient.is_rocket_delivery
            ingredientEntity.coupang_product_url = ingredient.coupang_product_url
            ingredientEntity.coupang_product_name = ingredient.coupang_product_name
            ingredientEntity.coupang_product_image = ingredient.coupang_product_image
            ingredientEntity.coupang_product_price = Int64(ingredient.coupang_product_price)
            return ingredientEntity
        }
    }
}

extension ShortFormInfo {
    init(from entity: ShortFormInfoEntity) {
        var tempIngredients: [ShortFormDetailIngredient] = []
        
        if let ingredientSet = entity.ingredients as? Set<ShortFormIngredientEntity> {
            tempIngredients = ingredientSet.map {
                ShortFormDetailIngredient(ingredient_id: Int($0.ingredient_id),
                                          ingredient_name: $0.ingredient_name ?? "",
                                          ingredient_type: $0.ingredient_type ?? "",
                                          ingredient_size: $0.ingredient_size,
                                          ingredient_unit: $0.ingredient_unit ?? "",
                                          coupang_product_image: $0.coupang_product_image ?? "",
                                          coupang_product_name: $0.coupang_product_name ?? "",
                                          coupang_product_price: Int($0.coupang_product_price),
                                          coupang_product_url: $0.coupang_product_url ?? "",
                                          is_rocket_delivery: $0.is_rocket_delivery)
            }
        }
        
        self.ingredients = tempIngredients
        self.shortform_id = Int(entity.shortform_d)
        self.is_liked = entity.is_liked
        self.is_saved = entity.is_saved
        self.likes_count = Int(entity.likes_count)
        self.saved_count = Int(entity.saved_count)
        self.video_url = entity.video_url ?? ""
        self.comments_count = Int(entity.comments_count)
        self.shortform_description = entity.shortform_description ?? ""
        self.video_time = entity.video_time ?? "00:00"
        self.writtenBy = entity.writtenBy ?? ""
        self.created_date = entity.created_date ?? ""
        self.shortform_name = entity.shortform_name ?? ""
        self.writtenid = Int(entity.writtenid)
    }
}
