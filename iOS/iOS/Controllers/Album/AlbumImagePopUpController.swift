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
    
    var categoryButtonArray : [UIButton] = [] // 카테고리 버튼 배열
    
    let width = UIScreen.main.bounds.width // 화면 너비값
    let height = UIScreen.main.bounds.height // 화면 높이값
    
    // 이미지 저장 변수
    var phid : Int?
    var image : UIImage = UIImage(named: "noImage.png")!
    var categoryArray : [String] = []
    var imageName : (String?, String?, String?, String?)
    
    // 확대 축소 기능을 위한 변수
    var recognizerScale: CGFloat = 1.0
    var maxScale: CGFloat = 3.0
    var minScale: CGFloat = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategoryOfPhoto() // 카테고리 불러오는 함수
        
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
    
    // 카테고리 버튼 새성 및 추가 함수
    func setCategoryButton() {
        
        categoryButtonArray = [] // 카테고리 버튼 배열 초기화
        
        for category in self.categoryArray {
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
                self.showEditableAlert(button : categoryButton)
            }), for: .touchUpInside)
            
            categoryButtonArray.append(categoryButton) // 배열에 추가
        }
        
        setButtonConstraint() // 제약 조건 설정
    }
    
    // 버튼 제약 조건 설정
    func setButtonConstraint() {
        
        var leading : CGFloat = 0 // 좌측 여백 공간
        var totalButtonWidth : CGFloat = 0 // 버튼들의 총 너비 합
        let buttonCount = categoryButtonArray.count // 버튼 수
        
        totalButtonWidth += CGFloat(10 * (buttonCount - 1)) // 버튼 개수 -1 개 만큼 10을 곱하여 더함
        
        // 너비 합 계산
        for button in categoryButtonArray {
            totalButtonWidth += button.frame.size.width
        }
        
        leading = (UIScreen.main.bounds.width - totalButtonWidth) * 0.5
        
        // 제약 조건 설정
        for button in categoryButtonArray {
            
            view.addSubview(button) // 뷰에 버튼 추가
            
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                // 위치 설정
                button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading),
                button.bottomAnchor.constraint(equalTo: self.imageView.topAnchor, constant: -10),
            ])
            
            leading += (10 + button.frame.size.width) // 좌측 공백 설정
        }
    }
    
    // 사진의 카테고리 불러오는 함수
    func loadCategoryOfPhoto() {
        self.categoryArray = []
        
        let group = DispatchGroup() // 비동기 함수 그룹
        group.enter()
        CategoryNetManager.shared.read(phid: self.phid!) { categories in
            for category in categories {
                self.categoryArray.append(category.category_name!)
            }
            group.leave()
        }
        group.notify(queue: .main) {
            // 버튼 설정 함수
            self.setCategoryButton()
        }
    }
    
    // 카테고리 업데이트 함수
    func updateCategory(phid : Int, category_name : String) {
        
        var category = Category(phid : phid, category_name : category_name)
        
        let group = DispatchGroup() // 비동기 함수 그룹
        group.enter()
        
        CategoryNetManager.shared.update(category: category) {
            print("카테고리 업데이트 완료")
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.loadCategoryOfPhoto() // 카테고리 불러오는 함수
        }
    }
    
    // 카테고리 수정 알림창 띄우는 함수
    func showEditableAlert(button : UIButton) {
        
        // 카테고리 수정 알림창
        let alertController = UIAlertController(title: "카테고리 수정", message: "카테고리를 입력하세요", preferredStyle: .alert)
        
        // textField 추가
        alertController.addTextField { textField in
            textField.placeholder = "카테고리 이름"
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
                    
                    self.showFailedEditingAlert()
                }
                // 테그트가 공백이 아니라면 수정
                else {
                    print(trimmedText)
                    self.updateCategory(phid: self.phid!, category_name: trimmedText)
                }
            }
        }
        
        // 액션 추가
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        present(alertController, animated: true, completion: nil)
    }

    // 수정 실패 알림
    func showFailedEditingAlert() {
        
        // 수정 실패 알림창
        let alertController2 = UIAlertController(title: "수정실패", message: "올바른 카테고리를 입력하세요.", preferredStyle: .alert)
        
        // 수정 실패 알림 취소 동작
        let closeAction = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
        
        // 동작 추가
        alertController2.addAction(closeAction)
        
        present(alertController2, animated: true, completion: nil)
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
            self.imageView.heightAnchor.constraint(equalToConstant: screenHeight * 0.3),
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
        closeButton.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.layer.cornerRadius = 15
        
        // 삭제 버튼 설정
        deleteButton.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
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
// 수정후 버튼 재설정
