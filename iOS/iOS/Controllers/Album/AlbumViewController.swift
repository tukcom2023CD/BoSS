//
//  AlbumViewController.swift
//  iOS
//
//  Created by JunHee on 2023/02/13.
//

import UIKit

class AlbumViewController: UIViewController, UISearchResultsUpdating {
    
    // 서치 리설트 컨트롤러
    var resultTC : ResultTableController!
    // 서치 컨트롤러
    var searchController : UISearchController!
    // 예시 이미지 url
    let imageUrl : String = "https://placeimg.com/480/480/arch"
    // 간격 수치 설정
    let sectionInsets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    
//    필터링에대한 조건
//    var isFiltering: Bool {
//            let searchController = self.navigationItem.searchController
//            let isActive = searchController?.isActive ?? false
//            let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
//            return isActive && isSearchBarHasText // SearchController활성화 + Search바에 텍스트가 입력됨
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 서치 리설트 컨트롤러 인스턴스화
        resultTC = self.storyboard?.instantiateViewController(withIdentifier: "ResultTC") as? ResultTableController
        
        // 서치 컨트롤러 설정 함수 호출
        setSearchController()
    }
    
    // 서치 컨트롤러 설정 함수
    func setSearchController () {
        self.searchController = UISearchController(searchResultsController: self.resultTC)
        self.searchController.searchBar.placeholder = "카테고리 검색" // placeholder 설정
        self.searchController.obscuresBackgroundDuringPresentation = false // 검색창 클릭시 화면 어둡게 하는 설정 false
        self.searchController.searchResultsUpdater = self // 검색결과 변경을 담당하는 VC 선택
        self.navigationItem.title = "앨범" // 네비게이션 아이템 타이틀
        self.navigationItem.searchController = self.searchController // 네비게이션 아이템의 searchController 지정
        self.searchController.showsSearchResultsController = true
    }
    
    // 검색 결과 업데이트 함수 (문자열을 검색창에 타이핑할때마다)
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return } // 문자열을 가져옴
        self.resultTC.searchedCategoryArray = self.resultTC.categoryArray.filter
        {$0.localizedCaseInsensitiveContains(text)} // categoryArray 배열에서 해당 문자열로 검색하여  searchedCategoryArray저장 
        dump(self.resultTC.searchedCategoryArray) // searchedCategoryArray 출력
        self.resultTC.tableView.reloadData() // 테이블뷰 다시 로드
    }
}

extension AlbumViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // 셀 개수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    // 셀 내용 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCollectionViewCell", for: indexPath) as?
                AlbumCollectionViewCell else {
            return UICollectionViewCell()
        }
        // 이미지 설정
        cell.imageView.contentMode = .scaleToFill
        let url = URL(string: imageUrl)
        let data = try! Data(contentsOf: url!)
        cell.imageView.image = UIImage(data: data)
        return cell
    }
    // 셀 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width // 컬렉션 뷰 너비값
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
        // 자세히 보기 화면 전환
        guard let popupVC = self.storyboard?.instantiateViewController(identifier: "popupVC") as? AlbumImagePopUpController else {return}
        popupVC.modalPresentationStyle = .overFullScreen
        popupVC.modalTransitionStyle = .crossDissolve // 화면 교차 방식
        
        // 이미지 넘겨주기
        guard let currentCellImage = currentCell.imageView.image else {return}
        popupVC.image = currentCellImage
        
        // 화면 전환
        self.present(popupVC, animated: true)
    }
}

// 컬렉션 뷰 셀 클래스
class AlbumCollectionViewCell : UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
}
