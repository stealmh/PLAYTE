//
//  ShortFormViewModel.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/28.
//

import Foundation
import RxSwift
import RxCocoa

class ShortFormViewModel {
    var shortForm = PublishRelay<ShortForm>()
    var saveShortForm = PublishRelay<ShortFormDefaultResult>()
    var unsaveShortForm = PublishRelay<ShortFormDefaultResult>()
    var likeShortForm = PublishRelay<ShortFormDefaultResult>()
    var unlikeShortForm = PublishRelay<ShortFormDefaultResult>()
    
    init() {
        Task {
            await getShortFormList()
        }
    }
    
    func getShortFormList() async {
        do {
            let data1: ShortForm = try await NetworkManager.shared.get(.shortForms)
            shortForm.accept(data1)
        } catch {
            print("ShortFormViewModel getShortFormList Error")
        }
    }
    
    func saveShortForm(_ shortFormId: Int) async -> ShortFormDefaultResult? {
        do {
            let data1: ShortFormDefaultResult = try await NetworkManager.shared.get(.saveShortForm("\(shortFormId)"))
            saveShortForm.accept(data1)
            return data1
        } catch {
            print("\(#function) error")
            return nil
        }
    }
    func unsaveShortForm(_ shortFormId: Int) async -> ShortFormDefaultResult?{
        do {
            let data1: ShortFormDefaultResult = try await NetworkManager.shared.get(.unsaveShortForm("\(shortFormId)"))
            unsaveShortForm.accept(data1)
            return data1
        } catch {
            print("\(#function) error")
            return nil
        }
    }
    func likeShortForm(_ shortFormId: Int) async -> ShortFormDefaultResult? {
        do {
            let data1: ShortFormDefaultResult = try await NetworkManager.shared.get(.likeShortForm("\(shortFormId)"))
            likeShortForm.accept(data1)
            return data1
        } catch {
            print("\(#function) error")
            return nil
        }
    }
    func unlikeShortForm(_ shortFormId: Int) async -> ShortFormDefaultResult? {
        do {
            let data1: ShortFormDefaultResult = try await NetworkManager.shared.get(.unlikeShortForm("\(shortFormId)"))
            unlikeShortForm.accept(data1)
            return data1
        } catch {
            print("\(#function) error")
            return nil
        }
    }
}
