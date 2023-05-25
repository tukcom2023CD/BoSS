//
//  CategoryNetManager.swift
//  iOS
//
//  Created by JunHee on 2023/02/23.
//

import Foundation

class CategoryNetManager {
    static let shared = CategoryNetManager()
    private init() {}
    
    func read(completion: @escaping ([CategoryType])->()) {
        guard let url = URL(string: "\(Bundle.main.REST_API_URL)/api/categorytype/read") else { return }
        
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
                    let decodedData = try JSONDecoder().decode(CategoryTypeData.self, from: safeData)
                    dump(decodedData)
                    completion(decodedData.categoryTypes)
                } catch {
                    print("Decode Error")
                }
            }
            
        }.resume()
    }
    
    // 특정 사진의 카테고리 불러오기
    func read(phid: Int, completion: @escaping ([Category])->()) {
        guard let url = URL(string: "\(Bundle.main.REST_API_URL)/api/categories/read/\(phid)") else { return }
        
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
                    let decodedData = try JSONDecoder().decode(CategoryData.self, from: safeData)
                    dump(decodedData)
                    completion(decodedData.categories)
                } catch {
                    print("Decode Error")
                }
            }
            
        }.resume()
    }
    
    // 카테고리 업데이트
    func update(category: Category, completion: @escaping ()->()) {
        
        guard let url = URL(string: "\(Bundle.main.REST_API_URL)/api/categories/update") else { return }
        
        guard let jsonData = try? JSONEncoder().encode(category) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, res, err in
            
            guard err == nil else {
                print("Error: error calling POST")
                print(err)
                return
            }
            // 옵셔널 바인딩
            guard let safeData = data else {
                print("Error: Did not receive data")
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
    
    // 특정 사진의 모든 카테고리 제거
    func delete(imageName: (String?, String?, String?, String?), completion: @escaping ()->()) {
        
        let fileName = imageName.3
        let phid = fileName!.split(separator: ".")[0]
        
        guard let url = URL(string: "\(Bundle.main.REST_API_URL)/api/categories/delete/\(phid)") else { return }
        
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
