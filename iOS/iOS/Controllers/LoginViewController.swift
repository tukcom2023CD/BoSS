//
//  ViewController.swift
//  iOS
//
//  Created by 이정동 on 2023/01/09.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn


class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    @IBOutlet weak var guestLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 로그인 버튼 설정
        setLoginButton()
        
    }
    
    // 로그인 버튼 설정
    func setLoginButton () {
        googleLoginButton.layer.cornerRadius = 20
        googleLoginButton.layer.borderWidth = 1
        googleLoginButton.layer.borderColor = UIColor.gray.cgColor
        
        appleLoginButton.layer.cornerRadius = 20
        
        guestLoginButton.layer.cornerRadius = 20
    }
    
    
    @IBAction func googleLoginButtonTapped(_ sender: UIButton) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
            
            guard error == nil else { print("Google Login Error"); return }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else { print("User authentication, idToken Error"); return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                guard error == nil else { print("Google Auth Error"); return }
                
                guard let authResult = authResult else { print("Err"); return }
                
                let user = User(email: authResult.user.email!, name: authResult.user.displayName!)
                
                UserNetManager.shared.loginUser(user: user) { user in
                    UserDefaults.standard.setLoginUser(user: user)
                    print(user)
                    
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let tabBarVC = storyboard.instantiateViewController(identifier: "TabBarVC")
                        
                        // Root View Controller 변경
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(tabBarVC)
                    }
                }
            }
            
        }
        
    }
    
    
    // 테스트용 로그인 버튼
    @IBAction func guestLoginButtonTapped(_ sender: UIButton) {
        print(#function)
        
        let user = User(email: "@Guest", name: "Guest")
        
        UserNetManager.shared.loginUser(user: user) { user in
            UserDefaults.standard.setLoginUser(user: user)
            print(user)
            
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarVC = storyboard.instantiateViewController(identifier: "TabBarVC")
                
                // Root View Controller 변경
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(tabBarVC)
            }
        }
    }
}

