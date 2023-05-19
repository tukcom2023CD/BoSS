//
//  AlbumImagePopUpController.swift
//  iOS
//
//  Created by JunHee on 2023/02/13.
//

import UIKit

class AlbumImagePopUpController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
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
        
        // 화면 가로세로 길이 값 설정
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        // 뒷배경 불투명 처리
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        // 이미지 뷰 제약 조건 설정
        NSLayoutConstraint.activate([
            // 너비 설정
            self.imageView.heightAnchor.constraint(equalToConstant: screenWidth * 1.0),
            // 높이 설정
            self.imageView.heightAnchor.constraint(equalToConstant: screenHeight * 0.5),
            // 위치 설정
            self.imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // 버튼 스택 뷰 제약 조건 설정
        NSLayoutConstraint.activate([
            // 위치 설정
            self.buttonStackView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor
                                                      , constant: screenWidth * 0.1),
            self.buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // 버튼 제약 조건 설정
        NSLayoutConstraint.activate([
            // 삭제 버튼 크기 설정
            self.deleteButton.widthAnchor.constraint(equalToConstant: screenWidth * 0.2),
            self.deleteButton.heightAnchor.constraint(equalToConstant: screenWidth * 0.1),
            
            // 수정 버튼 크기 설정
            self.editButton.widthAnchor.constraint(equalToConstant: screenWidth * 0.2),
            self.editButton.heightAnchor.constraint(equalToConstant: screenWidth * 0.1),
            
            // 닫기 버튼 크기 설정
            self.closeButton.widthAnchor.constraint(equalToConstant: screenWidth * 0.2),
            self.closeButton.heightAnchor.constraint(equalToConstant: screenWidth * 0.1),
        ])
        
        // 이미지 설정
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        // 닫기 버튼 설정
        closeButton.backgroundColor = #colorLiteral(red: 0.0668868199, green: 0.847835958, blue: 0.07329245657, alpha: 1)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.layer.cornerRadius = 15
        
        // 수정 버튼 설정
        editButton.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        editButton.setTitleColor(.white, for: .normal)
        editButton.layer.cornerRadius = 15
        
        // 삭제 버튼 설정
        deleteButton.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        deleteButton.setTitleColor(.white, for: .normal)
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
            CategoryNetManager.shared.delete(imageName: self.imageName) {
                print("카테고리 삭제")
            }
            
            // 사진 삭제 버튼이 눌림을 알림
            NotificationCenter.default.post(name: NSNotification.Name("ImageDeleteButtonPressed"), object: self)
            
            // 이미지 팝업창 닫기
            self.dismiss(animated: true, completion: nil)
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
