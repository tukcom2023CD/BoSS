//
//  MyPageViewController.swift
//  iOS
//
//  Created by JunHee on 2023/02/07.
//
import UIKit

class MyPageViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userDataView: UIView!
    @IBOutlet weak var userScheduleView: UIView!
    @IBOutlet weak var userSpendingView: UIView!
    @IBOutlet weak var userSpendingLabel: UILabel!
    @IBOutlet weak var pullDownButton: UIButton!
    
    // 사용자 지출 금액
    var userSpending : Int = 1285000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UI 설정
        serUI()
        setupMenuButton()
    }
    
    func serUI() {
        
        // 배경 지정
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "myPageBackground.png")!)
        
        // 유저 정보 표시 뷰 설정
        userDataView.layer.cornerRadius = 50
        
        // 유저 여행 일정 표시 뷰 설정
        userScheduleView.layer.cornerRadius = 30
        
        // 유저 지출금액 표시 뷰 설정
        userSpendingView.layer.cornerRadius = 30
        
        // 유저 지출금액 표시
        userSpendingLabel.text = numberFormatter(number: userSpending)
        
        // 이미지 설정
        userImage.image = UIImage(named: "user.png")
        userImage.layer.cornerRadius = 50
    }
    
    // 금액 콤마 표기 함수
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: number))!
    }
    
    // 버튼 설정 함수
    func setupMenuButton() {
        // 회원탈퇴 메뉴
        let MembershipWithdrawal = UIAction(title: "회원탈퇴", image: UIImage(named: "cancel.png"), handler: { _ in print("회원탈퇴") })
                pullDownButton.menu = UIMenu(title: "설정",
                                     identifier: nil,
                                     options: .displayInline,
                                     children: [MembershipWithdrawal])
    }
}

