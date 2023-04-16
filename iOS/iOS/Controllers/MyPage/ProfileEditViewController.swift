//
//  ProfileEditViewController.swift
//  iOS
//
//  Created by JunHee on 2023/04/06.
//

import UIKit
import GoogleSignIn

// 사용자 프로필 편집 화면
class ProfileEdirViewController : UIViewController {
     
    @IBOutlet weak var cancelButton: UIButton! // 취소 버튼
    @IBOutlet weak var applyButton: UIButton! // 적용 버튼
    
    @IBOutlet weak var selectImageButton: UIButton! // 이미지 선택 버튼
    @IBOutlet weak var userImageView: UIImageView! // 유저 이미지 뷰
    
    @IBOutlet weak var emailTextField: UITextField! // 이메일 텍스트 필드
    @IBOutlet weak var nameTextField: UITextField! // 이름 텍스트 필드
    @IBOutlet weak var setDefaultImageButton: UIButton! // 기본 이미지 설정 버튼
    
    // 사용자 로그인 종류 구분
    var userLoginType : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI() // UI설정
        
        emailTextField.delegate = self
        nameTextField.delegate = self
        
        self.userLoginType = checkLoginType()
        
        // 유저 정보 설정
        setUserEmail()
        setUserName()
        setUserImage()
        
        // 이메일 수정 못하도록 설정
        emailTextField.isEnabled = false // 이메일 수정 못하도록 설정
    }
    
    func setUI() {
        self.cancelButton.layer.cornerRadius = 20
        self.applyButton.layer.cornerRadius = 20
        self.userImageView.layer.cornerRadius = 75
        self.userImageView.contentMode = .scaleAspectFill
        self.selectImageButton.layer.cornerRadius = 25
        self.setDefaultImageButton.layer.cornerRadius = 10
    }
    
    // 로그인 타입 확인
    func checkLoginType() -> String {
        if let user = GIDSignIn.sharedInstance.currentUser {
            if ((user.profile?.email) != nil) {
                return ("Google")
            } else {
                return ("Google")
            }
        } else {
            return ("Guest")
        }
    }
    
    // 유저 이메일 표시 함수
    func setUserEmail() {
        if self.userLoginType == "Google"{
            guard let userEmail = UserDefaults.standard.string(forKey: "userGoogleEmail") else {
                return
            }
            self.emailTextField.text = userEmail
        } else {
                guard let userEmail = UserDefaults.standard.string(forKey: "userGuestEmail") else {
                    return
                }
                self.emailTextField.text = userEmail
        }
       
    }
    
    // 유저 이름 표시 함수
    func setUserName() {
        if self.userLoginType == "Google"{
            guard let userName = UserDefaults.standard.string(forKey: "userGoogleName") else {
                return
            }
            self.nameTextField.text = userName
        } else {
            guard let userName = UserDefaults.standard.string(forKey: "userGuestName") else {
                return
            }
            self.nameTextField.text = userName
        }
    }
    
    // 유저 사진 표시 함수
    func setUserImage() {
        if self.userLoginType == "Google"{
            guard let userImage = UserDefaults.standard.data(forKey: "userGoogleImage") else {
                return
            }
            self.userImageView.image = UIImage(data: userImage)
        } else {
            guard let userImage = UserDefaults.standard.data(forKey: "userGuestImage") else {
                return
            }
            self.userImageView.image = UIImage(data: userImage)
        }
    }
    
    // 변경사항 적용 함수
    func applyEditChanges() {
        if self.userLoginType == "Google" {
            if let email = self.emailTextField.text{
                UserDefaults.standard.set(email, forKey: "userGoogleEmail")
            }
            
            if let name = self.nameTextField.text{
                UserDefaults.standard.set(name, forKey: "userGoogleName")
            }
            
            if let imageData = self.userImageView.image!.pngData() {
                UserDefaults.standard.set(imageData, forKey: "userGoogleImage")
            }
        } else {
            if let email = self.emailTextField.text{
                UserDefaults.standard.set(email, forKey: "userGuestEmail")
            }
            
            if let name = self.nameTextField.text{
                UserDefaults.standard.set(name, forKey: "userGuestName")
            }
            
            if let imageData = self.userImageView.image!.pngData() {
                UserDefaults.standard.set(imageData, forKey: "userGuestImage")
            }
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
