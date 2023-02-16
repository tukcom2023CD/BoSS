//
//  ResultsTableController.swift
//  iOS
//
//  Created by JunHee on 2023/02/14.
//

import UIKit

class ResultTableController : UITableViewController {

    // 현재 스콥
    var currentScope : [String]!
    // 전체 카테고리 저장 배열
    let categoryArray: [String] = ["인간", "동물", "자연", "건축물"]
    // 검색된 카테고리 저장 배열
    var searchedCategoryArray: [String] = []
    // 유저가 선택한 카테고리 배열
    var userCheckedCategory : [String] = []
    // 유저가 선택해제한 카테고리 배열
    var userCheckedCancelVategory : [String] = []
    // 검색된 카테고리가 1개 이상 존재하는 경우 = 0개 가 아닐때
    var hasSearchedCategory: Bool {
        return !(searchedCategoryArray.count == 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentScope = categoryArray // 초기 스콥은 전체 카테고리 배열로 설정
    }
    
    // 셀 수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // hasSearchedCategory가 참이면 = searchedCategoryArray에 카테고리가 존재한다면
        if self.hasSearchedCategory {
            return self.searchedCategoryArray.count
            
        } else { // 나머지인경우 = searchedCategoryArray에 카테고리가 없다면
            return self.currentScope.count
        }
    }
    
    // 셀 선택시
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 선택된 셀 가져오기
        guard let currentCell = tableView.cellForRow(at: indexPath) as? searchResultCell else { return }
        // 선택된 카테고리가 사용자 선택 카테고리 배열에 이미 존재 하는 경우 해당 카테고리 제거
        if (userCheckedCategory.contains(currentCell.categoryLabel.text!)) {
            let index : Int = userCheckedCategory.firstIndex(of: currentCell.categoryLabel.text!)!
            userCheckedCategory.remove(at: index)
            userCheckedCancelVategory.append(currentCell.categoryLabel.text!) // 사용자 선택취소 카테고리 배열에 추가
            
        } else {
            userCheckedCategory.append(currentCell.categoryLabel.text!) // 유저 선택 카테고리 배열에 추가
            // 선택된 카테고리가 사용자 선택 취소 카테고리 배열에 이미 존재 하는 경우 해당 카테고리 제거
            if (userCheckedCancelVategory.contains(currentCell.categoryLabel.text!)) {
                let index : Int = userCheckedCategory.firstIndex(of: currentCell.categoryLabel.text!)!
                userCheckedCategory.remove(at: index)
            }
            
            
            
        }
        tableView.reloadData() // 뷰 업데이트 -> 기존 뷰를 가져온 상태에서 추가적으로 변경
    }
    
    // 셀 구성
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 커스텀 셀 불러오기
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath) as? searchResultCell else { return UITableViewCell() }
    
        // 선택시 색깔 변경 없음
        cell.selectionStyle = .none
        
        // 체크박스 설정
        cell.checkboxView.layer.borderColor = UIColor.lightGray.cgColor
        cell.checkboxView.layer.borderWidth = 0.2
        cell.checkboxView.layer.cornerRadius = 5
            
        // hasSearchedCategory가 참이면 = searchedCategoryArray에 카테고리가 존재한다면
        if self.hasSearchedCategory {
            // 카테고리 이름 표시
            cell.categoryLabel?.text = self.searchedCategoryArray[indexPath.row]
            // 만약 사용자가 선택한 카테고리 배열에 포함되어있는 카테고리인 경우 체크박스 표시
            if (userCheckedCategory.contains(self.searchedCategoryArray[indexPath.row])) {
                cell.checkboxImage.image = UIImage(named: "check.png")
            } else { // 배열에 포함되어있지 않다면 이미지 nil
                cell.checkboxImage.image = nil
            }
        }
        else { // 나머지인경우 = searchedCategoryArray에 카테고리가 없다면
            // 카테고리 이름 표시
            cell.categoryLabel?.text = self.currentScope[indexPath.row]
            // 만약 사용자가 선택한 카테고리 배열에 포함되어있는 카테고리인 경우 체크박스 표시
            if (userCheckedCategory.contains(self.currentScope[indexPath.row])) {
                cell.checkboxImage.image = UIImage(named: "check.png")
            } else { // 배열에 포함되어있지 않다면 이미지 nil
                cell.checkboxImage.image = nil
            }
        }
        return cell
    }
    
    // 카테고리 전체 선택 버튼
    @IBAction func selectTotalButtonPressed(_ sender: UIButton) {
        if hasSearchedCategory == true { // 검색결과가 있는 경우
            if currentScope == categoryArray { // 현재 스콥이 전체인 경우
                for category in searchedCategoryArray { // 검색된 각 카테고리가
                    if !(userCheckedCategory.contains(category)) { // 선택 카테고리 배열에 포함X 라면
                        userCheckedCategory.append(category) // 선택된 카테고리 배열에 포함
                    }
                }
            }
            else if currentScope == userCheckedCategory { // 현재 스콥이 선택됨인 경우
                for category in searchedCategoryArray { // 검색된 각 카테고리가
                    if !(userCheckedCategory.contains(category)) { // 선택 카테고리 배열에 포함X 라면
                        userCheckedCategory.append(category) // 선택된 카테고리 배열에 포함
                    }
                }
            }
        }
        else if hasSearchedCategory == false { // 검색결과가 없는 경우
            if currentScope == categoryArray { // 현재 스콥이 전체인경우
                userCheckedCategory = categoryArray // 모든 카테고리 체크
            }
            else if currentScope == userCheckedCategory { // 현재 스콥이 선택됨인 경우
                userCheckedCategory =
            }
        }
        self.tableView.reloadData() // 테이블뷰 리로드
    }
    
    // 카테고리 전체 해제 버튼
    @IBAction func cancelTotalButtonPressed(_ sender: UIButton) {
        
        
        
        
    }
}

// 카테고리 셀 클래스
class searchResultCell : UITableViewCell {
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var checkboxView: UIView!
    @IBOutlet weak var checkboxImage: UIImageView!
}

