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
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarVC = storyboard.instantiateViewController(identifier: "TabBarVC")
        
        // Root View Controller 변경
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(tabBarVC)
//        let tabBarVC = storyboard!.instantiateViewController(withIdentifier: "TabBarVC")
//        tabBarVC.modalPresentationStyle = .fullScreen
//        present(tabBarVC, animated: false)
    }
    
}

