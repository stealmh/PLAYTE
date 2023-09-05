//
//  UserReportHelper.swift
//  Recipe
//
//  Created by 김민호 on 2023/09/03.
//

import UIKit
import CoreData

class UserReportHelper {
    static let shared = UserReportHelper()
    
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // MARK: - CRUD Functions
    
    func createUserReport(userId: Int64) -> Bool {
        let userReport = UserReportEntity(context: context)
        userReport.userId = userId
        
        do {
            try context.save()
            return true
        } catch {
            print("Error creating user report: \(error.localizedDescription)")
            return false
        }
    }
    
    func fetchUserReports() -> [UserReportEntity] {
        let fetchRequest: NSFetchRequest<UserReportEntity> = UserReportEntity.fetchRequest()
        
        do {
            let userReports = try context.fetch(fetchRequest)
            return userReports
        } catch {
            print("Error fetching user reports: \(error.localizedDescription)")
            return []
        }
    }
    
    func updateUserReport(userReport: UserReportEntity, newUserId: Int64) {
        userReport.userId = newUserId
        
        saveContext()
    }
    
    func deleteUserReport(userReport: UserReportEntity) {
        context.delete(userReport)
        saveContext()
    }
    
    func isUserIdInUserReports(userId: Int64) -> Bool {
        let fetchRequest: NSFetchRequest<UserReportEntity> = UserReportEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userId == %lld", userId)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking user ID existence: \(error.localizedDescription)")
            return false
        }
    }
    
    func deleteUserReportIfUserIdMatches(userId: Int64) {
        let fetchRequest: NSFetchRequest<UserReportEntity> = UserReportEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userId == %lld", userId)
        
        do {
            if let userReport = try context.fetch(fetchRequest).first {
                context.delete(userReport)
                saveContext()
            }
        } catch {
            print("Error deleting user report: \(error.localizedDescription)")
        }
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error.localizedDescription)")
            }
        }
    }
}
