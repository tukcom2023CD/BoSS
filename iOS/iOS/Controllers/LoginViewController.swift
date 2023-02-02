//
//  ViewController.swift
//  iOS
//
//  Created by 이정동 on 2023/01/09.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // 테스트용 로그인 버튼
    @IBAction func testLoginButtonTapped(_ sender: UIButton) {
        
        let user = User(email: "lee@naver.com", name: "lee")
        
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

