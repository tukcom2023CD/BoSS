//
//  WritingEditPageViewController.swift
//  iOS
//
//  Created by 박다미 on 2023/02/13.
//




/*
 필요한 정보 = 화면이동후에도 지속적으로 나타나야하는 정보들
 wrtingPage : 1
 editPage:    2
 reciepVC:    3
 
 1-2: 1)image, 2)contents 3)영수증관련[총합  품명,수량,가격  각 행마다의 가격]
        *각 행마다의 가격:여기선 안쓰지만 3에서 delete기능을 사용하기 위한 정보:1->2로가져와야 3에서 delete수행가능

 2-3: 1)영수증관련 정보 [총합  품명,수량,가격  각 행마다의 가격]을 가져와서 add delete 계산
 

----------------------------
 3->2   :IBAction사용을 안해서 프로토콜로 데이터 전송함: totalPriceData, receiptData, subTotalData
        그외  @IBAction로 받음
 2->3 이 밑으로는 @IBAction 시 vc로 데이터 전송
 
 -------
 
 2->1
 1->2
 2->3
 -----------------------------
 1->3으로 다시 데이터를 가져올때는 변수앞에 get붙여서 사용함 ex) getTotalData..
 
 
 
 */
import UIKit
import PhotosUI




var dataArray = [AllData]()


// MARK: WritingEditPageViewController : 영수증정보( 1총합, 2품명, 3수량, 4가격) 받고 5contents 정보 생김 => 1-5 정보 WritingPageviewController로 넘김
class WritingEditPageViewController: UIViewController, SendProtocol{
    
//    func sendData(totalPriceData: String, receiptData: [AllData], subTotalData: [Int]) {
//        getTotalData = "\(totalPriceData)" //2에서의 데이터는 1로가던 3으로 가던 같은 정보를 전달하므로 get을 붙인 변수를 같이 사용함
//        getAllData = receiptData
//        getSubTotalData = subTotalData
//
//
//        totalPriceLabel.text = "\(totalPriceData)"
//        allData = receiptData
//        self.subTotalData = subTotalData
//    }
    func sendData(totalPriceData: String, receiptData: [Spending], subTotalData: [Int]) {
        totalPriceLabel.text = "\(totalPriceData)"
        spendings = receiptData
        self.subTotalData = subTotalData
        
      
        
    }
    
    //MARK: - Properties
    var subTotalData: [Int]? //delete를 위한 각 행의 가격 데이터
    //WritingPageVC에서 다시 받을 데이터
    var getSubTotalData : [Int]?
    var getImageCard : UIImage?
    var getContents : String?
    var getAllData : [AllData]?
    var getTotalData : String?
    
    
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var imageCard: UIImageView!
    @IBOutlet weak var contents: UITextView!
    @IBOutlet weak var receiptView: UIView!
    
    // 새로 추가한 변수
    var place: Place!
    var spendings: [Spending]!
   // var edit_to_Recipt:Bool = false //보낼 데이터가 있으면 true. 보낼 데이터가 없을때 0이나 nil을 보냄방지용
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
        if getImageCard != nil {
            imageCard.image = getImageCard
        }
        if getContents != nil {
            contents.text = getContents
        }
        if getAllData![0].priceData != ""{
            allData = getAllData
        }
        if getTotalData != "0" {
            totalPriceLabel.text = getTotalData
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
        
        //[name,quantity, price] 보내기
        if (spendings != nil){
            
            vc.spendings = self.spendings!
        }
//        if ((getAllData?[0].priceData) !=  "" ) {
//            vc.stringArr = getAllData!
//        }
//        if (getTotalData != "0") {
//            vc.getTotalData = totalPriceLabel.text//self.getTotalData
//        }
//
//        if (getSubTotalData != nil){
//            vc.getSubTotalData = self.getSubTotalData
//        }
//
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
        
        place.diary = contents.text
        // place.total_spending = ...
        
        let image = imageCard.image
        
        DispatchQueue.global().async {
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            PhotoNetManager.shared.create(uid: self.place.uid!, sid: self.place.sid!, pid: self.place.pid!, image: image!) {
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            PlaceNetManager.shared.update(place: self.place) {
                dispatchGroup.leave()
            }
            
            // 상세 지출 내역 네트워킹 코드 추가
            //            SpendingNetManager.shared.create(spendings: ) {
            //
            //            }
            
            dispatchGroup.notify(queue: .main) {
                guard let vcStack =
                        self.navigationController?.viewControllers else { return }
                for vc in vcStack {
                    if let view = vc as? WritingPageViewController {
                        view.imageCardData = self.imageCard.image
                        view.contentsData = self.contents.text
                        view.getPrice = self.allData ?? [AllData(itemData: "", amountData:"", priceData: "")]
                        view.totalPrice = self.totalPriceLabel.text ?? ""
                        view.subTotalData = self.subTotalData
                        
                        
                        view.place = self.place
                        view.imageCard.image = self.imageCard.image
                        
                        self.navigationController?.popToViewController(view, animated: true)
                    }
                }
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
                            //왜 있는지 물어보기
                            self.allData
                        } else {    // 상세 지출 내역이 존재할 때
                            for item in receiptData.subResults[0].items {
                                let name = item.name.formatted.value
                                let count = item.count.formatted.value
                                let price = item.price.price.formatted.value
                                self.allData
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
                    self.allData
                } else {  // 상세 지출 내역이 존재할 때
                    for item in receiptData.subResults[0].items {
                        let name = item.name.formatted.value
                        let count = item.count.formatted.value
                        let price = item.price.price.formatted.value
                        self.allData
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
