import AuthenticationServices
import UIKit
import SnapKit
import GoogleSignIn
import RxSwift
import RxCocoa

enum LoginType {
    case apple
    case google
}

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
        v.setImage(UIImage(named: "googlelogin"), for: .normal)
//        v.isHidden = true
        return v
    }()
    
    private let guideLabel = UILabel()
    private let pdfButton: UILabel = {
        let v = UILabel()
        v.text = "계정 생성시 개인정보 처리방침 및\n이용약관 및 사용자 정책에 동의하게 됩니다."
        v.font = .systemFont(ofSize: 14)
        v.numberOfLines = 2
        v.textAlignment = .center
        v.textColor = .white
        v.isUserInteractionEnabled = true
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
                        googleButton,
                         pdfButton)
        view.backgroundColor = .mainColor
//        view.addSubview(baseView)
        
//        baseView.snp.makeConstraints {
//            $0.top.left.right.bottom.equalToSuperview()
//        }
        
        let fullText = "계정 생성시 개인정보 처리방침 및\n이용약관 및 사용자 정책에 동의하게 됩니다."
        let attributedText = NSMutableAttributedString(string: fullText)
        
        // "개인정보 처리방침" 텍스트에 밑줄 추가
        let range1 = (fullText as NSString).range(of: "개인정보 처리방침")
        attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        
        // "이용약관 및 사용자 정책" 텍스트에 밑줄 추가
        let range2 = (fullText as NSString).range(of: "이용약관 및 사용자 정책")
        attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range2)
        
        pdfButton.attributedText = attributedText
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        pdfButton.addGestureRecognizer(tapGesture)
        
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
            $0.left.equalTo(splashImageView).offset(-15)
//            $0.width.equalTo(20)
            $0.height.equalTo(1)
        }
        
        easyLoginRightLine.snp.makeConstraints {
            $0.centerY.equalTo(easyLoginLabel)
            $0.left.equalTo(easyLoginLabel.snp.right).offset(20)
            $0.right.equalTo(splashImageView).offset(15)
//            $0.width.equalTo(20)
            $0.height.equalTo(1)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(easyLoginLabel).offset(30)
            $0.right.equalTo(easyLoginLabel.snp.centerX).offset(-10)
            $0.width.height.equalTo(50)
//            $0.centerX.equalToSuperview()
        }
        
        googleButton.snp.makeConstraints {
            $0.top.equalTo(easyLoginLabel).offset(30)
            $0.left.equalTo(easyLoginLabel.snp.centerX).offset(10)
            $0.width.height.equalTo(50)
        }

        pdfButton.snp.makeConstraints {
            $0.top.equalTo(appleLoginButton.snp.bottom).offset(10)
            $0.left.equalTo(easyLoginLeftLine)
            $0.right.equalTo(easyLoginRightLine)
            $0.height.greaterThanOrEqualTo(40)
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
    
    @objc func labelTapped() {
        print("tapped")
        
        let vc = PDFViewController()
        navigationController?.pushViewController(vc, animated: true)
//        guard let pdfURL = URL(string: "https://github.com/stealmh/TIL/blob/main/term.pdf") else {
//            return
//        }
//
//        URLSession.shared.dataTask(with: pdfURL) { (data, response, error) in
//            guard let data = data, error == nil else {
//                print("Error downloading PDF: \(error?.localizedDescription ?? "")")
//                return
//            }
//
//            // Get the documents directory URL
//            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//                let pdfFileURL = documentsDirectory.appendingPathComponent("downloaded.pdf")
//
//                // Save the PDF data to the documents directory
//                do {
//                    try data.write(to: pdfFileURL)
//                    print("PDF downloaded and saved to: \(pdfFileURL)")
//
//                    // Display an alert to let the user know the download is complete
//                    DispatchQueue.main.async {
//                        self.showToastSuccess(message: "다운로드가 완료되었습니다")
//                    }
//                } catch {
//                    print("Error saving PDF: \(error.localizedDescription)")
//                }
//            }
//        }.resume()
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
                        KeyChain.shared.create(account: .loginType, data: "apple")
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
                          let accessToKen = result.user.accessToken.tokenString
                    // 서버에 토큰을 보내기. 이 때 idToken, accessToken 차이에 주의할 것
            KeyChain.shared.create(account: .idToken, data: accessToKen)
            ///Todo: 이동로직
            LoginService.shared.googleLogin(accessToken: KeyChain.shared.read(account: .idToken)) { isMember in
                switch isMember {
                case .success(let member):
                    KeyChain.shared.create(account: .loginType, data: "google")
                    member ? self.didSendEventClosure?(.isMember) :               self.didSendEventClosure?(.register)
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showConfirmationAlert(title: "서버가 원할하지 않습니다", message: "잠시 후 이용해주세요.")
                    }
                    print(error.localizedDescription)
                }
            }
            
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
