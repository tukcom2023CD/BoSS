//
//  MyPageScheduleViewController.swift
//  iOS
//
//  Created by JunHee on 2023/02/09.
//

import UIKit

// 사용자 여행 일정 화면
class MyPageScheduleViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var hasSchedule : Bool = false // 스케줄 존재 여부
    var currentCellSid : Int? // 현재 셀 sid
    var scheduleCount = 0 // 스케줄 개수
    var scheduleArray : [Schedule] = [] // 스케줄 배열
    var scheduleStausArray : [String] = [] // 스케줄 상태 배열
    let exampleScheduleImage = #imageLiteral(resourceName: "여행사진 1") // 예시 스케줄 사진
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 화면 사이즈 값 저장
        let screenWidthSize = UIScreen.main.bounds.size.width
        let screenHeightSize = UIScreen.main.bounds.size.height
        
        // 컬렉션 뷰 제약 조건 설정
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        // 시트 설정
        if #available(iOS 15.0, *) {
            if let sheetPresentationController = sheetPresentationController {
                sheetPresentationController.detents = [.medium()]
                sheetPresentationController.preferredCornerRadius = 20
                sheetPresentationController.prefersGrabberVisible = true
            }
        } else {
            // Fallback on earlier versions
        }
        
        // 초기 간격 설정
        let insets = (screenWidthSize * 0.05)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: insets, bottom: 0, right: 0)
        
        // 컬렉션 뷰 스크롤 방향 설정
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        // 스케줄 업데이트 신호를 받아 컬렉션 뷰 셀 리로드
        NotificationCenter.default.addObserver(self, selector: #selector(requestScheduleData), name: NSNotification.Name("ScheduleUpdated"), object: nil)
        
        // 여행 일정 가져오기
        requestScheduleData()
    }
    
    // 여행 일정 불러오기
    @objc func requestScheduleData() {
        self.scheduleStausArray = []
        let user = UserDefaults.standard.getLoginUser()!
        let group = DispatchGroup() // 비동기 함수 그룹 생성
        group.enter()
        ScheduleNetManager.shared.read(uid: user.uid!) { schedules in
            self.scheduleCount = schedules.count // 스케줄 개수 저장
            if schedules.count > 0 { // 일정 개수가 0보다 크면
                self.hasSchedule = true // 일정 존재
            }
            self.scheduleArray = schedules // 스케줄 저장
            self.discriminationScheduleData(schedules: self.scheduleArray) // 일정 상태 구분
            group.leave()
        }
        group.notify(queue: .main) {
            self.collectionView.reloadData()
        }
    }
    
    // DB 일정 삭제 함수
    func deleteScheduleFromDB() {
        ScheduleNetManager.shared.delete(sid : self.currentCellSid!) {
        }
    }
    
    func reloadAfterDeleteSchedule() {
        self.scheduleCount -= 1
        if self.scheduleCount == 0 {
            self.hasSchedule = false
        }
        let index = self.scheduleArray.firstIndex(where: {$0.sid == currentCellSid})
        self.scheduleArray.remove(at: index!)
        self.scheduleStausArray.remove(at: index!)
        self.collectionView.reloadData()
    }
    
    // 스케줄 상태(완료, 진행중, 예정) 구분
    func discriminationScheduleData(schedules: [Schedule]) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let currentDate = formatter.string(from: Date())
        for schedule in schedules {
            if currentDate > schedule.stop! {
                self.scheduleStausArray.append("완료")
            } else if (currentDate >= schedule.start! && currentDate <= schedule.stop!) {
                self.scheduleStausArray.append("진행중")
            } else {
                self.scheduleStausArray.append("예정")
            }
        }
    }

    func setColor(text : String) -> UIColor {
        if text == "완료" {
            return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        } else if text == "진행중" {
            return #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        } else {
            return #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }
    }
    
    // 금액에 콤마를 포함하여 표기 함수
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number))!
    }
    
    // 총 지출 내역 불러오기
    func requestSpendingData(sid : Int, spendingLabel : UILabel) {
        var userTotalSpending = 0
        // let user = UserDefaults.standard.getLoginUser()!
        let group = DispatchGroup() // 비동기 함수 그룹
        PlaceNetManager.shared.read(sid: sid) { places in
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
                spendingLabel.text = self.numberFormatter(number: userTotalSpending)
            }
        }
    }
}

extension MyPageScheduleViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    // 컬렉션 뷰 cell 개수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.hasSchedule == false {
            return 1
        } else {
            return self.scheduleCount
        }
    }
    
    // 셀 사이즈 결정 함수
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 화면 사이즈 값 저장
        let screenWidthSize = UIScreen.main.bounds.size.width
        let screenHeightSize = UIScreen.main.bounds.size.height

        let width : CGFloat = screenWidthSize * 0.9
        let height: CGFloat = screenWidthSize * 0.9
        let cgSize =  CGSize(width: width, height: height)
        return cgSize
    }

    // 컬렉션 뷰 cell 내용 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 화면 사이즈 값 저장
        let screenWidthSize = UIScreen.main.bounds.size.width
        let screenHeightSize = UIScreen.main.bounds.size.height
        
        if self.hasSchedule == false {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomScheduleCollecionCell_2", for: indexPath) as?
                    CustomScheduleCollecionCell_2 else {
                return UICollectionViewCell()
            }
            
            // 일정없음 표시라벨 제약조건 설정
            cell.noScheduleLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                // x,y 축 중심에 위치하도록 설정
                cell.noScheduleLabel.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                cell.noScheduleLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            ])
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomScheduleCollecionCell", for: indexPath) as?
                    CustomScheduleCollecionCell else {
                return UICollectionViewCell()
            }
            
            // 셀 내부 제약 조건 설정
            cell.totalImageView.translatesAutoresizingMaskIntoConstraints = false
            cell.scheduleDataStackView.translatesAutoresizingMaskIntoConstraints = false
            cell.cellSettingButton.translatesAutoresizingMaskIntoConstraints = false
        
            NSLayoutConstraint.activate([
                // 이미지 표시 뷰 위치 설정
                cell.totalImageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 0),
                cell.totalImageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: 0),
                cell.totalImageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 0),
                cell.totalImageView.heightAnchor.constraint(equalToConstant: screenWidthSize * 0.5),
                cell.totalImageView.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                
                // 일정 정보 표시 스택 뷰 설정
                cell.scheduleDataStackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
                cell.scheduleDataStackView.topAnchor.constraint(equalTo: cell.totalImageView.bottomAnchor, constant: (((screenWidthSize * 0.9) - (screenWidthSize * 0.5)) - 115) / 2),
                
                // 일정 설정 버튼 설정
                cell.cellSettingButton.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -15),
                cell.cellSettingButton.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -15)
            ])
            
            // 이미지 표시 뷰 설정
            cell.totalImageView.backgroundColor = #colorLiteral(red: 0.9349470735, green: 0.9332778454, blue: 0.9347544312, alpha: 1)
            cell.totalImageView.layer.cornerRadius = screenWidthSize * 0.09

            // cell 설정
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.layer.cornerRadius = screenWidthSize * 0.09 // 둥근 모서리
            cell.layer.masksToBounds = false
            
            // cell 그림자 설정
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.2
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowRadius = 5
            
            // 셀 설정 버튼 설정
            cell.cellSettingButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)

            // cell 내용 설정
            cell.sid = scheduleArray[indexPath.row].sid
            cell.scheduleTitle.text = scheduleArray[indexPath.row].title
            cell.regionLabel.text = scheduleArray[indexPath.row].region
            cell.startLabel.text = scheduleArray[indexPath.row].start
            cell.stopLabel.text = scheduleArray[indexPath.row].stop
            cell.statusLabel.text = scheduleStausArray[indexPath.row]
            
            // 스케줄 상태표시 라벨 설정
            cell.statusLabel.textColor = setColor(text: cell.statusLabel.text!)
            cell.statusImage.tintColor = setColor(text: cell.statusLabel.text!)
            
            // 금액 표시
            self.requestSpendingData(sid : scheduleArray[indexPath.row].sid!, spendingLabel : cell.totalSpending)
        
            // 메뉴 설정
            let menuItems : [UIAction] = [
                UIAction(title: "일정 편집", image: UIImage(systemName: "square.and.pencil")){ _ in
                self.currentCellSid = cell.sid
                self.moveEditScehduleScreen()
            }, UIAction(title: "일정 삭제", image: UIImage(systemName: "trash"), attributes: .destructive){ _ in
                self.currentCellSid = cell.sid
                self.arletDeleteSchedule()
            }] // 메뉴 아이템 생성
            let UIMenu = UIMenu(title : "일정 설정 메뉴", children : menuItems) // 메뉴 생성
            cell.cellSettingButton.menu = UIMenu // 버튼에 메뉴 등록
            cell.cellSettingButton.showsMenuAsPrimaryAction = true // 클릭시 즉시 메뉴 표시
            
            return cell
        }
    }
    
    // 일정 삭제 선택시 알림
    @objc func arletDeleteSchedule() {
        // 로그아웃에 대한 알림
        let alertController = UIAlertController(title: "일정 삭제", message: "일정에 대한 모든 데이터가 삭제됩니다.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (action) in
            print("취소")
            alertController.dismiss(animated: true, completion: nil)
        }
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { (action) in
            print("삭제")
            self.reloadAfterDeleteSchedule() // 스케줄 삭제후 화면 다시 표시
            self.deleteScheduleFromDB() // 스케줄 DB에서 삭제
            alertController.dismiss(animated: true){}
        }
        alertController.addAction(cancelAction) // 액션 추가
        alertController.addAction(deleteAction) // 액션 추가
        present(alertController, animated: true, completion: nil)
    }

    // 일정 편집 화면으로 이동하는 함수
    func moveEditScehduleScreen() {
        guard let scheduleEditVC = self.storyboard?.instantiateViewController(identifier: "scheduleEditVC") as? ScheduleEditViewController else {return}
        scheduleEditVC.modalPresentationStyle = .fullScreen
        scheduleEditVC.modalTransitionStyle = .coverVertical
        
        // 현재 여행 일정의 sid 값을 가지는 일정 구체를 찾아 편집화면으로 전달
        if let index = self.scheduleArray.firstIndex(where: {$0.sid == currentCellSid})  {
            scheduleEditVC.schedule = self.scheduleArray[index]
        }
        self.present(scheduleEditVC, animated: true)
    }
}

// 셀 설정
class CustomScheduleCollecionCell : UICollectionViewCell {
    var sid : Int? // sid
    @IBOutlet weak var totalImageView: UIView! // 이미지 표시 뷰
    @IBOutlet weak var scheduleDataStackView: UIStackView! // 일정 데이터 스택 뷰
    @IBOutlet weak var scheduleTitle: UILabel! // 스케줄 이름
    @IBOutlet weak var regionLabel: UILabel! // 스케줄 지역
    @IBOutlet weak var statusImage: UIImageView! // 스케줄 상태 이미지
    @IBOutlet weak var startLabel: UILabel! // 스케줄 시작 날짜
    @IBOutlet weak var stopLabel: UILabel! // 스케줄 종료 날짜
    @IBOutlet weak var statusLabel: UILabel! // 스케줄 상태
    @IBOutlet weak var totalSpending: UILabel! // 지출 금액
    @IBOutlet weak var cellSettingButton: UIButton! // 설정 버튼
}

class CustomScheduleCollecionCell_2 : UICollectionViewCell {
    @IBOutlet weak var noScheduleLabel: UILabel! // 일정 없음 라벨
}
