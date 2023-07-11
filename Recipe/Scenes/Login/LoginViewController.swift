//
//  LoginViewController.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/03.
//

import AuthenticationServices
import UIKit
import SnapKit
import GoogleSignIn
import RxSwift
import RxCocoa

final class LoginViewController: BaseViewController {
    var didSendEventClosure: ((LoginViewController.Event) -> Void)?
    private let disposeBag = DisposeBag()
    private let baseView: BaseStartingView = {
        let v = BaseStartingView()
        v.appLabel.textColor = .white
        v.subLabel.textColor = .white
        /// Todo: hexCode -> enum
        v.backgroundColor = UIColor.hexStringToUIColor(hex: "#FF5520")
        return v
    }()

    private let loginButton: UIButton = {
        let v = UIButton()
        v.setTitle("로그인", for: .normal)
        v.backgroundColor = .white
        v.setTitleColor(.black, for: .normal)
        v.layer.cornerRadius = 20.0
        return v
    }()
    
    private let easyLoginLabel: UILabel = {
        let v = UILabel()
        v.text = "간편 로그인"
        v.textColor = .white
        return v
    }()
    
    private let easyLoginLeftLine: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    private let easyLoginRightLine: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    private let appleLoginButton: UIButton = {
        let v = UIButton()
        v.layer.cornerRadius = 50/2
        v.clipsToBounds = true
        v.layer.masksToBounds = true
        v.setImage(UIImage(named: "apple_login"), for: .normal)
        v.backgroundColor = .black
        return v
    }()
    
    private let googleButton: UIButton = {
        let v = UIButton()
        v.layer.cornerRadius = 50/2
        v.clipsToBounds = true
        v.layer.masksToBounds = true
        v.backgroundColor = .white
        v.setImage(UIImage(named: "google_login"), for: .normal)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baseView.addSubViews(loginButton,
                             easyLoginLabel,
                             easyLoginLeftLine,
                             easyLoginRightLine,
                             appleLoginButton,
                            googleButton)
        view.addSubview(baseView)
        
        loginButton.snp.makeConstraints {
            $0.centerX.equalTo(baseView)
            $0.left.equalToSuperview().inset(24)
            $0.top.equalTo(baseView.snp.centerY).offset(150)
            $0.height.equalTo(44)
        }
        
        baseView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
        
        easyLoginLabel.snp.makeConstraints {
            $0.centerX.equalTo(baseView)
            $0.top.equalTo(loginButton.snp.bottom).offset(20)
            $0.height.equalTo(17)
        }
        
        easyLoginLeftLine.snp.makeConstraints {
            $0.centerY.equalTo(easyLoginLabel)
            $0.right.equalTo(easyLoginLabel.snp.left).offset(-5)
            $0.width.equalTo(20)
            $0.height.equalTo(1)
        }
        
        easyLoginRightLine.snp.makeConstraints {
            $0.centerY.equalTo(easyLoginLabel)
            $0.left.equalTo(easyLoginLabel.snp.right).offset(5)
            $0.width.equalTo(20)
            $0.height.equalTo(1)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(easyLoginLabel).offset(30)
            $0.right.equalTo(easyLoginLabel.snp.centerX).offset(-10)
            $0.width.height.equalTo(50)
        }
        
        googleButton.snp.makeConstraints {
            $0.top.equalTo(easyLoginLabel).offset(30)
            $0.left.equalTo(easyLoginLabel.snp.centerX).offset(10)
            $0.width.height.equalTo(50)
        }
        
        
        loginButton.addTarget(self, action: #selector(didTapLoginButton(_:)), for: .touchUpInside)
        appleLoginButton.addTarget(self, action: #selector(didTapAppleLoginButton), for: .touchUpInside)
        
        googleButton.rx.tap
            .subscribe(onNext: { _ in
                self.signInWithGoogle()
            }
        ).disposed(by: disposeBag)
    }

    @objc private func didTapLoginButton(_ sender: Any) {
        didSendEventClosure?(.login)
    }
    
    @objc private func didTapAppleLoginButton(_ sender: Any) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
               
        let authVC = ASAuthorizationController(authorizationRequests: [request])
        authVC.delegate = self
        authVC.presentationContextProvider = self
        authVC.performRequests()
    }
}

extension LoginViewController {
    enum Event {
        case login
        case register
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    //로그인 성공
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            // You can create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            if  let authorizationCode = appleIDCredential.authorizationCode,
                let identityToken = appleIDCredential.identityToken,
                let authCodeString = String(data: authorizationCode, encoding: .utf8),
                let identifyTokenString = String(data: identityToken, encoding: .utf8) {
                print("authorizationCode: \(!authorizationCode.isEmpty)")
                print("identityToken: \(!identityToken.isEmpty)")
                print("authCodeString: \(!authCodeString.isEmpty)")
                print("identifyTokenString: \(!identifyTokenString.isEmpty)")
            }
            
            print("useridentifier: \(!userIdentifier.isEmpty)")
            print("fullName: \(fullName)")
            print("email: \(email)")
            
            ///Todo: 이동로직
            didSendEventClosure?(.register)
            
        case let passwordCredential as ASPasswordCredential:
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            print("username: \(username)")
            print("password: \(password)")
            
        default:
            break
        }
    }
    

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("login failed - \(error.localizedDescription)")
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window!
    }
}

extension LoginViewController {
    private func signInWithGoogle() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] signInResult, _ in
                    guard let self,
                          let result = signInResult,
                          let token = result.user.idToken?.tokenString else { return }
            print(token)
                    // 서버에 토큰을 보내기. 이 때 idToken, accessToken 차이에 주의할 것
            }

    }
}

//MARK: - VC Preview
import SwiftUI
struct LoginViewController_preview: PreviewProvider {
    static var previews: some View {
        LoginViewController().toPreview()
    }
}
