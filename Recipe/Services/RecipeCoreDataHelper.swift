//
//  RecipeCoreDataHelper.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/29.
//

import CoreData
import UIKit

class RecipeCoreDataHelper {
    
    static let shared = RecipeCoreDataHelper()
    
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    // 1. 저장 함수
    func saveRecipe(code: RecipeInfo) -> Bool {
        let request: NSFetchRequest<NewRecipeInfoEntity> = NewRecipeInfoEntity.fetchRequest()
            request.predicate = NSPredicate(format: "recipe_id == %d", code.recipe_id)
        
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
        
        let recipe = NewRecipeInfoEntity(context: context)
        recipe.comment_count = Int32(code.comment_count)
        recipe.created_date = code.created_date
        recipe.is_saved = code.is_saved
        recipe.nickname = code.nickname
        recipe.rating = Double(code.rating)
        recipe.recipe_id = Int32(code.recipe_id)
        recipe.recipe_name = code.recipe_name
        recipe.recipe_thumbnail_img = code.recipe_thumbnail_img
        recipe.cook_time = Int32(code.cook_time)

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
    func fetchAllRecipes() -> [NewRecipeInfoEntity]? {
        print(#function)
        let fetchRequest = NSFetchRequest<NewRecipeInfoEntity>(entityName: "NewRecipeInfoEntity")

        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            print("Failed fetching: \(error)")
            return nil
        }
    }

    // 3. 삭제 함수
    func deleteRecipe(byID id: Int) -> Bool {
        let fetchRequest = NSFetchRequest<NewRecipeInfoEntity>(entityName: "NewRecipeInfoEntity")
        fetchRequest.predicate = NSPredicate(format: "recipe_id == %d", id)

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
}

extension RecipeInfo {
    init(from entity: NewRecipeInfoEntity) {
        self.comment_count = Int(entity.comment_count)
        self.created_date = entity.created_date ?? ""
        self.is_saved = entity.is_saved
        self.nickname = entity.nickname ?? ""
        self.rating = Float(entity.rating)
        self.recipe_id = Int(entity.recipe_id)
        self.recipe_name = entity.recipe_name ?? ""
        self.recipe_thumbnail_img = entity.recipe_thumbnail_img ?? ""
        self.cook_time = Int(entity.cook_time)
        self.writtenid = Int(entity.writtenid)
    }
}
