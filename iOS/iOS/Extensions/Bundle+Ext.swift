//
//  Bundle+Ext.swift
//  iOS
//
//  Created by 이정동 on 2023/01/13.
//

import Foundation

extension Bundle {
    // 생성한 .plist 파일 경로 불러오기
    var GOOGLE_API_KEY: String {
        guard let file = self.path(forResource: "SecretKey", ofType: "plist") else { return "" }
        
        // .plist를 딕셔너리로 받아오기
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        
        // 딕셔너리에서 값 찾기
        guard let key = resource["GOOGLE_API_KEY"] as? String else {
            fatalError("GOOGLE_API_KEY error")
        }
        return key
    }
    
    var OCR_API_URL: String {
        guard let file = self.path(forResource: "SecretKey", ofType: "plist") else { return "" }
        
        // .plist를 딕셔너리로 받아오기
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        
        // 딕셔너리에서 값 찾기
        guard let key = resource["OCR_API_URL"] as? String else {
            fatalError("OCR_API_URL error")
        }
        return key
    }
    
    var OCR_API_KEY: String {
        guard let file = self.path(forResource: "SecretKey", ofType: "plist") else { return "" }
        
        // .plist를 딕셔너리로 받아오기
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        
        // 딕셔너리에서 값 찾기
        guard let key = resource["OCR_API_KEY"] as? String else {
            fatalError("OCR_API_KEY error")
        }
        return key
    }
}
