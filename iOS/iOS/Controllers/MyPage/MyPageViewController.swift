//
//  MyPageViewController.swift
//  iOS
//
//  Created by JunHee on 2023/02/07.
//
import UIKit

class MyPageViewController: UIViewController {
    
    @IBOutlet weak var userDataView: UIView! // 유저 정보를 포함하는 뷰
    @IBOutlet weak var userImage: UIImageView! // 유저 이미지
    @IBOutlet weak var userName: UILabel! // 유저 이름
    @IBOutlet weak var userEmail: UILabel! // 유저 이메일

    @IBOutlet weak var userScheduleView: UIView! // 유저 스케줄 표시 뷰
    @IBOutlet weak var userScheduleLabel: UILabel!  // 유저 스케줄 라벨
    
    @IBOutlet weak var userSpendingView: UIView! // 유저 지출 표시 뷰
    @IBOutlet weak var userSpendingLabel: UILabel! // 유저 지출 라벨

    @IBOutlet weak var settingButton: UIButton! // 설정 버튼
    @IBOutlet weak var menuTableView: UITableView! // 메뉴 테이블 뷰
    
    // 테이블 뷰 표시 정보
    let titleArray = ["여행일정", "지출내역"]
    let contentArray = ["여행 일정을 확인하세요", "여행동안의 지출내역을 확인하세요"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI() // UI 설정
        settingButtonSetUp() // 설정 메뉴 설정
        
        // 그림자 설정
        setShadow(view: userDataView)
        setShadow(view: userScheduleView)
        setShadow(view: userSpendingView)
        
        requestScheduleData() // 일정 데이터 불러오기
        requestSpendingData() // 총지출  불러오기
    }
    
    // UI 설정 함수
    func setUpUI() {
        // 유저 정보 표시 뷰 설정
        userDataView.layer.cornerRadius = 40
        // 유저 이미지 설정
        userImage.image = UIImage(named: "user.png")
        userImage.layer.cornerRadius = 50
        
        // 유저 스케줄 표시 뷰 설정
        userScheduleView.layer.cornerRadius = 25
        // 유저 스케줄 기본값으로 표시
        userScheduleLabel.text = "0"
        
        // 유저 지출 표시 뷰 설정
        userSpendingView.layer.cornerRadius = 25
        // 유저 지출 기본값으로 표시
        userSpendingLabel.text = numberFormatter(number: 0)
    }
    
    // 버튼 설정 함수
    func settingButtonSetUp() {
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
    
    // 금액에 콤마를 포함하여 표기 함수
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number))!
    }

    // 여행 일정 수 불러오기
    func requestScheduleData() {
        let user = UserDefaults.standard.getLoginUser()!
        ScheduleNetManager.shared.read(uid: user.uid!) { schedules in
            DispatchQueue.main.async {
                self.userScheduleLabel.text = String(schedules.count)
            }
        }
    }

    // 총 지출 내역 불러오기
    func requestSpendingData() {
        let user = UserDefaults.standard.getLoginUser()!
        PlaceNetManager.shared.read(uid: user.uid!) { places in
            var userTotalSpending = 0
            for place in places {
                SpendingNetManager.shared.read(pid: place.pid!) { spendings in
                    for spending in spendings {
                        userTotalSpending += Int(spending.price!)
                    }
                    DispatchQueue.main.async {
                        self.userSpendingLabel.text = self.numberFormatter(number: userTotalSpending)
                    }
                }
            }
        }
    }
}

extension MyPageViewController : UITableViewDataSource, UITableViewDelegate {
    
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
        case 0:
            guard let scheduleVC = self.storyboard?.instantiateViewController(identifier: "scheduleVC") as? MyPageScheduleViewController else {return}
            scheduleVC.modalPresentationStyle = .automatic
            scheduleVC.modalTransitionStyle = .coverVertical
            
            self.present(scheduleVC, animated: true)
            // self.performSegue(withIdentifier: "ShowSchedule", sender: nil)
        case 1:
            guard let spendingVC = self.storyboard?.instantiateViewController(identifier: "spendingVC") as? MyPageSpendingViewController else {return}
            spendingVC.modalPresentationStyle = .automatic
            spendingVC.modalTransitionStyle = .coverVertical
            
            self.present(spendingVC, animated: true)
            // self.performSegue(withIdentifier: "ShowSpending", sender: nil)
        default:
            return
        }
    }
}

class CustomTableCell: UITableViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelContent: UILabel!
}

