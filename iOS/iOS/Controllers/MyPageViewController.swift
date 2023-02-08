//
//  MyPageViewController.swift
//  iOS
//
//  Created by JunHee on 2023/02/07.
//
import UIKit

class MyPageViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userDataView: UIView!
    @IBOutlet weak var userScheduleView: UIView!
    @IBOutlet weak var userScheduleLabel: UILabel!
    @IBOutlet weak var userSpendingView: UIView!
    @IBOutlet weak var userSpendingLabel: UILabel!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var userTableView: UITableView!
    
    // 사용자 일정 수
    var userSchedule : Int = 5
    // 사용자 지출 금액
    var userSpending : Int = 1285000
    
    // 테이블 정보
    let titleArray = ["진행중인 여행", "지출내역"]
    let contentArray = ["현재 진행중인 여행 일정을 확인하세요", "여행동안의 지출내역을 확인하세요"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UI 설정
        serUI()
        // 설정 메뉴 설정
        setupMenuButton()
    }
    
    // 테이블 설정 함수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomCell else {
             return UITableViewCell()
         }
         cell.labelTitle.text = titleArray[indexPath.row]
         cell.labelContent.text = contentArray[indexPath.row]
         return cell
    }
            
    func serUI() {
        // 배경 지정
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "myPageBackground.png")!)
        // 이미지 설정
        userImage.image = UIImage(named: "user.png")
        userImage.layer.cornerRadius = 50
        // 유저 정보 표시 뷰 설정
        userDataView.layer.cornerRadius = 40
        // 유저 여행 일정 표시 뷰 설정
        userScheduleView.layer.cornerRadius = 25
        // 유저 지출금액 표시 뷰 설정
        userSpendingView.layer.cornerRadius = 25
        // 유저 지출금액 표시
        userScheduleLabel.text = String(userSchedule)
        // 유저 지출금액 표시
        userSpendingLabel.text = numberFormatter(number: userSpending)
//        //테이블 뷰 설정
//        userTableView.layer.cornerRadius = 40
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
        let menuList : [UIAction] = [
            UIAction(title: "로그아웃", image: UIImage(named: "logout.png"), handler: { _ in print("로그아웃") }),
            UIAction(title: "회원탈퇴", image: UIImage(named: "cancel.png"), attributes: .destructive, handler: { _ in print("회원탈퇴") })
        ]
        settingButton.menu = UIMenu(identifier: nil, options: .displayInline, children: menuList)
        settingButton.showsMenuAsPrimaryAction = true
    }
}

class CustomCell: UITableViewCell {
     @IBOutlet weak var labelTitle: UILabel!
     @IBOutlet weak var labelContent: UILabel!
}



