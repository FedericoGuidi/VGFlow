//
//  LoginViewController.swift
//  VGFlow
//
//  Created by Federico Guidi on 17/04/22.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {

    @IBOutlet weak var loginProviderStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProviderLoginView()
    }
    
    func setupProviderLoginView() {
        let authorizationButton = ASAuthorizationAppleIDButton(type: .default, style: .whiteOutline)
        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        self.loginProviderStackView.addArrangedSubview(authorizationButton)
    }
    
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    /// - Tag: did_complete_authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            let authCode = String(data: appleIDCredential.authorizationCode!, encoding: .utf8)!
            
            Task {
                do {
                    let token = try await LoginRequest(authCode: authCode).send()
                    self.saveBearerInKeychain(token.idToken)
                    
                    let userIdentifier = appleIDCredential.user
                    self.saveUserInKeychain(userIdentifier)
                    
                    let profile = try await ProfileRequest().send()
                    self.showProfileViewController(userId: userIdentifier, profile: profile)
                } catch {
                    print(error)
                }
            }
        default:
            break
        }
    }
    
    private func saveBearerInKeychain(_ bearerToken: String) {
        do {
            try KeychainItem(service: "com.federicoguidi.VGFlow", account: "bearer").saveItem(bearerToken)
        } catch {
            print("Unable to save bearer to keychain.")
        }
    }
    
    private func saveUserInKeychain(_ userIdentifier: String) {
        do {
            try KeychainItem(service: "com.federicoguidi.VGFlow", account: "userIdentifier").saveItem(userIdentifier)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
    
    private func showProfileViewController(userId: String, profile: Profile) {
        //guard let tabBarController = self.presentingViewController as? UITabBarController else { return }
        //guard let viewController = tabBarController.viewControllers![0] as? ProfileCollectionViewController else { return }
        DispatchQueue.main.async {
            //viewController.userDescriptionLabel.text = userId
            //viewController.nameLabel.text = profile.name
            //viewController.descriptionLabel.text = profile.description
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func showPasswordCredentialAlert(username: String, password: String) {
        let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
        let alertController = UIAlertController(title: "Keychain Credential Received", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// - Tag: did_complete_error
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    /// - Tag: provide_presentation_anchor
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension UIViewController {
    func showLoginViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginViewController") as? LoginViewController {
            loginViewController.modalPresentationStyle = .fullScreen
            loginViewController.isModalInPresentation = true
            loginViewController.modalTransitionStyle = .crossDissolve
            self.present(loginViewController, animated: true, completion: nil)
        }
    }
}
