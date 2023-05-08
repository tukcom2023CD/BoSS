//
//  ScheduleEditViewController.swift
//  iOS
//
//  Created by JunHee on 2023/04/11.
//

import UIKit
import CalendarDateRangePicker

// Delegate 프로토콜 정의
protocol MyDelegate: AnyObject {
    func didChangeValue(value: String)
}

// 여행 일정 편집 화면
class ScheduleEditViewController : UIViewController {

    @IBOutlet weak var viewTitleLabel: UILabel! // 여행일정편집 라벨
    @IBOutlet weak var settingStackView: UIStackView! // 설정 스택뷰
    @IBOutlet weak var buttonStackView: UIStackView! // 버튼 스택뷰
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var scheduleNameTextField: UITextField!
    @IBOutlet weak var scheduleDateTextField: UITextField!
    @IBOutlet weak var dataChangeButton: UIButton!
    @IBOutlet weak var regionTextField: UITextField!
    @IBOutlet weak var regionChangeButton: UIButton!
        
    var schedule: Schedule! // 일정 데이터 구조체
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleNameTextField.delegate = self // 델리게이트 설정

        // 텍스트 필드 수정 못하도록 설정
        scheduleDateTextField.isEnabled = false
        regionTextField.isEnabled = false
        
        setUI() // UI 설정
        setScheduleData() // 일정 데이터 표시
    }
    
    func setUI() {
        
        // 화면 사이즈 값 저장
        let screenWidthSize = UIScreen.main.bounds.size.width
        let screenHeightSize = UIScreen.main.bounds.size.height
        
        // 프로필 편집 타이틀 UI 코드 설정
        viewTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            // 상단으로 부터 떨어진 거리 설정
            viewTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeightSize * 0.1),
            // X축 중심에 맞춤
            viewTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        // 설정 스택 뷰 UI 코드 설정
        settingStackView.translatesAutoresizingMaskIntoConstraints = false
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            settingStackView.topAnchor.constraint(equalTo: viewTitleLabel.bottomAnchor, constant: screenHeightSize * 0.1),
            settingStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        // 여행 이름 텍스트 필드 코드 설정
        scheduleNameTextField.translatesAutoresizingMaskIntoConstraints = false
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            // 사이즈 설정
            scheduleNameTextField.widthAnchor.constraint(equalToConstant: screenWidthSize * 0.75),
            scheduleNameTextField.heightAnchor.constraint(equalToConstant: screenWidthSize * 0.125)
        ])
        
        // 여행기간 텍스트 필드 코드 설정
        scheduleDateTextField.translatesAutoresizingMaskIntoConstraints = false
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            // 사이즈 설정
            scheduleDateTextField.widthAnchor.constraint(equalToConstant: screenWidthSize * 0.75),
            scheduleDateTextField.heightAnchor.constraint(equalToConstant: screenWidthSize * 0.125)
        ])
        
        // 여행 지역 텍스트필드 코드 설정
        regionTextField.translatesAutoresizingMaskIntoConstraints = false
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            // 사이즈 설정
            regionTextField.widthAnchor.constraint(equalToConstant: screenWidthSize * 0.75),
            regionTextField.heightAnchor.constraint(equalToConstant: screenWidthSize * 0.125)
        ])
        
        // 기간 변경 버튼 UI 설정 코드
        dataChangeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // 사이즈 설정
            dataChangeButton.widthAnchor.constraint(equalToConstant: screenWidthSize * 0.2),
            dataChangeButton.heightAnchor.constraint(equalToConstant: screenWidthSize * 0.1)
        ])
        self.dataChangeButton.layer.cornerRadius = screenWidthSize * 0.02
        
        // 지역 변경 버튼 UI 설정 코드
        regionChangeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // 사이즈 설정
            regionChangeButton.widthAnchor.constraint(equalToConstant: screenWidthSize * 0.2),
            regionChangeButton.heightAnchor.constraint(equalToConstant: screenWidthSize * 0.1)
        ])
        self.regionChangeButton.layer.cornerRadius = screenWidthSize * 0.02
        
        // 버튼 스택 뷰 UI 코드 설정
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            // 상단으로 부터 떨어진 거리 설정
            buttonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: screenWidthSize * -0.25),
            // X축 중심에 맞춤
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // 사이즈 설정
        ])
        
        // 취소 버튼 UI 코드 설정
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            cancelButton.widthAnchor.constraint(equalToConstant: screenWidthSize * 0.3),
            cancelButton.heightAnchor.constraint(equalToConstant: screenWidthSize * 0.1)
        ])
        self.cancelButton.layer.cornerRadius = screenWidthSize * 0.03
        
        // 선택 버튼 UI 코드 설정
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            applyButton.widthAnchor.constraint(equalToConstant: screenWidthSize * 0.3),
            applyButton.heightAnchor.constraint(equalToConstant: screenWidthSize * 0.1)
        ])
        self.applyButton.layer.cornerRadius = screenWidthSize * 0.03
    }
    
    func setScheduleData() {
        // 일정 데이터 표시
        scheduleNameTextField.text = schedule.title! // 일정 이름 표시
        regionTextField.text = schedule.region! // 일정 지역 이름 표시
        scheduleDateTextField.text = schedule.start! + " ~ " + schedule.stop!
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @IBAction func applyButtonTapped(_ sender: UIButton) {
        
        // 제목 받아오기
        if let text = self.scheduleNameTextField.text {
            self.schedule.title = text
        } else {
            self.schedule.title = ""
        }
        
        // 지역 받아오기
        if let region = self.regionTextField.text {
            self.schedule.region = region
        }
        
        // 변경된 내용 DB 업데이트
        self.schedule.uid = UserDefaults.standard.getLoginUser()!.uid // uid값 설정
        
        ScheduleNetManager.shared.update(schedule: self.schedule) {
            NotificationCenter.default.post(name: NSNotification.Name("ScheduleUpdated"), object: self)
        }
        dismiss(animated: true)
    }
    
    
    
    // 날짜 변경 버튼 클릭시 동작
    @IBAction func dataChangeButtonTapped(_ sender: UIButton) {
        let dateRangePickerViewController = CalendarDateRangePickerViewController(collectionViewLayout: UICollectionViewFlowLayout())
        dateRangePickerViewController.delegate = self
        dateRangePickerViewController.minimumDate = Date()
        dateRangePickerViewController.maximumDate = Calendar.current.date(byAdding: .year, value: 2, to: Date())
        dateRangePickerViewController.selectedStartDate = nil
        dateRangePickerViewController.selectedEndDate = nil
        dateRangePickerViewController.selectedColor = UIColor.systemBlue
        dateRangePickerViewController.titleText = "날짜 선택"

        let navigationController = UINavigationController(rootViewController: dateRangePickerViewController)
        navigationController.navigationBar.isTranslucent = true
        navigationController.modalPresentationStyle = .fullScreen

        self.present(navigationController, animated: true, completion: nil)
    }
    
    // 지역 변경 버튼 클릭시 동작
    @IBAction func regionChangeButtonTapped(_ sender: UIButton) {
        // 지역 선택화면으로 이동 (컬렉션 뷰)
        guard let selectRegionVC = self.storyboard?.instantiateViewController(identifier: "selectRegionVC") as? SelectRegionViewController else {return}
        selectRegionVC.modalPresentationStyle = .fullScreen
        selectRegionVC.modalTransitionStyle = .coverVertical
        selectRegionVC.delegate = self
        self.present(selectRegionVC, animated: true)
    }
}

extension ScheduleEditViewController : MyDelegate {
    func didChangeValue(value : String) {
        self.schedule.region = value // 지역 이름 저장
        self.regionTextField.text = self.schedule.region // 지역 이름 표시
    }
}

extension ScheduleEditViewController : UITextFieldDelegate {
    // 글자수 제한 함수
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // 글자 수를 제한하는 코드
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
}

extension ScheduleEditViewController : CalendarDateRangePickerViewControllerDelegate {
    
    func didCancelPickingDateRange() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didPickDateRange(startDate: Date!, endDate: Date!) {
        self.schedule.start = CustomDateFormatter.format.string(from: startDate) // 일정 시작 날짜 저장
        self.schedule.stop = CustomDateFormatter.format.string(from: endDate) // 일정 종료 날짜 저장
        scheduleDateTextField.text = self.schedule.start! + " ~ " + self.schedule.stop!
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didSelectStartDate(startDate: Date!){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MMM d일 EEEE"
        print(dateFormatter.string(from: startDate))
    }
    
    @objc func didSelectEndDate(endDate: Date!){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MMM d일 EEEE"
        print(dateFormatter.string(from: endDate))
    }
}
