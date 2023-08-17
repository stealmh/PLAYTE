import AuthenticationServices
import UIKit
import SnapKit
import GoogleSignIn
import RxSwift
import RxCocoa

final class LoginViewController: BaseViewController {
    var didSendEventClosure: ((LoginViewController.Event) -> Void)?
    private var disposeBag = DisposeBag()
    
    private let splashImageView: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "splash2")
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
    
    override func viewWillDisappear(_ animated: Bool) {
        disposeBag = DisposeBag()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        baseView.addSubViews(
//                             easyLoginLabel,
//                             easyLoginLeftLine,
//                             easyLoginRightLine,
//                             appleLoginButton,
//                            googleButton)
        view.addSubViews(splashImageView,
                         easyLoginLabel,
                         easyLoginLeftLine,
                         easyLoginRightLine,
                         appleLoginButton,
                        googleButton)
        view.backgroundColor = .mainColor
//        view.addSubview(baseView)
        
//        baseView.snp.makeConstraints {
//            $0.top.left.right.bottom.equalToSuperview()
//        }
        
        splashImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.snp.centerY).offset(-40)
            $0.width.equalTo(239.06)
            $0.height.equalTo(81.57)
        }
        
        easyLoginLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.snp.bottom).inset(180)
            $0.height.equalTo(17)
        }
        
        easyLoginLeftLine.snp.makeConstraints {
            $0.centerY.equalTo(easyLoginLabel)
            $0.right.equalTo(easyLoginLabel.snp.left).offset(-20)
            $0.left.equalTo(splashImageView).inset(10)
//            $0.width.equalTo(20)
            $0.height.equalTo(1)
        }
        
        easyLoginRightLine.snp.makeConstraints {
            $0.centerY.equalTo(easyLoginLabel)
            $0.left.equalTo(easyLoginLabel.snp.right).offset(20)
            $0.right.equalTo(splashImageView).inset(10)
//            $0.width.equalTo(20)
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
        
        
        appleLoginButton.addTarget(self, action: #selector(didTapAppleLoginButton), for: .touchUpInside)
        
        googleButton.rx.tap
            .subscribe(onNext: { _ in
                self.signInWithGoogle()
            }
        ).disposed(by: disposeBag)
    }
    
    @objc private func didTapAppleLoginButton(_ sender: Any) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
//        request.nonce = "recipe_nonce_val12"
               
        let authVC = ASAuthorizationController(authorizationRequests: [request])
        authVC.delegate = self
        authVC.presentationContextProvider = self
        authVC.performRequests()
    }
}

extension LoginViewController {
    enum Event {
        case register
        case isMember
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    //로그인 성공
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            // You can create an account in your system.
            let userIdentifier = appleIDCredential.user
            let email = appleIDCredential.email
            if  let authorizationCode = appleIDCredential.authorizationCode,
                let identityToken = appleIDCredential.identityToken,
                let authCodeString = String(data: authorizationCode, encoding: .utf8),
                let identifyTokenString = String(data: identityToken, encoding: .utf8) {
                KeyChain.shared.create(account: .idToken, data: identifyTokenString)
                ///Todo: 이동로직
                LoginService.shared.appleLogin(accessToken: KeyChain.shared.read(account: .idToken)) { isMember in
                    switch isMember {
                    case .success(let member):
                        member ? self.didSendEventClosure?(.isMember) :               self.didSendEventClosure?(.register)
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.showConfirmationAlert(title: "서버가 원할하지 않습니다", message: "잠시 후 이용해주세요.")
                        }
                        print(error.localizedDescription)
                    }
                }
            }
            
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
import Alamofire
struct LoginViewController_preview: PreviewProvider {
    static var previews: some View {
        LoginViewController()
            .toPreview()
            .ignoresSafeArea()
    }
}
