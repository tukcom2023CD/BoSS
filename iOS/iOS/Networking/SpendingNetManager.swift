//
//  SpendingNetManager.swift
//  iOS
//
//  Created by 이정동 on 2023/02/21.
//

import Foundation

class SpendingNetManager {
    static let shared = SpendingNetManager()
    private init() {}
    
    func create(spendings: [Spending], completion: @escaping ()->()) {
        guard let url = URL(string: "\(Bundle.main.REST_API_URL)/api/spending/create") else { return }
        
        let spendingData = SpendingData(spendings: spendings)
        
        guard let jsonData = try? JSONEncoder().encode(spendingData) else {
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
    
    func read(pid: Int, completion: @escaping ([Spending])->()) {
        guard let url = URL(string: "\(Bundle.main.REST_API_URL)/api/spending/read/\(pid)") else { return }
        
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
                    let decodedData = try JSONDecoder().decode(SpendingData.self, from: safeData)
                    dump(decodedData)
                    completion(decodedData.spendings)
                } catch {
                    print("Decode Error")
                }
            }
            
        }.resume()
    }
}
