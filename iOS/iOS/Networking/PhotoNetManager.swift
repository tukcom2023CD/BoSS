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
    
    func create(uid: Int, sid: Int, pid: Int, image: [UIImage], completion: @escaping()->()) {
        let urlKey = Bundle.main.getSecretKey(key: "REST_API_URL")
        let url = "\(urlKey)/api/photo/create/\(uid)/\(sid)/\(pid)"
        
        let headers: HTTPHeaders = [ "Content-Type" : "multipart/form-data" ]
        
        // 멀티파트 통신
        AF.upload(multipartFormData: { (multipartFormData) in
            for i in 0..<image.count {
                let file = image[i].pngData()!
                multipartFormData.append(file, withName: "file\(i)", fileName: "test.png", mimeType: "multipart/form-data")
            }
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
                    // dump(decodedData)
                    completion(decodedData.photos)
                } catch {
                    print("Decode Error")
                }
            }
            
        }.resume()
    }
    
    // 특정 유저의 특정 카테고리 사진 불러오기
    func read(uid: Int, category : String, completion: @escaping ([PhotoWithCategory])->()) {
        var encoded_category = ""
        encoded_category = category.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! // 한글 인코딩
        guard let url = URL(string: "\(Bundle.main.REST_API_URL)/api/photo/read/\(uid)/\(encoded_category)") else { return }
        
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
                    let decodedData = try JSONDecoder().decode(PhotoWithCategoryData.self, from: safeData)
                    // dump(decodedData)
                    completion(decodedData.PhotoWithCategories)
                } catch {
                    print("Decode Error")
                }
            }
        }.resume()
    }
    
    // 특정 유저의 특정 사진 삭제
    func delete(imageName: (String?, String?, String?, String?), completion: @escaping ()->()) {
        
        let fileName = imageName.3
        let xValue = fileName!.split(separator: ".")[0]
        
        guard let url = URL(string: "\(Bundle.main.REST_API_URL)/api/photo/delete/\(imageName.0!)/\(imageName.1!)/\(imageName.2!)/\(xValue)") else { return }
        
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
            
            completion()
        
        }.resume()
    }
}
