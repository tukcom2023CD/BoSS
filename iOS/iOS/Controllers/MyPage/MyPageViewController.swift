//
//  MyPageViewController.swift
//  iOS
//
//  Created by JunHee on 2023/02/07.
//
import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

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
        
        setUserProfile() // 프로필 표시
        
        // 그림자 설정
        setShadow(view: userDataView)
        setShadow(view: userScheduleView)
        setShadow(view: userSpendingView)
        
        requestScheduleData() // 일정 데이터 불러오기
        requestSpendingData() // 총지출  불러오기
        
        NotificationCenter.default.addObserver(self, selector: #selector(setUserProfile), name: NSNotification.Name("ProfileChanged"), object: nil)
    }
    
    // UI 설정 함수
    func setUpUI() {
        // 유저 정보 표시 뷰 설정
        userDataView.layer.cornerRadius = 40
        // 유저 이미지 모서리 설정
        userImage.layer.cornerRadius = 75
        userImage.contentMode = .scaleAspectFill
        
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
            UIAction(title: "프로필 편집", image: UIImage(systemName: "pencil.line"), handler: { _ in self.moveEditProfileScreen()}),
            UIAction(title: "로그아웃", image: UIImage(named: "logout.png"), handler: { _ in self.logOutAlert() }),
            UIAction(title: "회원탈퇴", image: UIImage(named: "cancel.png"), attributes: .destructive, handler: { _ in self.withdrawMembership() })
        ]
        settingButton.menu = UIMenu(identifier: nil, options: .displayInline, children: menuList)
        settingButton.showsMenuAsPrimaryAction = true
    }
    
    // 현재 구글 로그인한 사용자의 이메일 주소 가져오기
    func getGoogleUserEmail() -> String {
        if let user = GIDSignIn.sharedInstance.currentUser {
            if let email = user.profile?.email {
                return (email)
            } else {
                return ("Unknown")
            }
        } else {
            return ("Guest")
        }
    }
    
    // 현재 구글 로그인한 사용자의 이름 가져오기
    func getGoogleUserName() -> String {
        if let user = GIDSignIn.sharedInstance.currentUser {
            if let name = user.profile?.name {
                return (name)
            } else {
                return ("Unknown")
            }
        } else {
            return ("Guest")
        }
    }
    
    // 유저 이메일 표시 함수
    func setUserEmail() {
        
        // UserDefaults로 부터 이메일을 불러오고 만약 없다면 해당 이메일을 구글 로그인 정보로 부터 불러옴
        guard let userEmail = UserDefaults.standard.string(forKey: "userEmail") else {
            let userEmail = getGoogleUserEmail()
            UserDefaults.standard.set(userEmail, forKey: "userEmail")
            self.userEmail.text = userEmail
            return
        }
        self.userEmail.text = userEmail
    }
    
    // 유저 이름 표시 함수
    func setUserName() {
        
        // UserDefaults로 부터 이름을 불러오고 만약 없다면 해당 이름을 구글 로그인 정보로 부터 불러옴
        guard let userName = UserDefaults.standard.string(forKey: "userName") else {
            let userName = getGoogleUserName()
            UserDefaults.standard.set(userName, forKey: "userName")
            self.userName.text = userName
            return
        }
        self.userName.text = userName
    }
    
    // 유저 사진 표시 함수
    func setUserImage() {
    
        guard let userImage = UserDefaults.standard.data(forKey: "userImage") else {
            self.userImage.image = UIImage(named: "user")
            // 이미지를 Data로 변환하여 UserDefaults에 저장
            if let imageData = self.userImage.image!.pngData() {
                UserDefaults.standard.set(imageData, forKey: "userImage")
            }
            return
        }
        self.userImage.image = UIImage(data: userImage)
    }
    
    // 유저 프로필 표시 함수
    @objc func setUserProfile() {
        setUserEmail()
        setUserName()
        setUserImage()
    }
    
    // 프로필 편집화면으로 이동하는 함수
    func moveEditProfileScreen() {
        guard let profileEditVC = self.storyboard?.instantiateViewController(identifier: "profileEditVC") as? ProfileEdirViewController else {return}
        profileEditVC.modalPresentationStyle = .fullScreen
        profileEditVC.modalTransitionStyle = .coverVertical
        
        self.present(profileEditVC, animated: true)
    }
    
    // 로그아웃 알림창을 띄우는 함수
    func logOutAlert() {
        // 로그아웃에 대한 알림
        let alertController = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (action) in
            print("취소")
            alertController.dismiss(animated: true, completion: nil)
        }

        let logOutAction = UIAlertAction(title: "로그아웃", style: .destructive) { (action) in
            print("로그아웃")
            alertController.dismiss(animated: true){
                self.signOut()
                self.loginVC()
            }
        }
        alertController.addAction(cancelAction) // 액션 추가
        alertController.addAction(logOutAction) // 액션 추가
        present(alertController, animated: true, completion: nil)
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
    
    // 회원탈퇴 화면으로 이동하는 함수
    func withdrawMembership() {
        guard let withDrawVC = self.storyboard?.instantiateViewController(identifier: "withDrawVC") as? WithDrawMembershipViewController else {return}
        withDrawVC.modalPresentationStyle = .fullScreen
        withDrawVC.modalTransitionStyle = .coverVertical
        
        self.present(withDrawVC, animated: true)
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
            scheduleVC.modalPresentationStyle = .fullScreen
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

