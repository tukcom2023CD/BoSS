//
//  WritingEditPageViewController.swift
//  iOS
//
//  Created by 박다미 on 2023/02/13.
//


import UIKit
import PhotosUI

protocol PhotoArrayProtocol: AnyObject {
    func updatePhotoArray(_ photoArray: [ImageData])
    func appendDeletedPhotoArray(_ deletedPhotos: ImageData)
}

class WritingEditPageViewController: UIViewController, SendProtocol,PhotoArrayProtocol{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sendingVC = segue.destination as? WriteEditPhotoViewController {
            sendingVC.delegate = self
            sendingVC.photoArray = self.photoArray
        }
    }
    
    // Container View segue가 실행될 때 호출되는 함수
    //       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //           if segue.identifier == "WritingEditPageVC" {
    //               // Container View 안의 ViewController를 가져옴
    //               let childViewController = segue.destination as! WriteEditPhotoViewController
    //
    //               // 데이터 전달
    //               childViewController.photoArray = self.photoArray
    //           }
    //       }
    
    func updatePhotoArray(_ photoArray: [ImageData]) {
        self.photoArray = photoArray
        print("받는쪽 사진 배열은 \(photoArray.count) items")
    }
    
    func appendDeletedPhotoArray(_ deletedPhotos: ImageData) {
        self.deletedPhotos.append(deletedPhotos)
    }
//    
//    func didUpdatePhotoArray(_ photoArray: [UIImage]) {
//        self.photoArray = photoArray
//    }
    
    
    func sendData(receiptData: [Spending]) {
        spendings = receiptData
        total_subPriceCal()
    }
    
    //MARK: - Properties
    var subTotalData: [Int] = [] //delete를 위한 각 행의 가격 데이터
    var getImageCard : UIImage?
    var photoArray : [ImageData] = []
    var deletedPhotos: [ImageData] = []
    let textViewPlaceHolder = "텍스트를 입력하세요"
    let textViewPlaceHolderColor = UIColor.lightGray
    
    var writeEditPhotoViewController: WriteEditPhotoViewController?
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!

    
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
   // @IBOutlet weak var uiView: UIView!
    
    @IBOutlet weak var contents: UITextView!
    @IBOutlet weak var receiptView: UIView!
    @IBOutlet weak var outView: UIView!
    // 새로 추가한 변수
    var place: Place!
    var spendings: [Spending]!
    var imagePickerStatus = false // 이미지 피커 상태 (false: 여행 사진 선택, true: 영수증 OCR)
    
   
    //WritingPage로 넘길 데이터
    
    let camera = UIImagePickerController() // 카메라 변수
    var totalPrice : Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        total_subPriceCal()
        // view가 화면에 보여질 때 contents의 높이를 글자수에 맞춰서 조절
           let size = CGSize(width: view.frame.width, height: .infinity)
           let estimatedSize = contents.sizeThatFits(size)
           contents.constraints.forEach { (constraint) in
               if constraint.firstAttribute == .height {
                   constraint.constant = estimatedSize.height
               }
           }
           textViewHeightConstraint.constant = estimatedSize.height
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
        
        setupCamera()
        contentsSetting()
        
        self.contents.delegate = self
        contents.isScrollEnabled = false
        receiptView.layer.cornerRadius = 5
        
        // contentInset 속성을 사용하여 여백 설정
       contents.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        if place.diary == "" {
                contents.text = textViewPlaceHolder
                contents.textColor = textViewPlaceHolderColor
            }
            else {
                
                contents.text = place.diary
                contents.textColor = .black
                
                
            }

//        textViewHeightConstraint.constant = contents.intrinsicContentSize.height
//
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 스크롤 뷰 컨텐츠 크기 재설정
        let contentHeight = 200 + contents.frame.height + 50 + 100 + 120
        //tableView.contentSize.height + subView1.frame.height
        if scrollView.contentSize != CGSize(width: scrollView.frame.width, height: contentHeight) {
            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: contentHeight)
        }
    }
    // MARK: - 금액 3자리수 마다 , 붙이기
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number))!
    }
    // MARK: - total_subPriceCal : 총가격과 행마다의 가격계산함수
    func total_subPriceCal(){
        totalPrice = 0
        subTotalData = []
        if (spendings.count != 0){
            for i in 0...spendings.count-1{
                totalPrice += (spendings[i].quantity ?? 1) * (spendings[i].price ?? 0)
                subTotalData.insert((spendings[i].quantity ?? 1) * (spendings[i].price ?? 0), at: 0)
            }
            totalPriceLabel.text = numberFormatter(number: totalPrice)//String(totalPrice)
        }
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
//    func uiViewSetting(){
//        uiView.dropShadow(color: UIColor.lightGray, offSet:CGSize(width: 0, height: 6), opacity: 0.5, radius:5)
//
//        self.uiView.layer.borderWidth = 0.3
//        self.uiView.layer.borderColor = UIColor.lightGray.cgColor
//        self.uiView.layer.cornerRadius = 10
//    }
    
    
    
    
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
            self.deletedPhotos.removeAll()
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
        
        
        if (spendings != nil){
            vc.place = self.place!
            vc.spendings = self.spendings!
        }
        
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
        if contents.text == "텍스트를 입력하세요" {
            place.diary = ""
        } else {
            place.diary = contents.text
        }
        place.totalSpending = totalPrice
        let spendingData = SpendingData(pid: place.pid!, spendings: spendings)
        let addedPhotos = photoArray.filter({ $0.isAdded }).map({ $0.image })
        
        
        
        DispatchQueue.global().async {
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            PhotoNetManager.shared.create(uid: self.place.uid!, sid: self.place.sid!, pid: self.place.pid!, image: addedPhotos) {
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            PlaceNetManager.shared.update(place: self.place) {
                dispatchGroup.leave()
            }
            
            // 상세 지출 내역 네트워킹 코드 추가
            dispatchGroup.enter()
            SpendingNetManager.shared.create(spendings: spendingData) {
                dispatchGroup.leave()
            }
            
            self.deletedPhotos.forEach {
                let param = self.extractValues(from: $0.imageUrl ?? "")
                dispatchGroup.enter()
                PhotoNetManager.shared.delete(imageName: param) {
                    dispatchGroup.leave()
                }
            }
            
            
            dispatchGroup.notify(queue: .main) {
                self.deletedPhotos.removeAll()
                guard let vcStack =
                        self.navigationController?.viewControllers else { return }
                for vc in vcStack {
                    if let view = vc as? WritingPageViewController {
                        // view.imageCardData = self.imageCard.image
                        view.spendings = self.spendings
                        view.place = self.place
                        //view.imageCard.image = self.imageCard.image
                        //view.photoArray = self.photoArray.filter({ !$0.isDeleted }).map({ ImageData(image: $0.image, isAdded: false, imageUrl: $0.imageUrl) })
                        view.uploadImageCard {
                            DispatchQueue.main.async {
                                self.navigationController?.popToViewController(view, animated: true)
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    func extractValues(from url: String) -> (x: String?, y: String?, w: String?, z: String?) {
        let components = url.components(separatedBy: "/")
        let count = components.count
        let w = components[count - 1] // "w.jpg"
        let z = components[count - 2] // "z.jpg"
        let y = components[count - 3] // "y.jpg"
        let x = components[count - 4] // "x.jpg"
        return (x,y,z,w)
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
                    OCRNetManager.shared.requestReceiptData(image: image) { [self] receiptData in
                        if receiptData.subResults.isEmpty {     // 총 비용만 존재할 때
                            let name = receiptData.storeInfo.name.formatted.value
                            let price = receiptData.totalPrice.price.formatted.value
                            
                            self.spendings.insert(Spending(name: name, quantity: 1, price:Int(price), pid: self.place.pid!), at: 0)
                            total_subPriceCal()
                        } else {    // 상세 지출 내역이 존재할 때
                            for item in receiptData.subResults[0].items {
                                let name = item.name.formatted.value
                                let count = item.count.formatted.value
                                let price = item.price.price.formatted.value
                                
                                self.spendings.insert(Spending(name: name, quantity: Int(count), price: Int(price), pid: self.place.pid!), at: 0)
                                
                                total_subPriceCal()
                            }
                        }
                    }
                }
                
            }
        } else {
            print("이미지 못 불러옴")
        }
    }
    // WriteEditPhotoViewController 인스턴스 생성 및 photoArray 접근
    func addImage() {
        let writeEditPhotoViewController = WriteEditPhotoViewController()
        photoArray = writeEditPhotoViewController.photoArray
        navigationController?.pushViewController(writeEditPhotoViewController, animated: true)
    }
}

// MARK: - ImagePickerControllerDelegate
extension WritingEditPageViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)
        guard let image = info[.originalImage] as? UIImage else { return }
        
        // 인공지능 네트워킹 처리
        
        let alert = UIAlertController(title: "처리 중...", message: "잠시만 기다려주세요.", preferredStyle: .alert)
        
        present(alert, animated: true)
        //picker.present(alert, animated: true) {
        OCRNetManager.shared.requestReceiptData(image: image) { receiptData in
            if receiptData.subResults.isEmpty { // 총 비용만 존재할 때
                let name = receiptData.storeInfo.name.formatted.value
                let price = receiptData.totalPrice.price.formatted.value
                
                self.spendings.insert(Spending( price:Int(price)), at: 0)
                
                
                
            } else {  // 상세 지출 내역이 존재할 때
                for item in receiptData.subResults[0].items {
                    let name = item.name.formatted.value
                    let count = item.count.formatted.value
                    let price = item.price.price.formatted.value
                    
                    self.spendings.insert(Spending(name: name, quantity: Int(count), price: Int(price)), at: 0)
                    
                }
            }
            alert.dismiss(animated: true)
            //picker.dismiss(animated: true)
        }
        //}
        
        
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
            
//            /// 50 이하일때는 더 이상 줄어들지 않게하기
//            if estimatedSize.height <= 50 {
//
//            }
//            else {
//                if constraint.firstAttribute == .height {
//                    constraint.constant = estimatedSize.height
//                }
//            }
        }
        textViewHeightConstraint.constant = textView.intrinsicContentSize.height
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if contents.text == textViewPlaceHolder {
            contents.text = ""
            contents.textColor = .black
        }
    }
    //글자수를 500자 이내로 제한
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
         guard let oldText = textView.text else { return true }
         let newText = (oldText as NSString).replacingCharacters(in: range, with: text)
         return newText.count <= 500
     }
    func textViewDidEndEditing(_ textView: UITextView) {
        if contents.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            contents.text = textViewPlaceHolder
            contents.textColor = textViewPlaceHolderColor
            
        }
    }
}

extension WritingEditPageViewController: UINavigationControllerDelegate {
    
}
