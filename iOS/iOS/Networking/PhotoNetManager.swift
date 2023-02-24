//
//  PhotoNetManager.swift
//  iOS
//
//  Created by 이정동 on 2023/02/21.
//

import Foundation
import UIKit
import Alamofire

class PhotoNetManager {
    static let shared = PhotoNetManager()
    private init() {}
    
    func create(uid: Int, sid: Int, pid: Int, image: UIImage, completion: @escaping()->()) {
        let urlKey = Bundle.main.getSecretKey(key: "REST_API_URL")
        let url = "\(urlKey)/api/photo/create/\(uid)/\(sid)/\(pid)"
        
        let headers: HTTPHeaders = [ "Content-Type" : "multipart/form-data" ]

        let file = image.pngData()!
        
        // 멀티파트 통신
        AF.upload(multipartFormData: { (multipartFormData) in

            multipartFormData.append(file, withName: "file", fileName: "test.png", mimeType: "multipart/form-data")

        }, to: url, method: .post, headers: headers).responseJSON { (response) in

            guard let statusCode = response.response?.statusCode else { return }
            

            guard statusCode == 200 else {
                print(statusCode)
                return
            }
            
            completion()
            
        }
    }
    
    func read(uid: Int, pid: Int, completion: @escaping ([Photo])->()) {
        guard let url = URL(string: "\(Bundle.main.REST_API_URL)/api/photo/read/\(uid)/\(pid)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, res, err in
            
            guard err == nil else {
                print("Error: error calling POST")
                print(err)
                return
            }

            // HTTP 200번대 정상코드인 경우만 다음 코드로 넘어감
            guard let response = res as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            
            if let safeData = data {
                do {
                    let decodedData = try JSONDecoder().decode(PhotoData.self, from: safeData)
                    dump(decodedData)
                    completion(decodedData.photos)
                } catch {
                    print("Decode Error")
                }
            }
            
        }.resume()
    }
    
    // 특정 유저의 모든 사진
    func read(uid: Int, completion: @escaping ([Photo])->()) {
        guard let url = URL(string: "\(Bundle.main.REST_API_URL)/api/photo/read/\(uid)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, res, err in
            
            guard err == nil else {
                print("Error: error calling POST")
                print(err)
                return
            }

            // HTTP 200번대 정상코드인 경우만 다음 코드로 넘어감
            guard let response = res as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            
            if let safeData = data {
                do {
                    let decodedData = try JSONDecoder().decode(PhotoData.self, from: safeData)
                    dump(decodedData)
                    completion(decodedData.photos)
                } catch {
                    print("Decode Error")
                }
            }
            
        }.resume()
    }
}
