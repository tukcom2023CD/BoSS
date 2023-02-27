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
}
