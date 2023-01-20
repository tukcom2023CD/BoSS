//
//  OCRNetManager.swift
//  iOS
//
//  Created by 이정동 on 2023/01/19.
//

import Foundation
import Alamofire

// Naver Clova OCR API 호출을 위한 싱글톤 패턴 클래스
class OCRNetManager {
    static let shared = OCRNetManager()
    private init() {}
    
    // API 호출 코드
    /// - parameter image: Receipt image
    /// - parameter completion: ReceiptData를 이용한 작업
    func requestReceiptData(image: UIImage, completion: @escaping (ReceiptData)->()) {
        
        let url = Bundle.main.OCR_API_URL
        let secretKey = Bundle.main.OCR_API_KEY

        let headers: HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "X-OCR-SECRET" : secretKey
        ]

        let file = image.pngData()!
        let requestId = UUID().uuidString
        let timeStamp = Date().timeIntervalSinceReferenceDate / 10
        let message = "{\"version\": \"V2\",\"requestId\": \"\(requestId)\",\"timestamp\": \(timeStamp),\"images\": [{ \"format\": \"png\", \"name\": \"demo\" }]}"
        
        AF.upload(multipartFormData: { (multipartFormData) in

            multipartFormData.append(file, withName: "file", fileName: "test.png", mimeType: "multipart/form-data")

            multipartFormData.append(message.data(using: .utf8)!, withName: "message")


        }, to: url, method: .post, headers: headers).responseJSON { (response) in

            guard let statusCode = response.response?.statusCode else { return }
            print(statusCode)

            guard let safeData = response.data else { return }

            let decodedData = try? JSONDecoder().decode(OCRResult.self, from: safeData)
            guard let ocrResult = decodedData else { return }
            
            let receiptData = ocrResult.images[0].receipt.receiptData
            dump(receiptData)
            
            completion(receiptData)
            
        }
    }
}
