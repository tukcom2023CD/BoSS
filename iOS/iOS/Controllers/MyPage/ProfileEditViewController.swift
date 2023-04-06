//
//  ProfileEditViewController.swift
//  iOS
//
//  Created by JunHee on 2023/04/06.
//

import UIKit
import GoogleSignIn

class ProfileEdirViewController : UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serUI()
        setUserEmail()
        setUserName()
        setUserImage()
        emailTextField.isEnabled = false // 이메일 수정 못하도록 설정
    }
    
    func serUI() {
        self.cancelButton.layer.cornerRadius = 20
        self.applyButton.layer.cornerRadius = 20
        self.selectImageButton.layer.cornerRadius = 25
    }
    
    // 유저 이메일 표시 함수
    func setUserEmail() {
        guard let userEmail = UserDefaults.standard.string(forKey: "userEmail") else {
            return
        }
        self.emailTextField.text = userEmail
    }
    
    // 유저 이름 표시 함수
    func setUserName() {
        guard let userName = UserDefaults.standard.string(forKey: "userName") else {
            return
        }
        self.nameTextField.text = userName
    }
    
    // 유저 사진 표시 함수
    func setUserImage() {
        guard let userImage = UserDefaults.standard.data(forKey: "userImage") else {
            return
        }
        self.userImageView.image = UIImage(data: userImage)
    }
}


