//
//  AlbumSearchTableViewController.swift
//  iOS
//
//  Created by JunHee on 2023/02/14.
//

import UIKit

class AlbumSearchViewController : UIViewController {
    
    // 카테고리 배열
    let categoryArray = ["인간", "동물", "자연", "건축물"]
    // 검색에 의해 필터링된 카테고리 배열
    var filteredArr: [String] = []
    // 필터링에대한 조건
    var isFiltering: Bool {
            let searchController = self.navigationItem.searchController
            let isActive = searchController?.isActive ?? false
            let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
            return isActive && isSearchBarHasText // SearchController활성화 + Search바에 텍스트가 입력됨
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension AlbumSearchViewController : UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        self.filteredArr = self.categoryArray.filter { $0.localizedCaseInsensitiveContains(text) }
        dump(filteredArr)
        
        // self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if self.isFiltering {
            cell.textLabel?.text = self.filteredArr[indexPath.row]
        } else {
            cell.textLabel?.text = self.categoryArray[indexPath.row]
        }
        return cell
    }
}
