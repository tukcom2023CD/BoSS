//
//  WithDrawMembershipViewController.swift
//  iOS
//
//  Created by JunHee on 2023/04/07.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

// 회원 탈퇴 화면
class WithDrawMembershipViewController : UIViewController {
    
    @IBOutlet weak var viewTitleLabel: UILabel! // 타이틀 라벨
    @IBOutlet weak var warningLabel: UILabel! // 경고 라벨
    @IBOutlet weak var warningStackView: UIStackView! // 경고
    @IBOutlet weak var buttonStackView: UIStackView! // 버튼 스택 뷰
    @IBOutlet weak var cancelButton: UIButton! // 취소 버튼
    @IBOutlet weak var withDrawButton: UIButton! // 탈퇴 버튼
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI() // UI 설정
    }
    
    // UI 설정
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
        
        
        // 경고문 라벨 UI 코드 설정
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            // 상단으로 부터 떨어진 거리 설정
            warningLabel.topAnchor.constraint(equalTo: viewTitleLabel.bottomAnchor, constant: screenHeightSize * 0.05),
            // X축 중심에 맞춤
            warningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        // 경고문 스택 뷰 UI 코드 설정
        warningStackView.translatesAutoresizingMaskIntoConstraints = false
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            // X축 중심에 맞춤
            warningStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // Y축 중심에 맞춤
            warningStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
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
        withDrawButton.translatesAutoresizingMaskIntoConstraints = false
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            withDrawButton.widthAnchor.constraint(equalToConstant: screenWidthSize * 0.3),
            withDrawButton.heightAnchor.constraint(equalToConstant: screenWidthSize * 0.1)
        ])
        self.withDrawButton.layer.cornerRadius = screenWidthSize * 0.03
    }
    
    // DB에 저장되어있는 데이터 삭제
    func deleteUserDataFromDB() {
        print("DB 데이터 삭제")
        let user = UserDefaults.standard.getLoginUser()!
        UserNetManager.shared.deleteUserData(uid: user.uid!) {
            print("DB 유저 데이터 모두 삭제")
        }
    }
    
    // 로그아웃
    func signOut() {
        print("로그아웃")
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            // 로그아웃 성공적으로 수행
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    // 초기화면(로그인) 화면으로 이동
    func loginVC() {
        print("로그인 화면 열기")
        guard let LoginVC = self.storyboard?.instantiateViewController(identifier: "LoginVC") as? LoginViewController else {return}
        LoginVC.modalPresentationStyle = .fullScreen
        LoginVC.modalTransitionStyle = .coverVertical
        UIApplication.shared.keyWindow?.rootViewController = LoginVC
    }

    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func withDrawButtonTapped(_ sender: UIButton) {
        
        // 현재 화면 닫기
        dismiss(animated: true) {
            self.signOut()
            self.loginVC()
            self.deleteUserDataFromDB () // DB에 저장되어있는 유저 데이터 삭제
        }
    }
}
