//
//  SceneDelegate.swift
//  VGFlow
//
//  Created by Federico Guidi on 16/04/22.
//

import UIKit
import AuthenticationServices

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { (credentialState, error) in
            switch credentialState {
            case .authorized:
                break // The Apple ID credential is valid.
            case .revoked, .notFound:
                // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                #if DEBUG
                try? KeychainItem(service: "com.federicoguidi.VGFlow", account: "bearer").saveItem("eyJraWQiOiJXNldjT0tCIiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJodHRwczovL2FwcGxlaWQuYXBwbGUuY29tIiwiYXVkIjoiY29tLmZlZGVyaWNvZ3VpZGkuVkdGbG93IiwiZXhwIjoxNjUwNTcxMjE4LCJpYXQiOjE2NTA0ODQ4MTgsInN1YiI6IjAwMTMwOS5iY2E2YTdjYWU0MGM0ODE1OTk1ZDE5NTIyZmRkZTVhMC4xNTM3IiwiYXRfaGFzaCI6IllTeTZZQnhUaWhwcmQ2aUJFRVNaX0EiLCJlbWFpbCI6InFjcmNqcndodGNAcHJpdmF0ZXJlbGF5LmFwcGxlaWQuY29tIiwiZW1haWxfdmVyaWZpZWQiOiJ0cnVlIiwiaXNfcHJpdmF0ZV9lbWFpbCI6InRydWUiLCJhdXRoX3RpbWUiOjE2NTA0ODQ3NjksIm5vbmNlX3N1cHBvcnRlZCI6dHJ1ZX0.ltJ_u_OlOColyG5i9tCKMs4etQwcu-eII231aPApMA1IPcV2NKh8uVhVF-7GRiukqWtj2zk2l_NQG1X8qPfGI88Vl1Tiql3nuW3NWWbpLSVQWHtIm5w7MIbY3jaG3HyADVqZG-nSYR-lVDnzSfXhOqxpNoIpJutOP_-J7Ekyfch1x8EPgwGB_8FXWfaHcdgqa5I5YVcFM1UnNVOPkcLqea9W0BlDzw1IP7GxVJx7N81BK_vpWoCgE9KGBmnGVeaRD2yCg2fG55LrBLzii8kFY-umCG1p6XFwYCRG69KSPDe-b7gnDxYsz5dOhPhABgYS7ybABwzVelFBBfbuC3ED4A")
                try? KeychainItem(service: "com.federicoguidi.VGFlow", account: "userIdentifier").saveItem("001309.bca6a7cae40c4815995d19522fdde5a0.1537")
                #else
                DispatchQueue.main.async {
                    self.window?.rootViewController?.showLoginViewController()
                }
                #endif
            default:
                break
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

