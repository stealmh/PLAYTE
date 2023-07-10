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

    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8.0
        
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8.0
        
        return button
    }()
    
    private let appleLoginButton: UIButton = {
        let v = UIButton()
        v.setTitle("애플로그인", for: .normal)
        v.backgroundColor = .systemBlue
        v.setTitleColor(.white, for: .normal)
        v.layer.cornerRadius = 8.0
        
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        view.addSubview(appleLoginButton)

        loginButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor,constant: 10),
            registerButton.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor),
            registerButton.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor),
            registerButton.widthAnchor.constraint(equalToConstant: 200),
            registerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        appleLoginButton.snp.makeConstraints {
            $0.left.right.width.height.equalTo(registerButton)
            $0.top.equalTo(registerButton.snp.bottom).offset(20)
        }
        
        
        loginButton.addTarget(self, action: #selector(didTapLoginButton(_:)), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(didTapRegisterButton(_:)), for: .touchUpInside)
        appleLoginButton.addTarget(self, action: #selector(didTapAppleLoginButton), for: .touchUpInside)
    }

    @objc private func didTapLoginButton(_ sender: Any) {
        didSendEventClosure?(.login)
    }
    
    @objc private func didTapRegisterButton(_ sender: Any) {
        didSendEventClosure?(.register)
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
