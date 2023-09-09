//
//  RegisterViewModel.swift
//  Recipe
//
//  Created by 김민호 on 2023/09/07.
//

import Foundation
import RxSwift
import RxCocoa

class RegisterViewModel {
    
    // Input
    let nickNameInput = PublishRelay<String>()
    
    // Output
    let isNickNameValid: Driver<(Bool, String)>
    
    init() {
        let nickNameResult = nickNameInput
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .flatMapLatest { nickName -> Observable<(Bool, String)> in
                return Observable.create { observer in
                    if !nickName.isValidNickname() {
                        observer.onNext((false, nickName))
                    }
                    LoginService.shared.nickNameCheck(nickName: nickName, completion: { data in
                        observer.onNext((data, nickName))
                    })
                    return Disposables.create()
                }
            }
//            .share(replay: 1)
        
        isNickNameValid = nickNameResult
            .asDriver(onErrorJustReturn: (false, ""))
    }
    
    deinit {
        print("deinit")
    }
}
