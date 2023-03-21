//
//  AlbumImagePopUpController.swift
//  iOS
//
//  Created by JunHee on 2023/02/13.
//

import UIKit

class AlbumImagePopUpController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!

    // 이미지 저장 변수
    var image : UIImage = UIImage(named: "noImage.png")!
    var imageName : (String?, String?, String?, String?)
    
    // 확대 축소 기능을 위한 변수
    var recognizerScale: CGFloat = 1.0
    var maxScale: CGFloat = 3.0
    var minScale: CGFloat = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 핀치 제스쳐 정의 (이미지 확대)
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(AlbumImagePopUpController.doPinch(_:)))
        // 핀치 제스처를 등록
        self.view.addGestureRecognizer(pinch)
        
        // 탭 제스쳐 정의 (이미지 원래대로)
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(AlbumImagePopUpController.handleTap(_:)))
        tapGR.delegate = self
        tapGR.numberOfTouchesRequired = 2
        // 탭 제스쳐 등록
        self.view.addGestureRecognizer(tapGR)
            
        // UI 설정 함수 호출
        setUpUI()
    }
    
    // UI 설정
    func setUpUI() {
        // 뒷배경 불투명 처리
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        // 이미지 설정
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        // 버튼 설정
        closeButton.layer.borderWidth = 1
        closeButton.layer.borderColor = UIColor.systemBlue.cgColor
        closeButton.layer.cornerRadius = 15
        
        deleteButton.layer.borderWidth = 1
        deleteButton.layer.borderColor = UIColor.red.cgColor
        deleteButton.layer.cornerRadius = 15
    }
    
    // 닫기 버튼 동작
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    // 삭제 버튼 동작
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        // 이미지 삭제에 대한 알림
        let alertController = UIAlertController(title: "삭제", message: "삭제하시겠습니까?", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }

        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { (action) in
            PhotoNetManager.shared.delete(imageName: self.imageName) {
                print("이미지 삭제")
            }
            self.dismiss(animated: true)
        }
        
        alertController.addAction(cancelAction) // 액션 추가
        alertController.addAction(deleteAction) // 액션 추가

        present(alertController, animated: true, completion: nil)
    }
}


extension AlbumImagePopUpController : UIGestureRecognizerDelegate {
    // 핀치 제스쳐 메서드 구현
    @objc func doPinch(_ pinch: UIPinchGestureRecognizer) {
        guard imageView != nil else {return}
        if pinch.state == .began || pinch.state == .changed {
            if (recognizerScale < maxScale && pinch.scale > 1.0) {
                imageView.transform = (imageView.transform).scaledBy(x: pinch.scale, y: pinch.scale)
                recognizerScale *= pinch.scale
                pinch.scale = 1.0
            }
            else if (recognizerScale > minScale && pinch.scale < 1.0) {
                imageView.transform = (imageView.transform).scaledBy(x: pinch.scale, y: pinch.scale)
                recognizerScale *= pinch.scale
                pinch.scale = 1.0
            }
        }
    }
    
    // 탭 제스쳐 메서드 구현
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        imageView.transform = CGAffineTransform.identity
        recognizerScale = 1.0
    }
}
