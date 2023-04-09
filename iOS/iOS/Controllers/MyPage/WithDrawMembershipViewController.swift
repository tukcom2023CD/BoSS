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

class WithDrawMembershipViewController : UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton! // 취소 버튼
    @IBOutlet weak var withDrawButton: UIButton! // 탈퇴 버튼
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI() // UI 설정
    }
    
    // UI 설정
    func setUI() {
        self.cancelButton.layer.cornerRadius = 20
        self.withDrawButton.layer.cornerRadius = 20
    }
    
    // 유저의 로컬 데이터 삭제
    func deleteUserDataFromLocal() {
        print("로컬 데이터 삭제")
        // 로컬에 저장되어 있는 유저 데이터 삭제
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "userImage")
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
        deleteUserDataFromLocal() // 유저의 로컬 데이터 삭제
        deleteUserDataFromDB () // DB에 저장되어있는 유저 데이터 삭제
        
        // 현재 화면 닫기
        dismiss(animated: true) {
            self.signOut()
            self.loginVC()
        }
    }
}
