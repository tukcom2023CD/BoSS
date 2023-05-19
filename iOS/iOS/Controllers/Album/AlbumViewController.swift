//
//  AlbumViewController.swift
//  iOS
//
//  Created by JunHee on 2023/02/13.
//

import UIKit

class AlbumViewController: UIViewController {

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // 화면 너비, 높이 값
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    // 카테고리 셀 간격 수치 값 설정 변수
    let categorySectionInsets = UIEdgeInsets(top: 1, left: 0, bottom: 10, right: 10)
    
    // 사진 셀 간격 수치 값 설정 변수
    let ImageSectionInsets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
   
    var categoryCount : Int = 0 // 카테고리 개수
    var totalCategoryArray : [String] = [] // 전체 카테고리 배열
    var selectedCategoryArray : [String] = [] // 선택된 카테고리 배열
    var categoryButtonArray : [UIButton] = [] // 카테고리 버튼 배열
    
    var imageCount : Int = 0  // 표시할 이미지 개수
    var phidArray : [Int] = [] // phid 배열 -> 이미지 구조체를 중복 저장하지 않기 위해 사용
    var ImageArray : [PhotoWithCategory] = [] // 이미지 구조체 배열
    
    var currentImageUrl = "" // 선택된 이미지의 url
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "앨범" // 네비게이션 아이템 타이틀
        
        // 컬렉션 뷰 태그 설정
        categoryCollectionView.tag = 1
        collectionView.tag = 2
        
        setUI() // UI 설정
        loadCategory() // 카테고리 불러오는 함수
        
        // 앨범 사진에대한 삭제 버튼을 클릭한 경우 삭제후 새로고침 함수 호출
        NotificationCenter.default.addObserver(self, selector: #selector(reloadAfterDeleteImage), name: NSNotification.Name("ImageDeleteButtonPressed"), object: nil)
    }
    
    // UI 설정
    func setUI() {
        
        self.categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // 카테고리 컬렉션 뷰
        NSLayoutConstraint.activate([
            // 위치 설정
            self.categoryCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            self.categoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            self.categoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            // 높이 설정
            self.categoryCollectionView.heightAnchor.constraint(equalToConstant: screenHeight * 0.25)
        ])
        
        // 이미지 컬렉션 뷰
        NSLayoutConstraint.activate([
            // 위치 설정
            self.collectionView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 0),
            self.collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            self.collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            self.collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
        ])
    }
    
    // 카테고리 버튼 배열 설정 함수
    func setCategoryButtonArray() {
        for category in totalCategoryArray {
            
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
            let image = UIImage(systemName : "checkmark.circle.fill")
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
            
            // 눌렸을 때 동작
            categoryButton.addAction(UIAction(handler: { _ in
                // 선택된 카테고리 배열에 존재 하지 않는 다면
                if !self.selectedCategoryArray.contains(categoryButton.titleLabel!.text!) {
                    
                    // 배열에 추가
                    self.selectedCategoryArray.append(categoryButton.titleLabel!.text!)
                    
                    // 버튼 색상 설정
                    categoryButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                    
                    // 버튼 색상 설정
                    categoryButton.tintColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                }
                // 선택된 카테고리 배열에 존재 한다면
                else {
                    // 배열에서 삭제
                    if let index = self.selectedCategoryArray.firstIndex(of: categoryButton.titleLabel!.text!) {
                        self.selectedCategoryArray.remove(at: index)
                    }
                    
                    // 버튼 색상 설정
                    categoryButton.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
                    
                    // 버튼 색상 설정
                    categoryButton.tintColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                }
                self.loadImagesWithCategory() // 이미지 다시 불러오기
            }), for: .touchUpInside)
            self.categoryButtonArray.append(categoryButton) // 배열에 추가
        }
    }
    
    // 카테고리 불러오는 함수
    func loadCategory() {
        // 카테고리 배열 초기화
        self.categoryCount = 0
        self.totalCategoryArray = []
        self.selectedCategoryArray = []
        
        let group = DispatchGroup() // 비동기 함수 그룹

        group.enter() // 그룹에 추가
        CategoryNetManager.shared.read() { categories in
            for category in categories {
                self.totalCategoryArray.append(category.category_name!)
                self.categoryCount += 1
            }
            group.leave()
        }
        group.notify(queue: .main) {
            self.selectedCategoryArray = self.totalCategoryArray // 초기에는 모두 선택된 카테고리로 설정
            self.setCategoryButtonArray() // 카테고리 버튼 설정
            self.categoryCollectionView.reloadData() // 컬렉션 뷰 다시 로딩
            self.loadImagesWithCategory() // 이미지 불러옴
        }
    }
    
    // 사진 불러오는 함수
    @objc func loadImagesWithCategory() {
        self.phidArray = []
        self.ImageArray = []
        self.imageCount = 0 // 이미지 수 초기화
        let user = UserDefaults.standard.getLoginUser()! // 유저 정보 불러오기
        
        // 어떠한 카테고리도 선택되어 있지 않은 경우
        if self.selectedCategoryArray == [] {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.navigationItem.title = "사진 \(self.imageCount) 장"
            }
        }
        // 선택된 카테고리가 존재하는 경우
        else {
            // 선택한 카테고리 별로 사진을 가져옴
            let group = DispatchGroup() // 비동기 함수 그룹
            for category in self.selectedCategoryArray {
                group.enter() // 그룹에 추가
                PhotoNetManager.shared.read(uid: user.uid!, category: category) { photos in
                    for photo in photos {
                        // phid 배열에 저장되어 있지 않다면
                        if !self.phidArray.contains(photo.phid) {
                            self.phidArray.append(photo.phid)
                            self.ImageArray.append(photo)
                            self.imageCount += 1
                        }
                    }
                    group.leave() // 그룹 떠남
                }
            }
            group.notify(queue: .main) {
                self.collectionView.reloadData()
                self.navigationItem.title = "사진 \(self.imageCount) 장"
            }
        }
    }
    
    @objc func reloadAfterDeleteImage() {
            self.imageCount -= 1
            let index = self.ImageArray.firstIndex(where: { $0.imageUrl == currentImageUrl })
            self.ImageArray.remove(at: index!)
            self.navigationItem.title = "사진 \(self.imageCount) 장"
            self.collectionView.reloadData()
    }
    
    // 문자 추출 함수
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

extension AlbumViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // 셀 개수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        if collectionView.tag == 1 {
            return self.categoryCount
        } else {
            return self.imageCount
        }
    }
    
    // 셀 내용 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView.tag == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as?
                    CategoryCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            // 셀 컨텐트 뷰에 버튼 추가
            cell.addSubview(self.categoryButtonArray[indexPath.row])
            
            // 셀 제약 조건 설정
            self.categoryButtonArray[indexPath.row].translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                // 셀 카테고리 버튼 제약조건
                self.categoryButtonArray[indexPath.row].centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                self.categoryButtonArray[indexPath.row].centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
            ])
            
            // 프레임값 적용
            view.layoutIfNeeded()
            
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCollectionViewCell", for: indexPath) as?
                    AlbumCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.imageView.contentMode = .scaleToFill // cell에 이미지가 꽉차도록 표시
            cell.phid = self.ImageArray[indexPath.row].phid // phid 설정
            cell.url = self.ImageArray[indexPath.row].imageUrl // cell에 url 값 설정
            cell.category = self.ImageArray[indexPath.row].category_name // cell에 카테고리 이름 설정
            cell.imageName = extractValues(from : cell.url) // 이미지 이름 설정

            // 받아온 url을 통해 캐시키 생성
            let cacheKey = NSString(string: cell.url)
            
            // 만약 저장된 캐시데이터가 있다면 해당 데이터로 이미지 설정
            if let cachedImage = AlbumImageCacheManager.shared.object(forKey: cacheKey) {
                DispatchQueue.main.async {
                    cell.imageView.image = cachedImage
                }
            } else { // 만약 캐시데이터가 없다면
                DispatchQueue.global().async { // 멀티쓰레드 사용
                    let url = URL(string: cell.url)
                    // url 통해서 이미지 데이터 다운로드
                    if let data = try? Data(contentsOf: url!) {
                        // 이미지 설정
                        DispatchQueue.main.async {
                            cell.imageView.image = UIImage(data: data)
                        }
                        // 키, 밸류 값으로 캐시값 저장
                        AlbumImageCacheManager.shared.setObject(UIImage(data: data)!, forKey: cacheKey)
                    }
                }
            }
            return cell
        }
    }
    
    
    // 셀 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        if collectionView.tag == 1 {
            let width = self.categoryButtonArray[indexPath.row].frame.size.width
            let height = self.categoryButtonArray[indexPath.row].frame.size.height
            return CGSize(width: width, height: height) // 셀당 너비, 높이 설정
        }
        else {
            let width = UIScreen.main.bounds.width // 컬렉션 뷰 너비값
            let itemsPerRow: CGFloat = 3 // 각 행의 아이템 수
            let widthPadding = ImageSectionInsets.left * (itemsPerRow + 1) // 너비의 총 여백 공간
            let cellWidth = (width - widthPadding) / itemsPerRow // 셀당 너비
            let cellHeight = cellWidth // 셀당 높이 = 셀당 너비
            return CGSize(width: cellWidth, height: cellHeight) // 셀당 너비, 높이 설정
        }
    }
        
    // section inset 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView.tag == 1 {
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
        else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    // 셀당 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView.tag == 1 {
            return categorySectionInsets.right
        }
        else {
            return ImageSectionInsets.left
        }
        
    }
    
    // 라인당 간격 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView.tag == 1 {
            return categorySectionInsets.bottom
        }
        else {
            return ImageSectionInsets.left
        }
    }
    
    // 특정 셀(이미지)가 눌렸을 때 -> 이미지 자세히(원본) 보기
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("click index=\(indexPath.row)")
        
        if collectionView.tag == 1 {
            return
        }
        else {
            // 현재 셀 가져오기
            guard let currentCell = collectionView.cellForItem(at: indexPath) as? AlbumCollectionViewCell else {
                return
            }
            
            // 선택된 이미지 url 값 저장
            self.currentImageUrl = currentCell.url
            
            // 자세히 보기 화면 전환
            guard let popupVC = self.storyboard?.instantiateViewController(identifier: "popupVC") as? AlbumImagePopUpController else {return}
            popupVC.modalPresentationStyle = .overFullScreen
            popupVC.modalTransitionStyle = .crossDissolve
            
            // 이미지 넘겨주기
            guard let currentCellImage = currentCell.imageView.image else {return}
            popupVC.image = currentCellImage
            popupVC.phid = currentCell.phid
            popupVC.category = currentCell.category
            popupVC.imageName = currentCell.imageName
            
            // 화면 전환
            self.present(popupVC, animated: true, completion: nil)
        }
    }
}

// 카테고리 컬렉션 뷰 셀
class CategoryCollectionViewCell : UICollectionViewCell {
}

// 앨범 컬렉션 뷰 셀
class AlbumCollectionViewCell : UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    var phid : Int!
    var url : String!
    var category : String!
    var imageName : (String?, String?, String?, String?)
}

// 화면 나타날때 카테고리 및 이미지 불러오는 함수 설정
// 사진 삭제시 변경시 notification 이용하여 카테고리 다시 불러오기 및 사진 다시 불러오기
// 사진 카테고리 변경시 notification 이용하여 카테고리 다시 불러오기 및 사진 다시 불러오기

