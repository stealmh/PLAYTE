//
//  Protocols.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/03.
//

import UIKit

/// For Coordinator
protocol MypageCoordinatorProtocol: Coordinator {
    func startReadyFlow()
}

protocol SplashCoordinatorProtocol: Coordinator {
    func showSplashView()
}

protocol LoginCoordinatorProtocol: Coordinator {
    func showLoginViewController()
}

protocol RegisterCoordinatorProtocol: Coordinator {
    func showRegisterViewController()
}

protocol HomeCoordinatorProtocol: Coordinator {
    func startReadyFlow()
}

/// Else
protocol RefrigeratorDetailDelegate{
    func onClickButton(_ senderTitle: String)
}

protocol PriceTrendHeaderDelegate {
    func showAllData()
}

protocol TagCellDelegate {
    func deleteButtonTapped(name: String, sender: Int)
}

