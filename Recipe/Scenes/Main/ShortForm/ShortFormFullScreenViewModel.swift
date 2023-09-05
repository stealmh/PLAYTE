//
//  ShortFormFullScreenViewModel.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/29.
//

import Foundation

class ShortFormFullScreenViewModel {
    func notInterest(_ shortFormId: Int) async -> DefaultReturnBool? {
        do {
            let data1: DefaultReturnBool = try await NetworkManager.shared.get(.shortformNotInterest("\(shortFormId)"))
            return data1
        } catch {
            print("\(#function) error")
            return nil
        }
    }

    func report(_ shortFormId: Int) async -> DefaultReturnBool? {
        do {
            let data1: DefaultReturnBool = try await NetworkManager.shared.get(.shortformReport("\(shortFormId)"))
            return data1
        } catch {
            print("\(#function) error")
            return nil
        }
    }
}

