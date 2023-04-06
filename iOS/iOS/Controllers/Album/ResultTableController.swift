//
//  ResultsTableController.swift
//  iOS
//
//  Created by JunHee on 2023/02/14.
//

import UIKit

class ResultTableController : UITableViewController {
    
    // 현재 스콥
    var currentScope = "total"
    // 전체 카테고리 배열
    var totalCategoryArray: [String] = []
    // 선택된 카테고리 배열
    var userSelectedCategory : [String] = []
    // 검색된 카테고리 배열
    var searchedCategoryArray: [String] = []
    // 검색된 카테고리 존재 여부
    var hasSearchedCategory: Bool {
        return !(searchedCategoryArray.count == 0)
    }
    
    // 유저가 선택해제한 카테고리 임시 저장 배열
    var userSavedCheckedCategory : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestCaegoryTypeData() // 모든 카테고리 불러옴
    }
    
    // 카테고리 종류 불러오는 함수
    func requestCaegoryTypeData() {
        CategoryNetManager.shared.read() { categoryTypes in
            for categoryType in categoryTypes {
                if !self.totalCategoryArray.contains(categoryType.category_name!) {
                    self.totalCategoryArray.append(categoryType.category_name!)
                }
            }
            DispatchQueue.main.async {
                self.userSelectedCategory = self.totalCategoryArray // 모든 카테고리를 선택됨으로
                // 카테고리 로딩이 완료됨을 알림
                NotificationCenter.default.post(name: NSNotification.Name("CategoryLoadComplete"), object: self)
                self.tableView.reloadData()
            }
        }
    }
    
    // 카테고리 종류 다시 불러오는 함수
    func reloadCategories() {
        CategoryNetManager.shared.read() { categoryTypes in
            for categoryType in categoryTypes {
                if !self.totalCategoryArray.contains(categoryType.category_name!) {
                    self.totalCategoryArray.append(categoryType.category_name!)
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // 셀 수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // hasSearchedCategory가 참이면 = searchedCategoryArray에 카테고리가 존재한다면
        if self.hasSearchedCategory {
            return self.searchedCategoryArray.count
            
        } else { // 나머지인경우
            if currentScope == "total" {
                return self.totalCategoryArray.count
            } else {
                return self.userSelectedCategory.count
            }
        }
    }
    
    // 셀 구성
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath) as? searchResultCell else { return UITableViewCell() } // 커스텀 셀 불러오기
        
        cell.selectionStyle = .none // 선택시 색깔 변경 없음
        
        // 체크박스 설정
        cell.checkboxView.layer.borderColor = UIColor.lightGray.cgColor
        cell.checkboxView.layer.borderWidth = 0.2
        cell.checkboxView.layer.cornerRadius = 5
        
        // hasSearchedCategory가 참이면
        if self.hasSearchedCategory {
            // 카테고리 이름 표시
            cell.categoryLabel?.text = self.searchedCategoryArray[indexPath.row]
            // 만약 사용자가 선택한 카테고리 배열에 포함되어있는 카테고리인 경우 체크박스 표시
            if (userSelectedCategory.contains(self.searchedCategoryArray[indexPath.row])) {
                cell.checkboxImage.image = UIImage(named: "check.png")
            } else { // 배열에 포함되어있지 않다면 이미지 nil
                cell.checkboxImage.image = nil
            }
        }
        else { // 나머지인경우
            if currentScope == "total" {
                // 카테고리 이름 표시
                cell.categoryLabel?.text = self.totalCategoryArray[indexPath.row]
                // 만약 사용자가 선택한 카테고리 배열에 포함되어있는 카테고리인 경우 체크박스 표시
                if (userSelectedCategory.contains(self.totalCategoryArray[indexPath.row])) {
                    cell.checkboxImage.image = UIImage(named: "check.png")
                } else { // 배열에 포함되어있지 않다면 이미지 nil
                    cell.checkboxImage.image = nil
                }
            } else {
                // 카테고리 이름 표시
                cell.categoryLabel?.text = self.userSelectedCategory[indexPath.row]
                cell.checkboxImage.image = UIImage(named: "check.png")
                }
            }
        return cell
    }
    
    // 셀 선택시
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currentCell = tableView.cellForRow(at: indexPath) as? searchResultCell else { return } // 선택된 셀 가져오기
        
        // 선택된 카테고리가 사용자 선택 카테고리 배열에 이미 존재 하는 경우 해당 카테고리 제거
        if (userSelectedCategory.contains(currentCell.categoryLabel.text!)) {
            let index : Int = userSelectedCategory.firstIndex(of: currentCell.categoryLabel.text!)!
            userSelectedCategory.remove(at: index)
        } else {
            userSelectedCategory.append(currentCell.categoryLabel.text!) // 유저 선택 카테고리 배열에 추가
        }
        tableView.reloadData()
    }
    
    // 카테고리 전체 선택 버튼
    @IBAction func selectTotalButtonPressed(_ sender: UIButton) {
        if hasSearchedCategory == true { // 검색결과가 있는 경우
            if currentScope == "total" { // 현재 스콥이 전체인 경우
                for category in searchedCategoryArray { // 검색된 각 카테고리가
                    if !(userSelectedCategory.contains(category)) { // 선택 카테고리 배열에 포함X 라면
                        userSelectedCategory.append(category) // 선택된 카테고리 배열에 포함
                    }
                }
            }
            else if currentScope == "select" { // 현재 스콥이 선택됨인 경우
                for category in searchedCategoryArray { // 검색된 각 카테고리가
                    if !(userSelectedCategory.contains(category)) { // 선택 카테고리 배열에 포함X 라면
                        userSelectedCategory.append(category) // 선택된 카테고리 배열에 포함
                    }
                }
            }
        }
        else if hasSearchedCategory == false { // 검색결과가 없는 경우
            if currentScope == "total" { // 현재 스콥이 전체인경우
                userSelectedCategory = totalCategoryArray // 모든 카테고리 체크
            }
        }
        self.tableView.reloadData() // 테이블뷰 리로드
    }
    
    // 카테고리 전체 해제 버튼
    @IBAction func cancelTotalButtonPressed(_ sender: UIButton) {
        if hasSearchedCategory == true { // 검색결과가 있는 경우
            if currentScope == "total" { // 현재 스콥이 전체인 경우
                for category in searchedCategoryArray { // 검색된 각 카테고리가
                    if (userSelectedCategory.contains(category)) { // 선택 카테고리 배열에 포함되어 있다면
                        let index : Int = userSelectedCategory.firstIndex(of: category)!
                        userSelectedCategory.remove(at: index) // 제거
                    }
                }
            }
            else if currentScope == "select" { // 현재 스콥이 선택됨인 경우
                for category in searchedCategoryArray { // 검색된 각 카테고리가
                    if (userSelectedCategory.contains(category)) { // 선택 카테고리 배열에 포함되어 있다면
                        let index : Int = userSelectedCategory.firstIndex(of: category)!
                        userSelectedCategory.remove(at: index) // 제거
                    }
                }
            }
        }
        else if hasSearchedCategory == false { // 검색결과가 없는 경우
            if currentScope == "total" { // 현재 스콥이 전체인경우
                userSelectedCategory = [] // 모든 카테고리 체크해체
            }
            else if currentScope == "select" { // 현재 스콥이 선택됨인 경우
                userSelectedCategory = [] // 모든 카테고리 체크해제
            }
        }
        self.tableView.reloadData() // 테이블뷰 리로드
    }
}

// 카테고리 셀 클래스
class searchResultCell : UITableViewCell {
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var checkboxView: UIView!
    @IBOutlet weak var checkboxImage: UIImageView!
}
