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
    
    @IBOutlet weak var emailStackView: UIStackView! // 이메일 스택뷰
    @IBOutlet weak var emailTextField: UITextField! // 이메일 텍스트 필드
    @IBOutlet weak var nameStackView: UIStackView! // 이름 스택 뷰
    @IBOutlet weak var nameTextField: UITextField! // 이름 텍스트 필드
    
    @IBOutlet weak var buttonStackView: UIStackView! // 버튼 스택 뷰
    @IBOutlet weak var cancelButton: UIButton! // 취소 버튼
    @IBOutlet weak var applyButton: UIButton! // 적용 버튼
    
    var activeTextField: UITextField? // 현재 수정중인 텍스트필드
    var difference : CGFloat? // 텍스트필드 하단 위치와 키보드 상단위치 차이
    var changeView : Bool = false // 뷰 변경 여부
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI() // UI설정
        
        // 델리게이트 설정
        emailTextField.delegate = self
        nameTextField.delegate = self
        
        // 이메일 수정 못하도록 설정
        emailTextField.isEnabled = false // 이메일 수정 못하도록 설정
        
        // 유저 정보 설정
        setUserProfile()
        
        // 적용버튼 비활성화
        applyButton.isEnabled = false
        applyButton.backgroundColor = UIColor.systemGray
        
        // Notification 등록
        
        // 키보드 활성화 직전
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // 키보드 비활성화 직전
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
            emailTextField.heightAnchor.constraint(equalToConstant: screenWidthSize * 0.125)
        ])
        
        // 텍스트 필드 UI (이름) 코드 설정
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            // 사이즈 설정
            nameTextField.widthAnchor.constraint(equalToConstant: screenWidthSize * 0.75),
            nameTextField.heightAnchor.constraint(equalToConstant: screenWidthSize * 0.125)
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
            cancelButton.widthAnchor.constraint(equalToConstant: screenWidthSize * 0.3),
            cancelButton.heightAnchor.constraint(equalToConstant: screenWidthSize * 0.1)
        ])
        self.cancelButton.layer.cornerRadius = screenWidthSize * 0.03
        
        // 선택 버튼 UI 코드 설정
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            applyButton.widthAnchor.constraint(equalToConstant: screenWidthSize * 0.3),
            applyButton.heightAnchor.constraint(equalToConstant: screenWidthSize * 0.1)
        ])
        self.applyButton.layer.cornerRadius = screenWidthSize * 0.03
        
        view.layoutIfNeeded() // 레이아웃 업데이트 (frmae값 및 bounds값 업데이트)
    }
    
    // 유저 프로필 표시 함수
    @objc func setUserProfile() {
        
        var userData : User!
        let uid = UserDefaults.standard.getLoginUser()!.uid // uid 불러오기
        let group = DispatchGroup() // 비동기 함수 그룹 생성
        group.enter()
        UserNetManager.shared.read(uid: uid!) { users in
            for user in users {
                userData = user
            }
            group.leave()
        }
        group.notify(queue: .main) {
            
            self.nameTextField.text = userData.name! // 이름 설정
            self.emailTextField.text = userData.email! // 이메일 설정
            
            // url 가져옴
            if let image_url = userData.image_url {
                
                // 받아온 url을 통해 캐시키 생성
                let cacheKey = NSString(string: image_url)
                
                // 캐시 이미지가 존재한다면 해당 이미지로 설정
                if let cachedImage = AlbumImageCacheManager.shared.object(forKey: cacheKey) {
                    self.userImageView.image = cachedImage
                }
                
                // 캐시 이미지가 존재하지 않는다면
                else {
                    if let url = URL(string: image_url) { // url 생성
                        if let data = try? Data(contentsOf: url) { // 데이터 다운로드
                            
                            // 이미지 설정
                            self.userImageView.image = UIImage(data: data)
                            
                            // 키, 밸류 값으로 캐시값 저장
                            AlbumImageCacheManager.shared.setObject(UIImage(data: data)!, forKey: cacheKey)
                        }
                    }
                }
            }
            else {
                self.userImageView.image = UIImage(named: "user.png") // 사진이 없으면 기본이미지로 설정
            }
            
            // 버튼 활성화
            self.applyButton.isEnabled = true
            self.applyButton.backgroundColor = UIColor.systemGreen
        }
    }
    
    // 변경사항 적용 함수
    func applyEditChanges() {
        
        let uid = UserDefaults.standard.getLoginUser()!.uid // uid 불러오기
        let user = User(uid: uid, email: emailTextField.text, name: nameTextField.text) // 구조체 생성
        
        let group = DispatchGroup() // 비동기 함수 그룹 생성
        group.enter()
        UserNetManager.shared.update(user: user) { // 이름, 이메일 데이터 업데이트
            group.leave()
        }
        
        group.enter()
        PhotoNetManager.shared.create(uid: uid!, image: userImageView.image!) {
            group.leave()
        }
        
        group.notify(queue: .main) {
            print("프로필 업데이트 완료")
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
    
    // 키보드 리턴키가 눌렸을 때
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // 현재 편집되고 있는 텍스트필드 해제
        return true
    }
    
    // UITextFieldDelegate 메소드
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    // 키보드가 나타나기 직전에 실행되는 함수
    @objc func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                
                let convertedPoint = activeTextField!.convert(CGPoint.zero, to: self.view)  // 좌표 알아내기
                let bottom_y_coor = activeTextField!.frame.size.height + convertedPoint.y  // 알아낸 좌표에 텍스트 필드 높이를 더해 bottom y좌표 구함
                
                // 키보드 상단까지 거리
                let keyboardTop = self.view.frame.size.height - keyboardSize.height
                
                // 차이 구함
                self.difference = bottom_y_coor - keyboardTop
                
                // 차이가 0보다 큼 = 텍스트필드가 키보드 밑에 있음
                if difference! > 0 {
                    self.view.frame.origin.y -= (difference! + 10) // 차이 만큼 view를 위로 올림, 10은 여유값
                    print("뷰 올림!")
                }
            }
        }
    }
    
    // 키보드가 사라지기 직전에 실행되는 함수
    @objc func keyboardWillHide(notification: NSNotification) {
        if difference! > 0 {
            self.view.frame.origin.y += (self.difference! + 10) // 차이 만큼 view를 아래로 내림, 10은 여유값
            print("뷰 내림!")
        }
    }
}
