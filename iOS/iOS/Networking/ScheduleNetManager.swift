//
//  ScheduleNetManager.swift
//  iOS
//
//  Created by 이정동 on 2023/01/31.
//

import Foundation

class ScheduleNetManager {
    
    static let shared = ScheduleNetManager()
    private init() {}
    
    func create(schedule: Schedule, completion: @escaping ()->()) {
        
        guard let url = URL(string: "\(Bundle.main.REST_API_URL)/api/schedule/create") else { return }
        
        guard let jsonData = try? JSONEncoder().encode(schedule) else {
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
            
            // 원하는 모델이 있다면, JSONDecoder로 decode코드로 구현 ⭐️
            print(String(decoding: safeData, as: UTF8.self))
        }.resume()
    }
}
