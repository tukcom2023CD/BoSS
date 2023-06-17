//
//  SearchPlaceViewController.swift
//  iOS
//
//  Created by 이정동 on 2023/02/06.
//

import UIKit
import GooglePlaces

class SearchPlaceViewController: UIViewController {

    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var visitDate: String!
    var scheduleId: Int!
    var localLabel:String!
    override func viewDidLoad() {
        super.viewDidLoad()
   
        // Do any additional setup after loading the view.
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        // 한국 내 장소로 검색 결과를 제한하기 위해 필터
                let filter = GMSAutocompleteFilter()
                filter.country = "KR"
        
        // 생성한 필터를 autocomplete 결과 뷰 컨트롤러에 적용합니다.
               resultsViewController?.autocompleteFilter = filter
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        navigationItem.searchController = searchController

        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchBar.showsScopeBar = false
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
    }
  
}


extension SearchPlaceViewController: GMSAutocompleteResultsViewControllerDelegate {
    
    
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        
        print(place)
        
        let placeDetailVC = storyboard?.instantiateViewController(withIdentifier: "PlaceDetailVC") as! PlaceDetailViewController
        placeDetailVC.place = place
        placeDetailVC.visitDate = visitDate
        placeDetailVC.scheduleId = scheduleId
        navigationController?.pushViewController(placeDetailVC, animated: true)
        
    }
    
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                              didAutocompleteWith predictions: [GMSAutocompletePrediction]) {
           let filteredPredictions = predictions.filter {
               $0.attributedFullText.string.localizedCaseInsensitiveContains(localLabel)
           }
       
//           resultsController.autocompletePredictions = filteredPredictions
       }
}
