//
//  MyPageSpendingViewController.swift
//  iOS
//
//  Created by JunHee on 2023/02/09.
//

import UIKit

// 사용자 지출내역 화면
class MyPageSpendingViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var uid = UserDefaults.standard.getLoginUser()!.uid // 사용자 uid
    var selectedCellIndex : IndexPath? // 선택된 셀 index
    
    var userTotalSpending : Int = 0 // 사용자의 총지출
    
    var scheduleCount : Int = 0  // 여행일정 수
    
    var sidArray : [Int] = [] // sid 배열
    
    // 지출 금액 표시 셀에 대한 구조체
    struct spendingOfEachSchedule {
        var title : String? // 일정 이름
        var region : String? // 일정 지역
        var spending : Int? // 일정 지출 금액
        var stausColor : UIColor? // 일정 상태에 따른 색
    }
    
    var spendingOfEachScheduleDict : [Int : spendingOfEachSchedule] = [:] // 일정 구조체 딕셔너리

    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserTotalSpending()
        loadSpendingOfSchedule()
    }
    
    // 사용자 총지출 불러오기
    func loadUserTotalSpending() {
        var userTotalSpending = 0 // 사용자 총지출
        var scheduleCount = 0 // 일정 수
        var sidArray : [Int] = [] // sid 배열
        let group = DispatchGroup() // 비동기 함수 그룹
        group.enter() // 그룹에 추가
        ScheduleNetManager.shared.read(uid: self.uid!) { schedules in
            scheduleCount = schedules.count // 일정 수 저장
            for schedule in schedules {
                sidArray.append(schedule.sid!)
                group.enter() // 그룹에 추가
                PlaceNetManager.shared.read(sid: schedule.sid!) { places in
                    for place in places {
                        group.enter() // 그룹에 추가
                        SpendingNetManager.shared.read(pid: place.pid!) { spendings in
                            for spending in spendings {
                                userTotalSpending += (spending.quantity! * spending.price!)
                            }
                            group.leave() // 그룹에서 제외
                        }
                    }
                    group.leave() // 그룹에서 제외
                }
            }
            group.leave() // 그룹에서 제외
        }
        group.notify(queue: .main) {
            self.userTotalSpending = userTotalSpending // 사용자 총지출 설정
            self.scheduleCount = scheduleCount // 일정 수 저장
            self.sidArray = sidArray // sid 배열 저장
            self.collectionView.reloadData()
        }
    }
    
    // 사용자 일정수, 일정이름, 일정당지출  불러오기
    func loadSpendingOfSchedule() {
        var spendingOfEachScheduleDict : [Int : spendingOfEachSchedule] = [:]// 일정 구조체 딕셔너리
        let group = DispatchGroup() // 비동기 함수 그룹 생성
        ScheduleNetManager.shared.read(uid: self.uid!) { schedules in
            for schedule in schedules {
                let spendingOfEachSchedule = spendingOfEachSchedule(title: schedule.title!, region: schedule.region!, spending : 0, stausColor: self.discriminationScheduleData(schedule: schedule)) // 일정 구조체
                spendingOfEachScheduleDict[schedule.sid!] = spendingOfEachSchedule // sid를 키값으로 저장
                group.enter() // 그룹에 추가
                PlaceNetManager.shared.read(sid: schedule.sid!) { places in
                    for place in places {
                        group.enter() // 그룹에 추가
                        SpendingNetManager.shared.read(pid: place.pid!) { spendings in
                            for spending in spendings {
                                spendingOfEachScheduleDict[schedule.sid!]?.spending! += (spending.price! * spending.quantity!)
                            }
                            group.leave() // 그룹에서 제외
                        }
                    }
                    group.leave() // 그룹에서 제외
                }
                group.notify(queue: .main) {
                    self.spendingOfEachScheduleDict = spendingOfEachScheduleDict
                    print(spendingOfEachScheduleDict)
                    self.collectionView.reloadData() // 새로고침
                }
            }
        }
    }
    
    // 그림자 설정 함수
    func setShadow(cell : UICollectionViewCell) {
        cell.layer.masksToBounds = false // 그림자 잘림 방지
        cell.layer.shadowColor = UIColor.black.cgColor // 그림자 색깔
        cell.layer.shadowOpacity = 0.5 // alpha 값
        cell.layer.shadowOffset = CGSize(width: 3, height: 3) // 그림자 위치
        cell.layer.shadowRadius = 5 // 그림자 반경
    }
    
    // 금액 콤마 표기 함수
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number))!
    }
    
    // 스케줄 상태에 따른 색 구분
    func discriminationScheduleData(schedule: Schedule) -> UIColor {
        var status = ""
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let currentDate = formatter.string(from: Date())
        if currentDate > schedule.stop! {
            status = "완료"
        } else if (currentDate >= schedule.start! && currentDate <= schedule.stop!) {
            status = "진행중"
        } else {
            status = "예정"
        }
           
        if status == "완료" {
            return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        } else if status == "진행중" {
            return #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        } else if status == "예정" {
            return #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        } else {
            return #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        }
    }
}

extension MyPageSpendingViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // 셀 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.scheduleCount + 1
        //
       
    }
    
    // 셀 설정 함수
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userTotalSpendingCell", for: indexPath) as? userTotalSpendingCell else {
                return UICollectionViewCell()
            }
            
            cell.contentView.alpha = 1
            cell.layer.cornerRadius = 20 // 모서리 설정
            setShadow(cell : cell) // 그림자 설정
            cell.userTotalSpendingLabel.text = numberFormatter(number: self.userTotalSpending)
            
            return cell
        }
        
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "scheduleSpendingCell", for: indexPath) as? scheduleSpendingCell else {
                return UICollectionViewCell()
            }
            
            let sid = self.sidArray[indexPath.item - 1]
            
            // cell 내용 설정
            if let title =  self.spendingOfEachScheduleDict[sid]?.title {
                cell.scheduleTitleLabel.text = title
            } else {
                cell.scheduleTitleLabel.text = "???"
            }
            
            if let region =  self.spendingOfEachScheduleDict[sid]?.region {
                cell.scheduleRegionLabel.text = region
            } else {
                cell.scheduleTitleLabel.text = "???"
            }
            
            if let color =  self.spendingOfEachScheduleDict[sid]?.stausColor {
                cell.scheduleStatusLabel.backgroundColor = color
            } else {
                cell.scheduleTitleLabel.text = "???"
            }
            
            if let spending = self.spendingOfEachScheduleDict[sid]?.spending {
                cell.spendingOfScheduleLabel.text = numberFormatter(number : spending)
            } else {
                cell.spendingOfScheduleLabel.text = "???"
            }
            
            // cell UI 설정
            cell.contentView.alpha = 0.8
            cell.layer.cornerRadius = 20 // 모서리 설정
            cell.scheduleStatusLabel.layer.masksToBounds = true
            cell.scheduleStatusLabel.layer.cornerRadius = 3
            setShadow(cell : cell) // 그림자 설정
            
            return cell
        }
    }
    
    // 셀 선택 됐을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            // 누른 셀이 이미 선택되어 있던 셀인 경우
            if selectedCellIndex == indexPath {
                selectedCellIndex = nil
                if let cell = collectionView.cellForItem(at: indexPath) as? scheduleSpendingCell {
                    cell.contentView.alpha = 0.8
                }
            }
            // 누른 셀이 선택되어 있던 셀이 아닌 경우
            else if selectedCellIndex != indexPath {
                // 다른 셀이 선택되어 있던 경우
                if let index = self.selectedCellIndex {
                    if let cell = collectionView.cellForItem(at: index) as? scheduleSpendingCell {
                        cell.contentView.alpha = 0.8
                    }
                }
                // 선택된 셀이 없던 경우
                self.selectedCellIndex = indexPath
                if let cell = collectionView.cellForItem(at: indexPath) as? scheduleSpendingCell {
                    cell.contentView.alpha = 1
                }
            }
        }
        
        UIView.animate(withDuration: 0.5) {
            collectionView.performBatchUpdates(nil, completion: nil)
        }
    }
    
    // 셀 사이즈 결정 함수
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item != 0 {
            // 만약 해당 셀이 선택된 셀이라면
            if self.selectedCellIndex == indexPath {
                let width : CGFloat = 350
                let height: CGFloat = 200
                let cgSize =  CGSize(width: width, height: height)
                return cgSize
            }
            // 만약 해당 셀이 선택된 셀이 아니라면
            else  {
                let width : CGFloat = 350
                let height: CGFloat = 100
                let cgSize =  CGSize(width: width, height: height)
                return cgSize
            }
        } else {
            let width : CGFloat = 350
            let height: CGFloat = 100
            let cgSize =  CGSize(width: width, height: height)
            return cgSize
        }
    }
    
    // 셀표시 할떄 함수
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // 딜레이 값
        let delay : Double = (Double(indexPath.item) * (0.1))
        
        // 셀의 초기 투명도와 위치 설정
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: collectionView.bounds.width, y: 0)
        
        // 투명도를 1, 원래 위치로 이동
        UIView.animate(withDuration: 0.7, delay: delay, options: [.curveEaseInOut], animations: {
            cell.alpha = 1
            cell.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}


class userTotalSpendingCell : UICollectionViewCell {
    @IBOutlet weak var userTotalSpendingLabel: UILabel!
}

class scheduleSpendingCell : UICollectionViewCell {
    @IBOutlet weak var scheduleTitleLabel: UILabel! // 일정 이름
    @IBOutlet weak var spendingOfScheduleLabel: UILabel! // 일정의 총 지출액
    @IBOutlet weak var scheduleRegionLabel: UILabel! // 일정 지역 이름
    @IBOutlet weak var scheduleStatusLabel: UILabel! // 일정 상태 라벨
}


