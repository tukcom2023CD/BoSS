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
     
    
    @IBOutlet weak var viewTitleLabel: UILabel! // 타이틀 라벨
    @IBOutlet weak var selectImageButton: UIButton! // 이미지 선택 버튼
    @IBOutlet weak var userImageView: UIImageView! // 유저 이미지 뷰
    @IBOutlet weak var setDefaultImageButton: UIButton! // 기본 이미지 설정 버튼
    
    @IBOutlet weak var userDateSTackView: UIStackView! // 유저 정보 스택 뷰
    @IBOutlet weak var emailTextField: UITextField! // 이메일 텍스트 필드
    @IBOutlet weak var nameTextField: UITextField! // 이름 텍스트 필드
    
    @IBOutlet weak var buttonStackView: UIStackView! // 버튼 스택 뷰
    @IBOutlet weak var cancelButton: UIButton! // 취소 버튼
    @IBOutlet weak var applyButton: UIButton! // 적용 버튼
    
    // 사용자 로그인 종류 구분
    var userLoginType : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI() // UI설정
        
        // 델리게이트 설정
        emailTextField.delegate = self
        nameTextField.delegate = self
        
        // 이메일 수정 못하도록 설정
        emailTextField.isEnabled = false // 이메일 수정 못하도록 설정
        
        // 로그인 타입 확인
        self.userLoginType = checkLoginType()
        
        // 유저 정보 설정
        setUserEmail()
        setUserName()
        setUserImage()
    }
    
    // UI 설정 함수
    func setUI() {
        // 화면 사이즈 값 저장
        let screenWidthSize = UIScreen.main.bounds.size.width
        let screenHeightSize = UIScreen.main.bounds.size.height
        
        // 프로필 편집 타이틀 UI 코드 설정
        viewTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            // 상단으로 부터 떨어진 거리 설정
            viewTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeightSize * 0.1),
            // X축 중심에 맞춤
            viewTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
                
        // 이미지 뷰 UI 코드 설정
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            // 상단으로 부터 떨어진 거리 설정
            userImageView.topAnchor.constraint(equalTo: viewTitleLabel.bottomAnchor, constant: screenHeightSize * 0.05),
            // X축 중심에 맞춤
            userImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // 사이즈 설정
            userImageView.widthAnchor.constraint(equalToConstant: screenWidthSize * 0.4),
            userImageView.heightAnchor.constraint(equalToConstant: screenWidthSize * 0.4),
        ])
        self.userImageView.layer.cornerRadius = screenWidthSize * 0.2
        self.userImageView.contentMode = .scaleAspectFill
        
        // 이미지 선택 버튼 UI 코드 설정
        selectImageButton.translatesAutoresizingMaskIntoConstraints = false
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            // 상단으로 부터 떨어진 거리 설정
            selectImageButton.topAnchor.constraint(equalTo: userImageView.topAnchor, constant: screenWidthSize * 0.06),
            // 상단으로 부터 떨어진 거리 설정
            selectImageButton.trailingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: screenWidthSize * 0.06),
            // 사이즈 설정
            selectImageButton.widthAnchor.constraint(equalToConstant: screenWidthSize * 0.12),
            selectImageButton.heightAnchor.constraint(equalToConstant: screenWidthSize * 0.12),
        ])
        self.selectImageButton.layer.cornerRadius = screenWidthSize * 0.06
        
        // 기본 이미지 선택 버튼 UI 코드 설정
        setDefaultImageButton.translatesAutoresizingMaskIntoConstraints = false
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            // 상단으로 부터 떨어진 거리 설정
            setDefaultImageButton.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: screenWidthSize * 0.03),
            // X축 중심에 맞춤
            setDefaultImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // 사이즈 설정
            setDefaultImageButton.widthAnchor.constraint(equalToConstant: screenWidthSize * 0.3),
            // 사이즈 설정
            setDefaultImageButton.heightAnchor.constraint(equalToConstant: screenWidthSize * 0.075),
        ])
        self.setDefaultImageButton.layer.cornerRadius = screenWidthSize * 0.03
        
        // 유저 정보 스택 뷰 UI 코드 설정
        userDateSTackView.translatesAutoresizingMaskIntoConstraints = false
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            // 상단으로 부터 떨어진 거리 설정
            userDateSTackView.topAnchor.constraint(equalTo: setDefaultImageButton.bottomAnchor, constant: screenWidthSize * 0.15),
            // X축 중심에 맞춤
            userDateSTackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // 사이즈 설정
        ])
        
        // 텍스트 필드 (이메일) UI 코드 설정
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            // 사이즈 설정
            emailTextField.widthAnchor.constraint(equalToConstant: screenWidthSize * 0.75),
            emailTextField.heightAnchor.constraint(equalToConstant: screenWidthSize * 0.115)
        ])
        
        // 텍스트 필드 UI (이름) 코드 설정
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            // 사이즈 설정
            nameTextField.widthAnchor.constraint(equalToConstant: screenWidthSize * 0.75),
            nameTextField.heightAnchor.constraint(equalToConstant: screenWidthSize * 0.115)
        ])
    
        // 버튼 스택 뷰 UI 코드 설정
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            // 상단으로 부터 떨어진 거리 설정
            buttonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: screenWidthSize * -0.25),
            // X축 중심에 맞춤
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // 사이즈 설정
        ])
        
        // 취소 버튼 UI 코드 설정
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            cancelButton.widthAnchor.constraint(equalToConstant: screenWidthSize * 0.31),
            cancelButton.heightAnchor.constraint(equalToConstant: screenWidthSize * 0.124)
        ])
        self.cancelButton.layer.cornerRadius = screenWidthSize * 0.03
        
        // 선택 버튼 UI 코드 설정
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            applyButton.widthAnchor.constraint(equalToConstant: screenWidthSize * 0.31),
            applyButton.heightAnchor.constraint(equalToConstant: screenWidthSize * 0.124)
        ])
        self.applyButton.layer.cornerRadius = screenWidthSize * 0.03
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
