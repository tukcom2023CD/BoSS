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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        
//        let subView = UIView(frame: CGRect(x: 0, y: 120.0, width: 350.0, height: 45.0))
//
//        subView.addSubview((searchController?.searchBar)!)
//        view.addSubview(subView)
        
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
        //searchController?.isActive = false
        // Do something with the selected place.
        print(place)
        let placeDetailVC = storyboard?.instantiateViewController(withIdentifier: "PlaceDetailVC") as! PlaceDetailViewController
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
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
