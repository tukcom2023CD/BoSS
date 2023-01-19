//
//  OCRNetManager.swift
//  iOS
//
//  Created by 이정동 on 2023/01/19.
//

import Foundation
import Alamofire


// Naver Clova OCR
class OCRNetManager {
    static let shared = OCRNetManager()
    private init() {}
    
    // API 호출 코드
    // - parameter image: Receipt image
    // - return: Receipt Data
//    func requestReceiptData() {
//        let url = Bundle.main.OCR_API_URL
//        let secretKey = Bundle.main.OCR_API_KEY
//
//        let headers: HTTPHeaders = [
//            "Content-Type" : "multipart/form-data",
//            "X-OCR-SECRET" : secretKey
//        ]
//
//        // let file = 전달받은 이미지.pngData()
//
//        let message = "{\"version\": \"V2\",\"requestId\": \"demo\",\"timestamp\": 1584062336793,\"images\": [{ \"format\": \"png\", \"name\": \"demo\" }]}"
//
//        AF.upload(multipartFormData: { (multipartFormData) in
//
//            multipartFormData.append(file!, withName: "file", fileName: "test.png", mimeType: "multipart/form-data")
//
//            multipartFormData.append(message.data(using: .utf8)!, withName: "message")
//
//
//        }, to: url, method: .post, headers: headers).responseJSON { (response) in
//
//            guard let statusCode = response.response?.statusCode else { return }
//            print(statusCode)
//            print(response.data)
//
//            guard let safeData = response.data else { return }
//
//            let decodedData = try? JSONDecoder().decode(OCRResult.self, from: safeData)
//            dump(decodedData?.images[0].receipt.result)
//        }
//    }
}
