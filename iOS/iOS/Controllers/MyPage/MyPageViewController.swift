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

// 내 정보 (마이페이지) 화면
class MyPageViewController: UIViewController {
    
    @IBOutlet weak var userDataView: UIView! // 유저 정보를 포함하는 뷰
    @IBOutlet weak var userImage: UIImageView! // 유저 이미지
    @IBOutlet weak var userInfoStackView: UIStackView! // 유저 정보 스택 뷰
    @IBOutlet weak var userName: UILabel! // 유저 이름
    @IBOutlet weak var userEmail: UILabel! // 유저 이메일

    @IBOutlet weak var userDataStackView: UIStackView! // 여행 정보 스택 뷰
    
    @IBOutlet weak var userScheduleView: UIView! // 유저 스케줄 표시 뷰
    @IBOutlet weak var userScheduleStackView: UIStackView! // 유저 스케줄 스택 뷰
    @IBOutlet weak var userScheduleLabel: UILabel!  // 유저 스케줄 라벨
    
    @IBOutlet weak var userSpendingView: UIView! // 유저 지출 표시 뷰
    @IBOutlet weak var userSpendingStackView: UIStackView! // 유지 지출 스택 뷰
    @IBOutlet weak var userSpendingLabel: UILabel! // 유저 지출 라벨

    @IBOutlet weak var settingButton: UIButton! // 설정 버튼
    @IBOutlet weak var menuTableView: UITableView! // 메뉴 테이블 뷰
    
    // 사용자 로그인 종류 구분
    var userLoginType : String?
    
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
        
        // 로그인 타입 확인
        self.userLoginType = checkLoginType()
        
        // 프로필 수정 후 작업
        NotificationCenter.default.addObserver(self, selector: #selector(setUserProfile), name: NSNotification.Name("ProfileChanged"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        requestScheduleData() // 일정 데이터 불러오기
        requestSpendingData() // 총지출  불러오기
    }
    
    // UI 설정 함수
    func setUpUI() {
        // 화면 사이즈 값 저장
        let screenWidthSize = UIScreen.main.bounds.size.width
        let screenHeightSize = UIScreen.main.bounds.size.height
        
        // 유저 이미지뷰 UI 코드 설정
        userImage.translatesAutoresizingMaskIntoConstraints = false
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            // 상단으로 부터 떨어진 거리 설정
            userImage.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeightSize / 8),
            // X축 중심에 맞춤
            userImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // 가로세로 크기 설정, 화면 너비의 40%
            userImage.widthAnchor.constraint(equalToConstant: screenWidthSize * 0.4),
            userImage.heightAnchor.constraint(equalToConstant: screenWidthSize * 0.4),
        ])
        // 모서리 값 설정
        userImage.layer.cornerRadius = screenWidthSize * 0.125
        // 비율에 맞춰 꽉 채움
        userImage.contentMode = .scaleAspectFill
                
        // 유저 정보 표시 뷰 UI 코드 설정
        userDataView.translatesAutoresizingMaskIntoConstraints = false
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            // 떨어진 거리 설정, 이미지 크기의 절반 = 화면 너비의 20%
            userDataView.topAnchor.constraint(equalTo: userImage.topAnchor, constant: (screenWidthSize * 0.2)),
            // X축 중심에 맞춤
            userDataView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // 가로 크기 설정, 화면 너비의 80%
            userDataView.widthAnchor.constraint(equalToConstant: (screenWidthSize * 0.8)),
            // 세로 크기 설정, 가로 크기의 절반 = 화면 너비의 40%
            userDataView.heightAnchor.constraint(equalToConstant: (screenWidthSize * 0.4)),
        ])
        // 모서리 값 설정, 가로 크기의 5%
        userDataView.layer.cornerRadius = (screenWidthSize * 0.04)
        
        // 유저 정보 스택 뷰 UI 코드 설정
        userInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            // 유저 정보 표시 뷰 하단으로 부터 떨어진 거리, (이미지 크기 절반 - 스택 사이즈) / 2
            userInfoStackView.bottomAnchor.constraint(equalTo: userDataView.bottomAnchor, constant: -((screenWidthSize * 0.2)-47) / 2),
            // X축 중심에 맞춤
            userInfoStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        // 여행 정보 스택 뷰 UI 코드 설정
        userDataStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // 위치 설정
            userDataStackView.topAnchor.constraint(equalTo: userDataView.bottomAnchor, constant: 10),
            // X축 중심에 맞춤
            userDataStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        // 유저 일정 표시 뷰 UI 코드 설정
        userScheduleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // 너비 크기 설정, ((화면 너비 * 0.8) - 10) / 2
            userScheduleView.widthAnchor.constraint(equalToConstant: ((screenWidthSize * 0.8) - 10) / 2.0),
            // 높이 크기 설정, 화면 너비의 25%
            userScheduleView.heightAnchor.constraint(equalToConstant: screenWidthSize * 0.25)
        ])
        // 모서리 값 설정, 가로 크기의 10%
        userScheduleView.layer.cornerRadius = ((screenWidthSize * 0.8) - 10) / 2.0 * 0.1
        
        // 유저 일정 표시 스택 뷰 UI 코드 설정
        userScheduleStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // 가로 위치 설정
            userScheduleStackView.centerXAnchor.constraint(equalTo: userScheduleView.centerXAnchor),
            // 세로 위치 설정
            userScheduleStackView.centerYAnchor.constraint(equalTo: userScheduleView.centerYAnchor),
        ])
        
        // 유저 지출내역 표시 뷰 UI 코드 설정
        userSpendingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // 너비 크기 설정, ((화면 너비 * 0.8) - 10) / 2
            userSpendingView.widthAnchor.constraint(equalToConstant: ((screenWidthSize * 0.8) - 10) / 2.0),
            // 높이 크기 설정, 화면 너비의 30%
            userSpendingView.heightAnchor.constraint(equalToConstant: screenWidthSize * 0.25)
        ])
        // 모서리 값 설정, 가로 크기의 10%
        userSpendingView.layer.cornerRadius = ((screenWidthSize * 0.8) - 10) / 2.0 * 0.1
        
        // 유저 지출 표시 스택 뷰 UI 코드 설정
        userSpendingStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // 가로 위치 설정
            userSpendingStackView.centerXAnchor.constraint(equalTo: userSpendingView.centerXAnchor),
            // 세로 위치 설정
            userSpendingStackView.centerYAnchor.constraint(equalTo: userSpendingView.centerYAnchor),
        ])
        
        // 메뉴 테이블 뷰 UI 코드 설정
        menuTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        // 위치 설정
        menuTableView.topAnchor.constraint(equalTo: userDataStackView.bottomAnchor, constant: 30),
        
        menuTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        
        menuTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
        
        menuTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
        ])
    }
    
    // 버튼 설정 함수
    func settingButtonSetUp() {
        // 회원탈퇴 메뉴
        let menuList : [UIAction] = [
            UIAction(title: "프로필 편집", image: UIImage(systemName: "pencil.line"), handler: { _ in self.moveEditProfileScreen()}),
            UIAction(title: "로그아웃", image: UIImage(named: "logout.png"), handler: { _ in self.logOutAlert() }),
            UIAction(title: "회원탈퇴", image: UIImage(named: "cancel.png"), attributes: .destructive, handler: { _ in self.withdrawMembership() })
        ]
        settingButton.menu = UIMenu(title : "설정", identifier: nil, options: .displayInline, children: menuList)
        settingButton.showsMenuAsPrimaryAction = true
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
    
    // 현재 구글 로그인한 사용자의 이메일 주소 가져오기
    func getGoogleUserEmail() -> String {
        if let user = GIDSignIn.sharedInstance.currentUser {
            if let email = user.profile?.email {
                return (email)
            } else {
                return ("Unknown")
            }
        } else {
            return ("@Guest")
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
        if self.userLoginType == "Google" {
            // UserDefaults로 부터 이메일을 불러오고 만약 없다면 해당 이메일을 구글 로그인 정보로 부터 불러옴
            guard let userEmail = UserDefaults.standard.string(forKey: "userGoogleEmail") else {
                let userEmail = getGoogleUserEmail()
                UserDefaults.standard.set(userEmail, forKey: "userGoogleEmail")
                self.userEmail.text = userEmail
                return
            }
            self.userEmail.text = userEmail
        } else {
            // UserDefaults로 부터 이메일을 불러오고 만약 없다면 해당 이메일을 구글 로그인 정보로 부터 불러옴
            guard let userEmail = UserDefaults.standard.string(forKey: "userGuestEmail") else {
                let userEmail = getGoogleUserEmail()
                UserDefaults.standard.set(userEmail, forKey: "userGuestEmail")
                self.userEmail.text = userEmail
                return
            }
            self.userEmail.text = userEmail
        }
    }
    
    // 유저 이름 표시 함수
    func setUserName() {
        if self.userLoginType == "Google" {
            // UserDefaults로 부터 이름을 불러오고 만약 없다면 해당 이름을 구글 로그인 정보로 부터 불러옴
            guard let userName = UserDefaults.standard.string(forKey: "userGoogleName") else {
                let userName = getGoogleUserName()
                UserDefaults.standard.set(userName, forKey: "userGoogleName")
                self.userName.text = userName
                return
            }
            self.userName.text = userName
        } else {
            // UserDefaults로 부터 이름을 불러오고 만약 없다면 해당 이름을 구글 로그인 정보로 부터 불러옴
            guard let userName = UserDefaults.standard.string(forKey: "userGuestName") else {
                let userName = getGoogleUserName()
                UserDefaults.standard.set(userName, forKey: "userGuestName")
                self.userName.text = userName
                return
            }
            self.userName.text = userName
        }
    }
    
    // 유저 사진 표시 함수
    func setUserImage() {
        if self.userLoginType == "Google"{
            guard let userImage = UserDefaults.standard.data(forKey: "userGoogleImage") else {
                self.userImage.image = UIImage(named: "user")
                // 이미지를 Data로 변환하여 UserDefaults에 저장
                if let imageData = self.userImage.image!.pngData() {
                    UserDefaults.standard.set(imageData, forKey: "userGoogleImage")
                }
                return
            }
            self.userImage.image = UIImage(data: userImage)
        } else {
            guard let userImage = UserDefaults.standard.data(forKey: "userGuestImage") else {
                self.userImage.image = UIImage(named: "user")
                // 이미지를 Data로 변환하여 UserDefaults에 저장
                if let imageData = self.userImage.image!.pngData() {
                    UserDefaults.standard.set(imageData, forKey: "userGuestImage")
                }
                return
            }
            self.userImage.image = UIImage(data: userImage)
        }
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
        var count = 0
        let group = DispatchGroup() // 비동기 함수 그룹
        group.enter()
        ScheduleNetManager.shared.read(uid: user.uid!) { schedules in
            count = schedules.count
            group.leave()
        }
        group.notify(queue: .main) {
            self.userScheduleLabel.text = String(count)
        }
    }

    // 총 지출 내역 불러오기
    func requestSpendingData() {
        var userTotalSpending = 0
        let user = UserDefaults.standard.getLoginUser()!
        let group = DispatchGroup() // 비동기 함수 그룹
        PlaceNetManager.shared.read(uid: user.uid!) { places in
            for place in places {
                group.enter()
                SpendingNetManager.shared.read(pid: place.pid!) { spendings in
                    for spending in spendings {
                        userTotalSpending += Int(spending.price! * spending.quantity!)
                    }
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                self.userSpendingLabel.text = self.numberFormatter(number: userTotalSpending)
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
        
        // 화면 사이즈 값 저장
        let screenWidthSize = UIScreen.main.bounds.size.width
        let screenHeightSize = UIScreen.main.bounds.size.height
        
        // 셀에 대해 제약 조건
        cell.contentView.translatesAutoresizingMaskIntoConstraints = false
        cell.cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cell.arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // cell 높이 설정
            cell.contentView.heightAnchor.constraint(equalToConstant: screenHeightSize * 0.08),
            // cell 너비 설정
            cell.contentView.widthAnchor.constraint(equalToConstant: screenWidthSize),
            
            // 스택뷰를 y축 중심으로 설정
            cell.cellStackView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            // 스택뷰를 왼쪽으로 부터 20 만큼 떨어지도록 설정
            cell.cellStackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
            
            // 이미지 뷰 크기 설정
            cell.arrowImageView.widthAnchor.constraint(equalToConstant: 30),
            cell.arrowImageView.heightAnchor.constraint(equalToConstant: 30),
            // 이미지 뷰를 y축 중심으로 설정
            cell.arrowImageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            // 스택뷰를 오른쪽으로 부터 20 만큼 떨어지도록 설정
            cell.arrowImageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20),
            ])

        cell.arrowImageView.contentMode = .scaleAspectFill
        cell.labelTitle.text = titleArray[indexPath.row]
        cell.labelContent.text = contentArray[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            guard let scheduleVC = self.storyboard?.instantiateViewController(identifier: "scheduleVC") as? MyPageScheduleViewController else {return}
            self.present(scheduleVC, animated: true)
        case 1:
            guard let spendingVC = self.storyboard?.instantiateViewController(identifier: "spendingVC") as? MyPageSpendingViewController else {return}
            spendingVC.modalPresentationStyle = .automatic
            spendingVC.modalTransitionStyle = .coverVertical
            self.present(spendingVC, animated: true)
        default:
            return
        }
    }
}

class CustomTableCell: UITableViewCell {
    @IBOutlet weak var cellStackView: UIStackView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
}

