//
//  WritingEditPageViewController.swift
//  iOS
//
//  Created by 박다미 on 2023/02/13.
//

import UIKit
import PhotosUI

class WritingEditPageViewController: UIViewController{
    

    
    @IBOutlet weak var scrollView: UIScrollView!
    // @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var imageCard: UIImageView!
    
    @IBOutlet weak var contents: UITextView!
   
    
    @IBOutlet weak var receiptView: UIView!
    //  @IBOutlet weak var detailCost: UIView!
    
    let textViewPlaceHolder = "텍스트를 입력하세요"
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiViewSetting()
        imageCardSetting()
        //detailCostSetting()
        setupTapGestures()
        contentsSetting()
        // Do any additional setup after loading the view.
        self.contents.delegate = self
        contents.isScrollEnabled = false
        receiptView.layer.cornerRadius = 5
//        receiptView.layer.borderWidth = 1
//        receiptView.layer.borderColor = UIColor.systemGray2
//            .cgColor
    }
    
    func contentsSetting(){
        contents.layer.cornerRadius = 10
        contents.layer.borderWidth = 3
        contents.layer.borderColor = UIColor.systemGray6
            .cgColor
        contents.text = textViewPlaceHolder
        contents.textColor = .lightGray
      
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
    
    // 제스쳐 설정 (이미지뷰가 눌리면, 실행)
    func setupTapGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchUpImageView))
        imageCard.addGestureRecognizer(tapGesture)
        imageCard.isUserInteractionEnabled = true
        print(#function)
    }
    
    @objc func touchUpImageView() {
        print("이미지뷰 터치")
        setupImagePicker()
    }
    
    func setupImagePicker() {
        // 기본설정 셋팅
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0
        configuration.filter = .any(of: [.images, .videos])
        
        // 기본설정을 가지고, 피커뷰컨트롤러 생성
        let picker = PHPickerViewController(configuration: configuration)
        // 피커뷰 컨트롤러의 대리자 설정
        picker.delegate = self
        // 피커뷰 띄우기
        self.present(picker, animated: true, completion: nil)
    }
    
    
    
    func uiViewSetting(){
        uiView.dropShadow(color: UIColor.lightGray, offSet:CGSize(width: 0, height: 6), opacity: 0.5, radius:5)
        
        self.uiView.layer.borderWidth = 0.3
        self.uiView.layer.borderColor = UIColor.lightGray.cgColor
        self.uiView.layer.cornerRadius = 10
    }
    func imageCardSetting(){
        self.imageCard.layer.borderWidth = 0.3
        self.imageCard.layer.borderColor = UIColor.lightGray.cgColor
        self.imageCard.layer.cornerRadius = 10
        
    }
//    func detailCostSetting(){
//
//        detailCost.dropShadow(color: UIColor.lightGray, offSet:CGSize(width: 0, height: 6), opacity: 0.5, radius:5)
//    }
    func changeTitleMode(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
        print(self.scrollView.contentOffset.y)
        if self.scrollView.contentOffset.y > 0
        {
            navigationItem.largeTitleDisplayMode = .never
        } else {
            navigationItem.largeTitleDisplayMode = .always
        }
    }
    //수정 취소후 뒤로 가기
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        //한번 물어보는 alert창 띄우기
        let alert = UIAlertController(title: "페이지를 나가겠습니까?", message:
         "수정이 취소됩니다.", preferredStyle: .alert)
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
    
    
    @IBAction func receiptButtonTapped(_ sender: UIButton) {
        print(#function)
 
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
              let vc = storyboard.instantiateViewController(identifier: "ReceiptViewController")
              
              present(vc, animated:true, completion: nil)
    }
    //저장하기
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        
        guard let vcStack =
                self.navigationController?.viewControllers else { return }
        for vc in vcStack {
            if let view = vc as? WritingPageViewController {
                view.imageCardData = imageCard.image
                view.contentsData = contents.text
            
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
                DispatchQueue.main.async {
                    // 이미지뷰에 표시
                    self.imageCard.image = image as? UIImage
                }
            }
        } else {
            print("이미지 못 불러옴")
        }
    }
}
extension WritingEditPageViewController: UITextViewDelegate{
        // MARK: textview 높이 자동조절
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
        }}

