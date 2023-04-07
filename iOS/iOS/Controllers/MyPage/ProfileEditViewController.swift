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
    @IBOutlet weak var setDefaultImageButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serUI()
        
        emailTextField.delegate = self
        nameTextField.delegate = self
        
        setUserEmail()
        setUserName()
        setUserImage()
        
        emailTextField.isEnabled = false // 이메일 수정 못하도록 설정
    }
    
    func serUI() {
        self.cancelButton.layer.cornerRadius = 20
        self.applyButton.layer.cornerRadius = 20
        self.userImageView.layer.cornerRadius = 75
        self.userImageView.contentMode = .scaleAspectFill
        self.selectImageButton.layer.cornerRadius = 25
        self.setDefaultImageButton.layer.cornerRadius = 10
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
    
    // 변경사항 적용 함수
    func applyEditChanges() {
        if let email = self.emailTextField.text{
            UserDefaults.standard.set(email, forKey: "userEmail")
        }
        
        if let name = self.nameTextField.text{
            UserDefaults.standard.set(name, forKey: "userName")
        }
        
        if let imageData = self.userImageView.image!.pngData() {
            UserDefaults.standard.set(imageData, forKey: "userImage")
        }
    }
    
    // 기본 이미지 버튼 클릭시
    @IBAction func setDefaultImageButtonTapped(_ sender: UIButton) {
        self.userImageView.image = UIImage(named: "user")
    }

    // 취소 버튼 클릭시
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // 적용 버튼 클릭시
    @IBAction func applyButtonTapped(_ sender: UIButton) {
        applyEditChanges() // 변경 사항 적용
        NotificationCenter.default.post(name: NSNotification.Name("ProfileChanged"), object: self)
        dismiss(animated: true, completion: nil)
    }
    
    // 이미지 선택 버튼 클릭시
    @IBAction func imageSelectButtonTapped(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
}

extension ProfileEdirViewController : UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // 글자수 제한 함수
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // 글자 수를 제한하는 코드
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else {
                return
            }
            userImageView.image = image
            dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
}
