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
    
    var loadedTotalSpending : Bool = false // 총 지출 불러왔는지 여부
    var loadedEachSchedule : Bool = false // 각 일정을 불러왔는지 여부
    
    var uid = UserDefaults.standard.getLoginUser()!.uid // 사용자 uid
    var userTotalSpending : Int = 0 // 사용자의 총지출
    var scheduleCount : Int = 0  // 여행일정 수
    var sidArray : [Int] = [] // sid 배열
    var selectedCellIndex : IndexPath? // 선택된 일정 셀 index
    
    // 지출 금액 표시 셀에 대한 구조체
    struct spendingOfEachSchedule {
        var title : String? // 일정 이름
        var region : String? // 일정 지역
        var spending : Int? // 일정 지출 금액
        var stausColor : UIColor? // 일정 상태에 따른 색
        var spendingCount : Int? // 지출내역 수
    }
    
    // 일정 구조체 딕셔너리
    var spendingOfEachScheduleDict : [Int : spendingOfEachSchedule] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI() // UI 설정
        loadUserTotalSpending() // 총지출 계산
        loadSpendingOfSchedule() // 일정당 지출 계산
    }
    
    func setupUI() {
        // 컬렉션 뷰 UI 코드 설정
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            // 위치 설정
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
        ]) 
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
            self.loadedTotalSpending = true
            self.userTotalSpending = userTotalSpending // 사용자 총지출 설정
            self.scheduleCount = scheduleCount // 일정 수 저장
            self.sidArray = sidArray // sid 배열 저장
            self.collectionView.reloadData()
        }
    }
    
    // 일정 정보 불러오기
    func loadSpendingOfSchedule() {
        // 일정 구조체 딕셔너리
        var spendingOfEachScheduleDict : [Int : spendingOfEachSchedule] = [:]
        let group = DispatchGroup() // 비동기 함수 그룹 생성
        ScheduleNetManager.shared.read(uid: self.uid!) { schedules in
            for schedule in schedules {
                let spendingOfEachSchedule = spendingOfEachSchedule(title: schedule.title!, region: schedule.region!, spending : 0, stausColor: self.discriminationScheduleData(schedule: schedule), spendingCount : 0) // 일정 구조체
                spendingOfEachScheduleDict[schedule.sid!] = spendingOfEachSchedule // sid를 키값으로 저장
                group.enter() // 그룹에 추가
                PlaceNetManager.shared.read(sid: schedule.sid!) { places in
                    for place in places {
                        group.enter() // 그룹에 추가
                        SpendingNetManager.shared.read(pid: place.pid!) { spendings in
                            for spending in spendings {
                                spendingOfEachScheduleDict[schedule.sid!]?.spending! += (spending.price! * spending.quantity!)
                                spendingOfEachScheduleDict[schedule.sid!]?.spendingCount! += 1
                            }
                            group.leave() // 그룹에서 제외
                        }
                    }
                    group.leave() // 그룹에서 제외
                }
                group.notify(queue: .main) {
                    self.loadedEachSchedule = true
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
        cell.layer.shadowOffset = CGSize(width: 0, height: 0) // 그림자 위치
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
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let currentDate = formatter.string(from: Date())
        if currentDate > schedule.stop! {
            return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) // 완료된 일정인 경우
        } else if (currentDate >= schedule.start! && currentDate <= schedule.stop!) {
            return #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1) // 진행중인 일정인 경우
        } else {
            return #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) // 예정인 일정인 경우
        }
    }
}

extension MyPageSpendingViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 각 스케줄 내용 로딩이 완료된 경우
        if self.loadedEachSchedule == true {
            return self.scheduleCount + 1  // 셀 수
        } else {
            return 1
        }
    }

    // 셀 설정 함수
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 화면 사이즈 값 저장
        let screenWidthSize = UIScreen.main.bounds.size.width
        let screenHeightSize = UIScreen.main.bounds.size.height
        
        if indexPath.item == 0 { // 첫번째 셀 : 총지출 표시 셀인 경우
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userTotalSpendingCell", for: indexPath) as? userTotalSpendingCell else {
                return UICollectionViewCell()
            }
            
            // 첫번째 셀 UI 코드 설정
            cell.totalSpendingStackView.translatesAutoresizingMaskIntoConstraints = false
            
            // 제약 조건 설정
            NSLayoutConstraint.activate([
               // 스택 뷰 위치
                cell.totalSpendingStackView.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                cell.totalSpendingStackView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            ])
            cell.layer.cornerRadius = screenWidthSize * 0.055 // 모서리 설정
            setShadow(cell : cell) // 그림자 설정
            cell.userTotalSpendingLabel.text = numberFormatter(number: self.userTotalSpending) // 총지출
            
            return cell
        }
        
        else { // 나머지 셀 : 일정당 지출금액 표시 셀인 경우
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "scheduleSpendingCell", for: indexPath) as? scheduleSpendingCell else {
                return UICollectionViewCell()
            }
            
            cell.scheduleStatusLabel.translatesAutoresizingMaskIntoConstraints = false
            cell.scheduleDataStackView_1.translatesAutoresizingMaskIntoConstraints = false
            cell.scheduleDataStackView_2.translatesAutoresizingMaskIntoConstraints = false
            cell.collectionView.translatesAutoresizingMaskIntoConstraints = false
            cell.textLabel.translatesAutoresizingMaskIntoConstraints = false
            
            // 제약 조건
            NSLayoutConstraint.activate([
                // 막대 라벨 설정
                cell.scheduleStatusLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: screenWidthSize * 0.025),
                cell.scheduleStatusLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: screenWidthSize * 0.05),
                cell.scheduleStatusLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -screenWidthSize * 0.05),
                cell.scheduleStatusLabel.widthAnchor.constraint(equalToConstant: screenWidthSize * 0.0125),
                
                // 텍스트 라벨 설정
                cell.textLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: screenHeightSize * 0.12),
                cell.textLabel.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                
                // 일정 정보 스택뷰 1 설정
                cell.scheduleDataStackView_1.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: ((screenHeightSize * 0.12) - cell.scheduleDataStackView_1.bounds.size.height) * 0.5),
                cell.scheduleDataStackView_1.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: ((screenHeightSize * 0.12) - cell.scheduleDataStackView_1.bounds.size.height) * 0.5),
                
                // 일정 정보 스택뷰 2 설정
                cell.scheduleDataStackView_2.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -((screenHeightSize * 0.12) - cell.scheduleDataStackView_2.bounds.size.height) * 0.5),
                cell.scheduleDataStackView_2.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: ((screenHeightSize * 0.12) - cell.scheduleDataStackView_2.bounds.size.height) * 0.5),
                
                // 내부 컬렉션 뷰 설정
                cell.collectionView.topAnchor.constraint(equalTo: cell.topAnchor, constant: screenHeightSize * 0.12 + 20),
                cell.collectionView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -screenWidthSize * 0.05),
                cell.collectionView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: screenWidthSize * 0.05),
                cell.collectionView.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -screenWidthSize * 0.025),
            ])
            // cell UI 설정
            cell.layer.cornerRadius = screenWidthSize * 0.055 // 모서리 설정
            
            let sid = self.sidArray[indexPath.item - 1] // sid 배열에서 첫번째 sid 가져옴
            cell.sid = sid // cell의 sid 설정
            
            // cell 내용 설정
            if let title =  self.spendingOfEachScheduleDict[sid]?.title {
                cell.scheduleTitleLabel.text = title // 일정 이름
            }
            if let region =  self.spendingOfEachScheduleDict[sid]?.region {
                cell.scheduleRegionLabel.text = region // 여행 지역
            }
            if let color =  self.spendingOfEachScheduleDict[sid]?.stausColor {
                cell.scheduleStatusLabel.backgroundColor = color // 일정 상태에 대한 색
            }
            if let spending = self.spendingOfEachScheduleDict[sid]?.spending {
                cell.spendingOfScheduleLabel.text = numberFormatter(number : spending) // 지출 금액
            }
            cell.contentView.alpha = 0.8
            cell.scheduleStatusLabel.layer.masksToBounds = true // 상태 표시 라벨 설정
            cell.scheduleStatusLabel.layer.cornerRadius = 3 // 상태 표시 라벨 설정
            setShadow(cell : cell) // 그림자 설정
            return cell
        }
    }
    
    // 셀 선택 됐을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            // 누른 셀이 이미 선택되어있던 셀인 경우
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
                    cell.loadEachSpending() // 상세 지출내역 데이터 불러옴
                }
            }
        }
        
        UIView.animate(withDuration: 0.5) { // 애니메이션 적용하여 셀 업데이트
            collectionView.performBatchUpdates(nil, completion: nil)
        }
    }
    
    // 셀 사이즈 결정 함수
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 화면 사이즈 값 저장
        let screenWidthSize = UIScreen.main.bounds.size.width
        let screenHeightSize = UIScreen.main.bounds.size.height

        if indexPath.item != 0 {
            // 만약 해당 셀이 선택된 셀이라면
            if self.selectedCellIndex == indexPath {
                var height: CGFloat = screenHeightSize * 0.12
                // 만약 해당 일정에 지출내역이 존재하면
                let sid = self.sidArray[indexPath.item - 1] // sid 가져옴
                if let spendingCount = self.spendingOfEachScheduleDict[sid]?.spendingCount {
                    if spendingCount != 0 {
                        height += 30
                        height += (screenWidthSize * 0.05) // 내부 컬렉션 뷰 하단 공간
                        for _ in 1...spendingCount {
                            height += CGFloat((screenHeightSize * 0.1) + 10)
                        }
                    }
                }
                let width : CGFloat = screenWidthSize * 0.85
                let cgSize =  CGSize(width: width, height: height)
                return cgSize
            }
            // 만약 해당 셀이 선택된 셀이 아니라면
            else  {
                let width : CGFloat = screenWidthSize * 0.85
                let height: CGFloat = screenHeightSize * 0.12
                let cgSize =  CGSize(width: width, height: height)
                return cgSize
            }
        } else {
            let width : CGFloat = screenWidthSize * 0.85
            let height: CGFloat = screenHeightSize * 0.12
            let cgSize =  CGSize(width: width, height: height)
            return cgSize
        }
    }
    
    // 셀표시할떄 함수
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.item != 0 {
            // 딜레이 값
            let delay : Double = (Double(indexPath.item) * (0.05))
            // 셀의 초기 투명도와 위치 설정
            cell.alpha = 0
            cell.transform = CGAffineTransform(translationX: collectionView.bounds.width, y: 0)
            // 투명도를 1, 원래 위치로 이동
            UIView.animate(withDuration: 0.5, delay: delay, options: [.curveEaseInOut], animations: {
                cell.alpha = 1
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
}

// 총 지출 금액 표시 셀
class userTotalSpendingCell : UICollectionViewCell {
    @IBOutlet weak var totalSpendingStackView: UIStackView!
    @IBOutlet weak var userTotalSpendingLabel: UILabel!
}

// 각 일정당 지출 금액 표시 셀
class scheduleSpendingCell : UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
    @IBOutlet weak var collectionView: UICollectionView!
    
    var sid : Int? // sid
    var spendingCount : Int = 0  // 지출내역수
    var spidArray : [Int] = []
    
    // 지출 금액 표시 셀에 대한 구조체
    struct spendingForCell {
        var title : String? // 지출 이름
        var region : String? // 지출 지역
        var spending : Int? // 지출 금액
        var date : String? // 지출 날짜
    }
    
    var spendingDict : [Int : spendingForCell] = [:] // 일정 구조체 딕셔너리
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // 지출 내역 정보 불러오기
    func loadEachSpending() {
        var spendingCount : Int = 0  // 지출내역수
        var spidArray : [Int] = []
        var spendingDict : [Int : spendingForCell] = [:] // 일정 구조체 딕셔너리
        let group = DispatchGroup() // 비동기 함수 그룹 생성
        PlaceNetManager.shared.read(sid: self.sid!) { places in
            for place in places {
                group.enter() // 그룹에 추가
                SpendingNetManager.shared.read(pid: place.pid!) { spendings in
                    for spending in spendings {
                        spendingCount += 1
                        spidArray.append(spending.spid!)
                        let spendingFC = spendingForCell(title: spending.name!, region: place.name!, spending : (spending.price! * spending.quantity!), date: place.visitDate!)
                        spendingDict[spending.spid!] = spendingFC
                    }
                    group.leave() // 그룹에서 제외
                }
            }
            group.notify(queue: .main) {
                self.spendingCount = spendingCount
                self.spidArray = spidArray
                self.spendingDict = spendingDict
                self.collectionView.reloadData() // 새로고침
            }
        }
    }
        
    // 그림자 설정 함수
    func setShadow(cell : UICollectionViewCell) {
        cell.layer.masksToBounds = false // 그림자 잘림 방지
        cell.layer.shadowColor = UIColor.black.cgColor // 그림자 색깔
        cell.layer.shadowOpacity = 0.5 // alpha 값
        cell.layer.shadowOffset = CGSize(width: 0, height: 0) // 그림자 위치
        cell.layer.shadowRadius = 3 // 그림자 반경
    }

    // 금액 콤마 표기 함수
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number))!
    }
    
    // 셀 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spendingCount
    }
    
    // 셀 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 화면 사이즈 값 저장
        let screenWidthSize = UIScreen.main.bounds.size.width
        let screenHeightSize = UIScreen.main.bounds.size.height
        
        let width : CGFloat = screenWidthSize * 0.72
        let height: CGFloat = screenHeightSize * 0.1
        let cgSize =  CGSize(width: width, height: height)
        return cgSize
    }
    
    // 셀 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailedCell", for: indexPath) as? detailedSpendingCell else {
            return UICollectionViewCell()
        }
        
        // 화면 사이즈 값 저장
        let screenWidthSize = UIScreen.main.bounds.size.width
        let screenHeightSize = UIScreen.main.bounds.size.height
        
        cell.spendingStackView_1.translatesAutoresizingMaskIntoConstraints = false
        cell.spendingStackView_2.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            // 지출 스택뷰_1 설정
            cell.spendingStackView_1.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: ((screenHeightSize * 0.1) - cell.spendingStackView_1.bounds.size.height) * 0.5),
            cell.spendingStackView_1.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            
            // 지출 스택뷰_2 설정
            cell.spendingStackView_2.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: (-((screenHeightSize * 0.1) - cell.spendingStackView_1.bounds.size.height) * 0.5)),
            cell.spendingStackView_2.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
        ])
        
        cell.layer.cornerRadius = 10 // 모서리 설정
        setShadow(cell : cell) // 그림자 설정
        
        let spid = self.spidArray[indexPath.item] // spid 가져옴
        
        // 지출 내역 이름 설정
        if let title = self.spendingDict[spid]?.title {
            cell.spendingTitleLabel.text = title
        }
        // 지출 내역 지역 설정
        if let region = self.spendingDict[spid]?.region {
            cell.spendingRegionLabel.text = region
        }
        // 지출 내역 금액 설정
        if let spending = self.spendingDict[spid]?.spending {
            cell.spendingLabel.text = numberFormatter(number : spending)
        }
        // 지출 날짜 설정
        if let date = self.spendingDict[spid]?.date {
            cell.spendingDateLabel.text = date
        }
        return cell
    }
    
    // 셀표시 할떄 함수
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // 딜레이 값
        let delay : Double = (Double(indexPath.item) * (0.1))
        // 셀의 초기 투명도와 위치 설정
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: collectionView.bounds.width, y: 0)
        
        // 투명도를 1, 원래 위치로 이동
        UIView.animate(withDuration: 0.5, delay: delay, options: [.curveEaseInOut], animations: {
            cell.alpha = 1
            cell.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    @IBOutlet weak var scheduleDataStackView_1: UIStackView!
    @IBOutlet weak var scheduleDataStackView_2: UIStackView!
    @IBOutlet weak var scheduleTitleLabel: UILabel! // 일정 이름
    @IBOutlet weak var spendingOfScheduleLabel: UILabel! // 일정의 총 지출액
    @IBOutlet weak var scheduleRegionLabel: UILabel! // 일정 지역 이름
    @IBOutlet weak var scheduleStatusLabel: UILabel! // 일정 상태 라벨
    @IBOutlet weak var textLabel: UILabel!
}

// 세부 지출내역 셀
class detailedSpendingCell : UICollectionViewCell {
    @IBOutlet weak var spendingStackView_1: UIStackView!
    @IBOutlet weak var spendingStackView_2: UIStackView!
    @IBOutlet weak var spendingTitleLabel: UILabel!
    @IBOutlet weak var spendingRegionLabel: UILabel!
    @IBOutlet weak var spendingLabel: UILabel!
    @IBOutlet weak var spendingDateLabel: UILabel!
}
