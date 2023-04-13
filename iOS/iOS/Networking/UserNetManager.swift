//
//  UserNetManager.swift
//  iOS
//
//  Created by 이정동 on 2023/02/02.
//

import Foundation

class UserNetManager {
    static let shared = UserNetManager()
    private init() {}
    
    func loginUser(user: User, completion: @escaping (User)->()) {
        guard let url = URL(string: "\(Bundle.main.REST_API_URL)/api/user/login") else {
            print("URL Error")
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(user) else {
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

            // HTTP 200번대 정상코드인 경우만 다음 코드로 넘어감
            guard let response = res as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            
            if let safeData = data {
                do {
                    let decodedData = try JSONDecoder().decode(User.self, from: safeData)
                    dump(decodedData)
                    completion(decodedData)
                } catch {
                    print("Decode Error")
                }
            }
            
        }.resume()
    }
    
    // 사용자 삭제
    func deleteUserData(uid: Int, completion: @escaping ()->()) {
        guard let url = URL(string: "\(Bundle.main.REST_API_URL)/api/user/delete/\(uid)") else { return }
        
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
        }.resume()
    }
}
