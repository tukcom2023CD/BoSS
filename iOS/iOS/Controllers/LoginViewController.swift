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
    
    @IBAction func testLoginButtonTapped(_ sender: UIButton) {
        let tabBarVC = storyboard!.instantiateViewController(withIdentifier: "TabBarVC")
        
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: false)
    }
    
}

