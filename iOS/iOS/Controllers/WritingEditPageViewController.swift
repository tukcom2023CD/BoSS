//
//  WritingEditPageViewController.swift
//  iOS
//
//  Created by 박다미 on 2023/02/13.
//

import UIKit
import PhotosUI

struct AllData {
    var itemData:String
    var amountData:String
    var priceData:String
    
    init(itemData:String, amountData:String, priceData:String) {
        self.itemData = itemData
        self.amountData = amountData
        self.priceData = priceData
    }
}

/// the data for the table
var dataArray = [AllData]()

class WritingEditPageViewController: UIViewController, TotalProtocol{
    func sendData(totalPriceData: String, priceData: [AllData]) {
        totalPriceLabel.text = "\(totalPriceData) 원"
        allData = priceData
    }
    
   
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var imageCard: UIImageView!
    @IBOutlet weak var contents: UITextView!
    @IBOutlet weak var receiptView: UIView!
    
    var imagePickerStatus = false // 이미지 피커 상태 (false: 여행 사진 선택, true: 영수증 OCR)
    var price : [String] = []  //WritingPage로 넘길 데이터
    
    let textViewPlaceHolder = "텍스트를 입력하세요"
    //WritingPage로 넘길 데이터
    var allData : [AllData]!
    let camera = UIImagePickerController() // 카메라 변수
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiViewSetting()
        imageCardSetting()
        
        setupTapGestures()
        setupCamera()
        contentsSetting()
        
        self.contents.delegate = self
        contents.isScrollEnabled = false
        receiptView.layer.cornerRadius = 5
        
        print( totalPriceLabel.text ?? "" )
    }
    
    
    // MARK: - contentsSetting
    func contentsSetting(){
        contents.layer.cornerRadius = 10
        contents.layer.borderWidth = 3
        contents.layer.borderColor = UIColor.systemGray6
            .cgColor
        contents.text = textViewPlaceHolder
        contents.textColor = .lightGray
        
    }
    
    // MARK: - setupTapGestures
    // 제스쳐 설정 (이미지뷰가 눌리면, 실행)
    func setupTapGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchUpImageView))
        imageCard.addGestureRecognizer(tapGesture)
        imageCard.isUserInteractionEnabled = true
        print(#function)
    }
    
    // MARK: - touchUpImageView
    @objc func touchUpImageView() {
        print("이미지뷰 터치")
        imagePickerStatus = false
        setupImagePicker()
    }
    
    // MARK: - setupImagePicker
    func setupImagePicker() {
        // 기본설정 셋팅
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0
        configuration.filter = .images
        
        // 기본설정을 가지고, 피커뷰컨트롤러 생성
        let picker = PHPickerViewController(configuration: configuration)
        // 피커뷰 컨트롤러의 대리자 설정
        picker.delegate = self
        // 피커뷰 띄우기
        self.present(picker, animated: true, completion: nil)
    }
    
    // MARK: - setupCamera
    func setupCamera() {
        camera.sourceType = .camera
        camera.allowsEditing = false
        camera.cameraDevice = .rear
        camera.cameraCaptureMode = .photo
        camera.delegate = self
    }
    
    // MARK: - uiViewSetting
    func uiViewSetting(){
        uiView.dropShadow(color: UIColor.lightGray, offSet:CGSize(width: 0, height: 6), opacity: 0.5, radius:5)
        
        self.uiView.layer.borderWidth = 0.3
        self.uiView.layer.borderColor = UIColor.lightGray.cgColor
        self.uiView.layer.cornerRadius = 10
    }
    
    // MARK: - imageCardSetting
    func imageCardSetting(){
        self.imageCard.layer.borderWidth = 0.3
        self.imageCard.layer.borderColor = UIColor.lightGray.cgColor
        self.imageCard.layer.cornerRadius = 10
        
    }
    
    // MARK: - changeTitleMode
    func changeTitleMode(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
        print(self.scrollView.contentOffset.y)
        if self.scrollView.contentOffset.y > 0 {
            navigationItem.largeTitleDisplayMode = .never
        } else {
            navigationItem.largeTitleDisplayMode = .always
        }
    }
    
    // MARK: - backButtonTapped
    //수정 취소후 뒤로 가기
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        //한번 물어보는 alert창 띄우기
        let alert = UIAlertController(title: "페이지를 나가겠습니까?", message:"수정이 취소됩니다.", preferredStyle: .alert)
        //액션 만들기
        
        let action = UIAlertAction(title: "네", style: .default, handler:  {(action) in
            self.navigationController?.popViewController(animated: true)
        })
        let cancel = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        //액션 추가 여기서 alert or actionsheet
        alert.addAction(cancel)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    // MARK: - receiptButtonTapped
    @IBAction func receiptButtonTapped(_ sender: UIButton) {
        print(#function)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ReceiptViewController") as! ReceiptViewController
        vc.delegate = self
        present(vc, animated:true, completion: nil)
        
    }
    
    // MARK: - cameraButtonTapped
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        
        let actionSheet = UIAlertController(title: "영수증 사진을 추가하시오.", message: "카메라 또는 앨범에 접근하시오.", preferredStyle: .actionSheet)
        let cameraSheet = UIAlertAction(title: "카메라", style: .default) { action in
            self.present(self.camera, animated: true)
        }
        let albumSheet = UIAlertAction(title: "앨범", style: .default) { action in
            self.imagePickerStatus = true
            self.setupImagePicker()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        actionSheet.addAction(cameraSheet)
        actionSheet.addAction(albumSheet)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    }
    
    // MARK: - saveButtonTapped
    //저장하기
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        
        guard let vcStack =
                self.navigationController?.viewControllers else { return }
        for vc in vcStack {
            if let view = vc as? WritingPageViewController {
                view.imageCardData = imageCard.image
                view.contentsData = contents.text
                view.getPrice = allData ?? [AllData(itemData: "", amountData:"", priceData: "")]
                view.totalPrice = totalPriceLabel.text ?? ""
                self.navigationController?.popToViewController(view, animated: true)
            }
        }
    }
}


//MARK: - 피커뷰 델리게이트 설정
extension WritingEditPageViewController: PHPickerViewControllerDelegate {
    
    // 사진이 선택이 된 후에 호출되는 메서드
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // 피커뷰 dismiss
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                
                guard let image = image as? UIImage else { return }
                
                if self.imagePickerStatus { // 영수증 OCR
                    OCRNetManager.shared.requestReceiptData(image: image) { receiptData in
                        if receiptData.subResults.isEmpty {     // 총 비용만 존재할 때
                            let name = receiptData.storeInfo.name.formatted.value
                            let price = receiptData.totalPrice.price.formatted.value
                            self.price.append("\(name)  |    -  |   \(price) ")
                        } else {    // 상세 지출 내역이 존재할 때
                            for item in receiptData.subResults[0].items {
                                let name = item.name.formatted.value
                                let count = item.count.formatted.value
                                let price = item.price.price.formatted.value
                                self.price.append("\(name)  |    \(count)  |   \(price) ")
                            }
                        }
                    }
                } else { // 여행 사진 추가
                    DispatchQueue.main.async {
                        // 이미지뷰에 표시
                        self.imageCard.image = image
                    }
                }
            }
        } else {
            print("이미지 못 불러옴")
        }
    }
}

// MARK: - ImagePickerControllerDelegate
extension WritingEditPageViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)
        guard let image = info[.originalImage] as? UIImage else { return }
        
        // 인공지능 네트워킹 처리
        
        let alert = UIAlertController(title: "처리 중...", message: "잠시만 기다려주세요.", preferredStyle: .alert)
        
        picker.present(alert, animated: true) {
            OCRNetManager.shared.requestReceiptData(image: image) { receiptData in
                if receiptData.subResults.isEmpty { // 총 비용만 존재할 때
                    let name = receiptData.storeInfo.name.formatted.value
                    let price = receiptData.totalPrice.price.formatted.value
                    self.price.append("\(name)  |    -  |   \(price) ")
                } else {  // 상세 지출 내역이 존재할 때
                    for item in receiptData.subResults[0].items {
                        let name = item.name.formatted.value
                        let count = item.count.formatted.value
                        let price = item.price.price.formatted.value
                        self.price.append("\(name)  |    \(count)  |   \(price) ")
                    }
                }
                alert.dismiss(animated: true)
                picker.dismiss(animated: true)
            }
        }
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension WritingEditPageViewController: UITextViewDelegate {
    // textview 높이 자동조절
    func textViewDidChange(_ textView: UITextView) {
        
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            
            /// 50 이하일때는 더 이상 줄어들지 않게하기
            if estimatedSize.height <= 50 {
                
            }
            else {
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if contents.text == textViewPlaceHolder {
            contents.text = nil
            contents.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if contents.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            contents.text = textViewPlaceHolder
            contents.textColor = .lightGray
        }
    }
}

extension WritingEditPageViewController: UINavigationControllerDelegate {
    
}
