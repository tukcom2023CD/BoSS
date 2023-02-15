//
//  ResultsTableController.swift
//  iOS
//
//  Created by JunHee on 2023/02/14.
//

import UIKit

class ResultTableController : UITableViewController {
    
    // 전체 카테고리 저장 배열
    let categoryArray: [String] = ["인간", "동물", "자연", "건축물", "인간", "동물", "자연", "건축물", "인간", "동물", "자연", "건축물", "인간", "동물", "자연", "건축물", "인간", "동물", "자연", "건축물", "인간", "동물", "자연", "건축물"]
    // 검색된 카테고리 저장 배열
    var searchedCategoryArray: [String] = []
    // 검색된 카테고리가 1개 이상 존재하는 경우 = 0개 가 아닐때
    var hasSearchedCategory: Bool {
        return !(searchedCategoryArray.count == 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // hasSearchedCategory가 참이면 = searchedCategoryArray에 카테고리가 존재한다면
        if self.hasSearchedCategory {
            return self.searchedCategoryArray.count
        } else { // 나머지인경우 = searchedCategoryArray에 카테고리가 없다면
            return self.categoryArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        // hasSearchedCategory가 참이면 = searchedCategoryArray에 카테고리가 존재한다면
        if self.hasSearchedCategory {
            cell.textLabel?.text = self.searchedCategoryArray[indexPath.row]
        } else { // 나머지인경우 = searchedCategoryArray에 카테고리가 없다면
            cell.textLabel?.text = self.categoryArray[indexPath.row]
        }
        return cell
    }
}
