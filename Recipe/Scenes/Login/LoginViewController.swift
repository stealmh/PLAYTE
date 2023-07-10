//
//  LoginViewController.swift
//  Recipe
//
//  Created by KindSoft on 2023/07/03.
//

import AuthenticationServices
import UIKit
import SnapKit

final class LoginViewController: BaseViewController {
    var didSendEventClosure: ((LoginViewController.Event) -> Void)?
    
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
    
    private let appleLoginButton: UIButton = {
        let v = UIButton()
        v.setTitle("애플로그인", for: .normal)
        v.backgroundColor = .systemBlue
        v.setTitleColor(.white, for: .normal)
        v.layer.cornerRadius = 8.0
        v.isHidden = true
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
    
    private let circleButton: UIButton = {
        let v = UIButton()
        v.layer.cornerRadius = 50/2
        v.clipsToBounds = true
        v.setImage(UIImage(named: "popcat"), for: .normal)
        v.backgroundColor = .black
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baseView.addSubViews(loginButton,
                             appleLoginButton,
                             easyLoginLabel,
                             easyLoginLeftLine,
                             easyLoginRightLine,
                             circleButton)
        view.addSubview(baseView)
        
        loginButton.snp.makeConstraints {
            $0.centerX.equalTo(baseView)
            $0.left.equalToSuperview().inset(24)
            $0.top.equalTo(baseView.snp.centerY).offset(150)
            $0.height.equalTo(44)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.left.right.width.height.equalTo(loginButton)
            $0.top.equalTo(loginButton.snp.bottom).offset(20)
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
        
        circleButton.snp.makeConstraints {
            $0.top.left.equalToSuperview()
            $0.width.height.equalTo(50)
        }
        
        
        loginButton.addTarget(self, action: #selector(didTapLoginButton(_:)), for: .touchUpInside)
        appleLoginButton.addTarget(self, action: #selector(didTapAppleLoginButton), for: .touchUpInside)
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

//MARK: - VC Preview
import SwiftUI
struct LoginViewController_preview: PreviewProvider {
    static var previews: some View {
        LoginViewController().toPreview()
    }
}
