//
//  Constants.swift
//  iOS
//
//  Created by 이정동 on 2023/01/23.
//

import Foundation

// Naver Clova OCR API 관련 설정 값
public enum OCRApi {
    static let url = Bundle.main.OCR_API_URL
    static let key = Bundle.main.OCR_API_KEY
}

// SlideView 관련 설정 값
struct SlideViewConstant {
    static let slideViewHeight: CGFloat = 350
    static let cornerRadiusOfSlideView: CGFloat = 20
    static let animationTime: CGFloat = 0.3
}

public enum UserDefaultsKey {
    static let key = "user"
}

// PlacePhotoCollectionViewCell
struct PlacePhotoCVCell {
    static let spacingWitdh: CGFloat = 5
    static let cellRows: CGFloat = 2
    private init() {}
}

struct CustomDateFormatter {
    static let format: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()
}
