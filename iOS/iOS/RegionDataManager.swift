//
//  RegionDataManager.swift
//  iOS
//
//  Created by 박다미 on 2023/01/29.
//

import UIKit

class RegionDataManager {
    
    private var RegionDataArray: [Region] = []
    
    func makeRegionData() {
        RegionDataArray = [
            Region(placeImage: UIImage(named: "tripimg"), placeName: "전주", placeSubtitle: "전주, 군산" ),
            Region(placeImage: UIImage(named: "tripimg"), placeName: "인천", placeSubtitle: "인천, 강화도" ),
            Region(placeImage: UIImage(named: "tripimg"), placeName: "부산", placeSubtitle: "부산" ),
            Region(placeImage: UIImage(named: "tripimg"), placeName: "태안", placeSubtitle: "태안, 당진, 서산" ),
            Region(placeImage: UIImage(named: "tripimg"), placeName: "전주", placeSubtitle: "전주, 군산" ),
            Region(placeImage: UIImage(named: "tripimg"), placeName: "인천", placeSubtitle: "인천, 강화도" ),
            Region(placeImage: UIImage(named: "tripimg"), placeName: "부산", placeSubtitle: "부산" ),
            Region(placeImage: UIImage(named: "tripimg"), placeName: "태안", placeSubtitle: "태안, 당진, 서산" )
        ]
    }
    
    func getRegionData() -> [Region] {
        return RegionDataArray
    }
}


