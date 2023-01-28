//
//  PlaceDataManager.swift
//  iOS
//
//  Created by 박다미 on 2023/01/28.
//
import UIKit

class PlaceDataManager {
    
    private var placeDataArray: [SearchPlace] = []
    
    func makePlaceData() {
        placeDataArray = [
            SearchPlace(placeImage: UIImage(named: "tripimg"), placeName: "전주", placeSubtitle: "전주, 군산" ),
            SearchPlace(placeImage: UIImage(named: "tripimg"), placeName: "인천", placeSubtitle: "인천, 강화도" ),
            SearchPlace(placeImage: UIImage(named: "tripimg"), placeName: "부산", placeSubtitle: "부산" ),
            SearchPlace(placeImage: UIImage(named: "tripimg"), placeName: "태안", placeSubtitle: "태안, 당진, 서산" ),
            SearchPlace(placeImage: UIImage(named: "tripimg"), placeName: "전주", placeSubtitle: "전주, 군산" ),
            SearchPlace(placeImage: UIImage(named: "tripimg"), placeName: "인천", placeSubtitle: "인천, 강화도" ),
            SearchPlace(placeImage: UIImage(named: "tripimg"), placeName: "부산", placeSubtitle: "부산" ),
            SearchPlace(placeImage: UIImage(named: "tripimg"), placeName: "태안", placeSubtitle: "태안, 당진, 서산" )
        ]
    }
    
    func getPlaceData() -> [SearchPlace] {
        return placeDataArray
    }
}
