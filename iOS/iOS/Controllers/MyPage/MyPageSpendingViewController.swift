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
    
    var userTotalSpending = 0 // 사용자의 총지출
    var scheduleCount = 0 // 여행일정 수
    var scheduleTitleArray : [String] = [] // 일정 제목 배열
    var spendingOfScheduleArray : [Int] = [] // 일정의 지츨내역 배열
    
    var selectedCellIndex : IndexPath? // 선택된 셀 index

    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserTotalSpending()
        loadSpendingOfSchedule()
    }
    
    // 사용자 총지출 불러오기
    func loadUserTotalSpending() {
        var userTotalSpending = 0 // 사용자 총지출
        let group = DispatchGroup() // 비동기 함수 그룹
        group.enter() // 그룹에 추가
        ScheduleNetManager.shared.read(uid: self.uid!) { schedules in
            for schedule in schedules {
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
            self.collectionView.reloadData()
        }
    }
    
    // 사용자 일정수, 일정이름, 일정당지출  불러오기
    func loadSpendingOfSchedule() {
        ScheduleNetManager.shared.read(uid: self.uid!) { schedules in
            let scheduleCount = schedules.count // 일정 개수
            var scheduleTitleArray : [String] = [] // 일정 제목 배열
            var spendingOfScheduleArray : [Int] = [] // 일정의 지츨내역 배열
            var scheduleTotalSpending = 0 // 일정당 총 지출
            let group = DispatchGroup() // 비동기 함수 그룹 생성
            let group_2 = DispatchGroup()
            for schedule in schedules {
                scheduleTitleArray.append(schedule.title!) // 여행 일정 제목 저장
                group.enter() // 그룹에 추가
                PlaceNetManager.shared.read(sid: schedule.sid!) { places in
                    for place in places {
                        group.enter() // 그룹에 추가
                        group_2.enter() // 그웁에 추가
                        SpendingNetManager.shared.read(pid: place.pid!) { spendings in
                            for spending in spendings {
                                scheduleTotalSpending += (spending.quantity! * spending.price!)
                            }
                            group.leave() // 그룹에서 제외
                            group_2.leave() // 그룹에서 제외
                        }
                    }
                    group_2.notify(queue: .main) {
                        spendingOfScheduleArray.append(scheduleTotalSpending)
                        self.spendingOfScheduleArray = spendingOfScheduleArray // 일정당 총 지출 배열 설정
                        scheduleTotalSpending = 0
                    }
                    group.leave() // 그룹에서 제외
                }
                group.notify(queue: .main) {
                    self.scheduleCount = scheduleCount // 일정 개수 설정
                    self.scheduleTitleArray = scheduleTitleArray // 일정 제목 배열 설정
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    // 그림자 설정 함수
    func setShadow(cell : UICollectionViewCell) {
        cell.layer.shadowColor = UIColor.black.cgColor // 그림자 색깔
        cell.layer.masksToBounds = false // 그림자 잘림 방지
        cell.layer.shadowOffset = CGSize(width: 3, height: 3) // 그림자 위치
        cell.layer.shadowRadius = 5 // 그림자 반경
        cell.layer.shadowOpacity = 0.5 // alpha 값
    }
    
    // 금액 콤마 표기 함수
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number))!
    }
}

extension MyPageSpendingViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // 셀 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.scheduleCount + 1 //  일정수 + 충지출 셀 1개
       
    }
    
    // 셀 설정 함수
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userTotalSpendingCell", for: indexPath) as? userTotalSpendingCell else {
                return UICollectionViewCell()
            }
            
            cell.contentView.alpha = 1
            cell.layer.cornerRadius = 40 // 모서리 설정
            setShadow(cell : cell) // 그림자 설정
            cell.userTotalSpendingLabel.text = numberFormatter(number: self.userTotalSpending)
            
            return cell
        }
        
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "scheduleSpendingCell", for: indexPath) as? scheduleSpendingCell else {
                return UICollectionViewCell()
            }
            
            // cell 내용 설정
            cell.scheduleTitleLabel.text = self.scheduleTitleArray[indexPath.item - 1]
            cell.spendingOfScheduleLabel.text = numberFormatter(number : self.spendingOfScheduleArray[indexPath.item - 1])
            
            // cell UI 설정
            cell.contentView.alpha = 1
            cell.layer.cornerRadius = 15 // 모서리 설정
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
            
            // 변경된 셀을 를 애니메이션 효과를 적용하여 갱신
            UIView.animate(withDuration: 0.3) {
                collectionView.performBatchUpdates(nil, completion: nil)
            }
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
            let height: CGFloat = 150
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
}


