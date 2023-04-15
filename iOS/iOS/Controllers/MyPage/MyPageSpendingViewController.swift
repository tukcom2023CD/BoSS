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
    
    var scheduleCount = 0 // 일정 수
    var scheduleTitleArray : [String] = [] // 일정 제목 배열
    var spendingOfScheduleArray : [Int] = [] // 일정의 지츨내역
    var spendingDict : [Int : Spending] = [:] // 각 일정의 세부 지출내역 딕셔너리 (키 : 값 = sid : Spending)
    
    var selectedCellIndex : IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        requestScheduleData() // 사용자 지출 내역 가져오기
    }
    
    // 일정, 지출내역 불러오기
    func requestScheduleData() {
        let user = UserDefaults.standard.getLoginUser()!
        var SpendingOfEachSchedule = 0 // 총지출
        ScheduleNetManager.shared.read(uid: user.uid!) { schedules in
            self.scheduleCount = schedules.count // 일정 개수 저장
            // 각 일정에 접근
            for schedule in schedules {
                SpendingOfEachSchedule = 0
                self.scheduleTitleArray.append(schedule.title!) // 일정 이름 저장
                PlaceNetManager.shared.read(sid: schedule.sid!) { places in
                    // 각 장소애 접근
                    for place in places {
                        SpendingNetManager.shared.read(pid: place.pid!) { spendings in
                            // 각 지출에 접근
                            for spending in spendings {
                                self.spendingDict[schedule.sid!] = spending // 일정에 속한 지출내역 저장
                                SpendingOfEachSchedule += spending.price! // 각 일정의 지출금액에 추가
                            }
                            self.spendingOfScheduleArray.append(SpendingOfEachSchedule)
                        }
                    }
                }
                if SpendingOfEachSchedule == 0 {
                    self.spendingOfScheduleArray.append(SpendingOfEachSchedule)
                }
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // 그림자 설정 함수
    func setShadow(cell : UICollectionViewCell) {
        cell.layer.shadowColor = UIColor.black.cgColor // 그림자 색깔
        cell.layer.masksToBounds = false // 그림자 잘림 방지
        cell.layer.shadowOffset = CGSize(width: 3, height: 3) // 그림자 위치
        cell.layer.shadowRadius = 3 // 그림자 반경
        cell.layer.shadowOpacity = 0.3 // alpha 값
    }
    
    // 금액 콤마 표기 함수
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number))!
    }
}

extension MyPageSpendingViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.scheduleCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "scheduleSpendingCell", for: indexPath) as? scheduleSpendingCell else {
            return UICollectionViewCell()
        }
        
        // cell 내용 설정
        cell.scheduleTitleLabel.text = self.scheduleTitleArray[indexPath.row]
        cell.spendingOfScheduleLabel.text = String(self.spendingOfScheduleArray[indexPath.row])
        
        // cell UI 설정
        cell.contentView.alpha = 0.8
        cell.layer.cornerRadius = 15 // 모서리 설정
        setShadow(cell : cell) // 그림자 설정
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
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
    }
}

class scheduleSpendingCell : UICollectionViewCell {
    @IBOutlet weak var scheduleTitleLabel: UILabel! // 일정 이름
    @IBOutlet weak var spendingOfScheduleLabel: UILabel! // 일정의 총 지출액
}


