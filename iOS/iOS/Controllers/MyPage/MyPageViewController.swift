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
    var userSchedule : Int = 4
    // 사용자 지출 금액
    var userSpending : Int = 1285000
    
    // 테이블 정보
    let titleArray = ["여행일정", "지출내역"]
    let contentArray = ["나의 여행 일정을 확인하세요", "여행동안의 지출내역을 확인하세요"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UI 설정
        serUI()
        // 설정 메뉴 설정
        setupMenuButton()
        // 그림자 설정
        setShadow(view: userDataView)
        setShadow(view: userScheduleView)
        setShadow(view: userSpendingView)
    }
    
    // 테이블 설정 함수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableCell", for: indexPath) as? CustomTableCell else {
             return UITableViewCell()
         }
         cell.labelTitle.text = titleArray[indexPath.row]
         cell.labelContent.text = contentArray[indexPath.row]
         cell.selectionStyle = .none
        
         return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: self.performSegue(withIdentifier: "ShowSchedule", sender: nil)
        case 1: self.performSegue(withIdentifier: "ShowSpending", sender: nil)
        default:
            return
        }
    }
            
    func serUI() {
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
    
    // 그림자 설정 함수
    func setShadow(view : UIView) {
        view.layer.shadowColor = UIColor.black.cgColor // 그림자 색깔
        view.layer.masksToBounds = false // 그림자 잘림 방지
        view.layer.shadowOffset = CGSize(width: 0, height: 4) // 그림자 위치
        view.layer.shadowRadius = 5 // 그림자 반경
        view.layer.shadowOpacity = 0.3 // alpha 값
    }
}

class CustomTableCell: UITableViewCell {
     @IBOutlet weak var labelTitle: UILabel!
     @IBOutlet weak var labelContent: UILabel!
}
