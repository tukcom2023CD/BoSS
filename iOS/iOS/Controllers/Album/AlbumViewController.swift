//
//  AlbumViewController.swift
//  iOS
//
//  Created by JunHee on 2023/02/13.
//

import UIKit

class AlbumViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    // 간격 수치 값 설정 변수
    let sectionInsets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
   
    var totalCategoryArray : [String] = [] // 전체 카테고리 배열
    var selectedCategoryArray : [String] = ["사람", "동물", "기타"] // 선택된 카테고리 배열
    var imageUrlArray : [String] = [] // 이미지 url 배열
    var imageCount : Int = 0  // 표시할 이미지 개수
    var currentImageUrl = "" // 선택된 이미지의 url


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI() // UI 설정
        
        self.navigationItem.title = "앨범" // 네비게이션 아이템 타이틀
        
        loadImagesWithCategory() // 이미지 불러오는 함수 호출
        
        // 앨범 사진에대한 삭제 버튼을 클릭한 경우 삭제후 새로고침 함수 호출
        NotificationCenter.default.addObserver(self, selector: #selector(reloadAfterDeleteImage), name: NSNotification.Name("ImageDeleteButtonPressed"), object: nil)
    }
    
    // UI 설정
    func setUI() {
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 위치 설정
            self.collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            self.collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            self.collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            self.collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
        ])
    }
    
    // 사진 불러오는 함수
    @objc func loadImagesWithCategory() {
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
                        if !(self.imageUrlArray.contains(photo.imageUrl)) {
                            self.imageCount += 1
                            self.imageUrlArray.append(photo.imageUrl)
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
            let index = self.imageUrlArray.firstIndex(of: currentImageUrl)
            self.imageUrlArray.remove(at: index!)
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
        return self.imageCount
    }
    
    // 셀 내용 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCollectionViewCell", for: indexPath) as?
                AlbumCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.imageView.contentMode = .scaleToFill // cell에 이미지가 꽉차도록 표시
        cell.url = imageUrlArray[indexPath.row] // cell에 표시될 사진의 url 설정
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
    
    
    // 셀 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width // 컬렉션 뷰 너비값
        let itemsPerRow: CGFloat = 3 // 각 행의 아이템 수
        let widthPadding = sectionInsets.left * (itemsPerRow + 1) // 너비의 총 여백 공간
        let cellWidth = (width - widthPadding) / itemsPerRow // 셀당 너비
        let cellHeight = cellWidth // 셀당 높이 = 셀당 너비
        return CGSize(width: cellWidth, height: cellHeight) // 셀당 너비, 높이 설정
    }
    
    // 셀당 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    // 라인당 간격 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    // 특정 셀(이미지)가 눌렸을 때 -> 이미지 자세히(원본) 보기
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("click index=\(indexPath.row)")
        
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
        popupVC.imageName = currentCell.imageName
    
        // 화면 전환
        self.present(popupVC, animated: true, completion: nil)
    }
}

// 컬렉션 뷰 셀 클래스
class AlbumCollectionViewCell : UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    var url : String!
    var imageName : (String?, String?, String?, String?)
}
