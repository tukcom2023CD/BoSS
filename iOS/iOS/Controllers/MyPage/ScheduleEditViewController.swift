//
//  ScheduleEditViewController.swift
//  iOS
//
//  Created by JunHee on 2023/04/11.
//

import UIKit
import CalendarDateRangePicker

class ScheduleEditViewController : UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var scheduleNameTextField: UITextField!
    @IBOutlet weak var scheduleDateTextField: UITextField!
    @IBOutlet weak var dataChangeButton: UIButton!
    @IBOutlet weak var regionTextField: UITextField!
    @IBOutlet weak var regionChangeButton: UIButton!
    
    
    var scheduletTitle : String = ""
    var scheduletStart : String = ""
    var scheduletStop : String = ""
    var regionTitle : String = ""
    
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
    }
    
    
    
    @IBAction func dataChangeButtonTapped(_ sender: UIButton) {
        //datepicker 보이기
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
    
    
    @IBAction func regionChangeButtonTapped(_ sender: UIButton) {
       
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
