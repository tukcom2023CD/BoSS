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
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var scheduleNameTextField: UITextField!
    @IBOutlet weak var scheduleDateTextField: UITextField!
    @IBOutlet weak var dataChangeButton: UIButton!
    @IBOutlet weak var regionTextField: UITextField!
    @IBOutlet weak var regionChangeButton: UIButton!
    
    var schedule: Schedule!
    var scheduleSID : Int?
    var scheduletTitle : String = ""
    var scheduletStart : String = ""
    var scheduletStop : String = ""
    var regionTitle : String = ""
    var uid : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scheduleNameTextField.delegate = self
        
        scheduleNameTextField.text = scheduletTitle
        scheduleDateTextField.text = scheduletStart + " ~ " + scheduletStop
        regionTextField.text = regionTitle
        
        scheduleDateTextField.isEnabled = false
        regionTextField.isEnabled = false
        
        setUI()
    }
    
    func setUI() {
        self.cancelButton.layer.cornerRadius = 20
        self.applyButton.layer.cornerRadius = 20
        self.dataChangeButton.layer.cornerRadius = 5
        self.regionChangeButton.layer.cornerRadius = 5
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @IBAction func applyButtonTapped(_ sender: UIButton) {
        
        // 제목 받아오기
        if let text = self.scheduleNameTextField.text {
            self.scheduletTitle = text
        } else {
            self.scheduletTitle = ""
        }
        
        // 지역 받아오기
        if let region = self.regionTextField.text {
            self.regionTitle = region
        }
        
        // 변경된 내용 DB 저장
        let schedule = Schedule (
            sid : self.scheduleSID,
            title : self.scheduletTitle,
            region : self.regionTitle,
            start : self.scheduletStart,
            stop : self.scheduletStop,
            uid : UserDefaults.standard.getLoginUser()!.uid )
        
        ScheduleNetManager.shared.update(schedule: schedule) {
            print("일정 업데이트")
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
        print(value)
        self.regionTextField.text = value
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
        self.scheduletStart = CustomDateFormatter.format.string(from: startDate)
        self.scheduletStop = CustomDateFormatter.format.string(from: endDate)
        
        scheduleDateTextField.text = scheduletStart + " ~ " + scheduletStop
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
