//
//  WritingEditPageViewController.swift
//  iOS
//
//  Created by 박다미 on 2023/02/13.
//

import UIKit
import PhotosUI

class WritingEditPageViewController: UIViewController {
    
//    var diary: Diary? {
//        didSet {
//            guard var diary = diary else { return }
//            imageCard.image = diary.imageCard
//            contents.text = diary.contents
//
//        }
//    }

    
    @IBOutlet weak var scrollView: UIScrollView!
   // @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var imageCard: UIImageView!
    
    @IBOutlet weak var contents: UITextView!
    // @IBOutlet weak var costButton: UIButton!
    
   // @IBOutlet weak var costLabel: UILabel!
    
    @IBOutlet weak var detailCost: UIView!
  
    

    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiViewSetting()
        imageCardSetting()
        detailCostSetting()
        
        setupTapGestures()
        // Do any additional setup after loading the view.
    
        
     
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
    func detailCostSetting(){
       
        detailCost.dropShadow(color: UIColor.lightGray, offSet:CGSize(width: 0, height: 6), opacity: 0.5, radius:5)
    }
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
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        //한번 물어보는 alert창 띄우기
        self.navigationController?.popViewController(animated: true)
  
}
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "WritingPageViewController") as! WritingPageViewController
        vc.imageCardData = imageCard.image
        vc.contentsData = contents.text

        navigationController?.pushViewController(vc, animated: true)

        self.navigationController?.popViewController(animated: true)
//        if segue.identifier == "toSecondVC" {
//            let secondVC = segue.destination as! SecondViewController
//            secondVC.modalPresentationStyle = .fullScreen
//
//            // 다음화면으로 데이터 전달
//            secondVC.bmiNumber = bmi
//            secondVC.bmiColor = getBackgroundColor()
//            secondVC.adviceString = getBMIAdviceString()
//        }
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

