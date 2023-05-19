//
//  AlbumImagePopUpController.swift
//  iOS
//
//  Created by JunHee on 2023/02/13.
//

import UIKit

class AlbumImagePopUpController: UIViewController {

    @IBOutlet weak var imageView: UIImageView! // 이미지 뷰
    @IBOutlet weak var buttonStackView: UIStackView! // 버튼 스택 뷰
    @IBOutlet weak var closeButton: UIButton! // 닫기 버튼
    @IBOutlet weak var deleteButton: UIButton! // 삭제 버튼
    
    let width = UIScreen.main.bounds.width // 화면 너비값
    let height = UIScreen.main.bounds.height // 화면 높이값
    
    // 이미지 저장 변수
    var image : UIImage = UIImage(named: "noImage.png")!
    var category : String = ""
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
            
        // 버튼 설정 함수
        setCategoryButton()
        
        // UI 설정 함수 호출
        setUpUI()
    }
    
    // 카테고리 버튼 새성 및 추가 함수
    func setCategoryButton() {
        
        // 카테고리 버튼 생성
        let categoryButton = UIButton(type: .custom)
        
        // 버튼 타이틀 설정
        categoryButton.setTitle("\(category)", for: .normal)
        
        // 버튼 타이틀 폰트 사이즈
        categoryButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 17)
        
        // 버튼 타이틀 컬러 설정
        categoryButton.setTitleColor(.white, for: .normal)
        
        // 버튼 색상 설정
        categoryButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        
        // 버튼 이미지 설정
        let image = UIImage(systemName : "pencil")
        categoryButton.setImage(image, for: .normal)
        
        // 버튼 이미지 색상 설정
        categoryButton.tintColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        // 버튼 이미지 여백 공간 설정
        categoryButton.imageEdgeInsets =  UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        
        // 여백 공간 설정
        categoryButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 5)
        
        // 내용 맞게 사이즈 조절
        categoryButton.sizeToFit()
        
        // 잘림 설정
        categoryButton.clipsToBounds = true
        
        // 모서리 설정
        categoryButton.layer.cornerRadius = 10
        
        // 카테고리 버튼 클릭시
        categoryButton.addAction(UIAction(handler: { _ in
            self.showEditableAlert()
        }), for: .touchUpInside)
        
        // 뷰에 추가
        self.view.addSubview(categoryButton)
        
        // 제약 조건 설정
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        
        // 카테고리 라벨 제약 조건 설정
        NSLayoutConstraint.activate([
            // 위치 설정
            categoryButton.bottomAnchor.constraint(equalTo: self.imageView.topAnchor, constant: -20),
            categoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    // 카테고리 수정 알림창 띄우는 함수
    func showEditableAlert() {
        let alertController = UIAlertController(title: "카테고리 수정", message: "카테고리를 입력하세요", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "카테고리 이름"
            textField.text = self.category
        }
        
        // 취소 동작
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        // 저장 동작
        let saveAction = UIAlertAction(title: "저장", style: .default) { _ in
            // 텍스트 필드 가져옴
            if let textField = alertController.textFields?.first {
    
                // 불필요한 공백 제거
                let trimmedText = textField.text!.trimmingCharacters(in:
                        .whitespaces)
                
                // 텍스트 필드가 공백이라면
                if trimmedText == "" {
                    print("수정 실패")
                }
                // 테그트가 공백이 아니라면
                else {
                    self.category = trimmedText
                    print("수정된 텍스트: \(self.category)")
                }
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        present(alertController, animated: true, completion: nil)
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
            
            // 닫기 버튼 크기 설정
            self.closeButton.widthAnchor.constraint(equalToConstant: screenWidth * 0.2),
            self.closeButton.heightAnchor.constraint(equalToConstant: screenWidth * 0.1),
        ])
        
        // 이미지 설정
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        // 닫기 버튼 설정
        closeButton.backgroundColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.layer.cornerRadius = 15
        
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

// 카테고리 입력후 수정버튼 누르면 API호출하여 변경된 내용 DB 반영 및 카테고리 다시 불러오기
