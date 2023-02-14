//
//  AlbumViewController.swift
//  iOS
//
//  Created by JunHee on 2023/02/13.
//

import UIKit

class AlbumViewController: UIViewController {
    
    // 예시 이미지 url
    let imageUrl : String = "https://placeimg.com/480/480/arch"
    // 간격 수치 설정
    let sectionInsets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    // 카테고리 배열
    let categoryArray = ["인간", "동물", "자연", "건축물"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchBar()
    }
    
    // 서치바 생성 및 설정 함수
    func setSearchBar () {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "카테고리 검색"
        searchController.searchBar.scopeButtonTitles = categoryArray
        searchController.obscuresBackgroundDuringPresentation = false
        // self.navigationItem.title = "앨범" // 네비게이션 아이템 타이틀
        self.navigationItem.searchController = searchController
    }
}

// 컬렉션 뷰 셀 클래스
class AlbumCollectionViewCell : UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
}
