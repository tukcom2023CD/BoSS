//
//  PlaceNetManager.swift
//  iOS
//
//  Created by 이정동 on 2023/01/26.
//

import Foundation

// 여행지 데이터 네트워킹
class PlaceNetManager {
    
    static let shared = PlaceNetManager()
    private init() {}
    
    // 여행 일정에 여행지 추가
    /// - parameter place : 여행지 데이터
    /// - parameter completion : 네트워킹 이후 작업
    func create(place: Place, completion: @escaping ()->()) {
        guard let url = URL(string: "\(Bundle.main.REST_API_URL)/api/place/create") else { return }
        
        guard let jsonData = try? JSONEncoder().encode(place) else {
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
    
    // 여행지 데이터 불러오기
    /// - parameter uid : User ID
    /// - parameter startDate : 시작 날짜
    /// - parameter endDate : 종료 날짜
    /// - parameter completion : Place 데이터를 이용한 화면 작업
    func read(uid: Int, startDate: String?, endDate: String?, completion: @escaping ([Place])->()) {

        var queryString = ""
        if let start = startDate, let end = endDate {
            queryString = "?start=\(start)&end=\(end)"
            //queryString = queryString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! // 한글 인코딩
            print(start)
            print(end)
        }
        
        guard let url = URL(string: "\(Bundle.main.REST_API_URL)/api/places/read/\(uid)\(queryString)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, res, err in
            if err != nil {
                print("Place Net Error")
                return
            }
            
            guard let response = res as? HTTPURLResponse, (200 ..< 299) ~=
                    response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            
            if let safeData = data {
                do {
                    let decodedData = try JSONDecoder().decode(PlaceData.self, from: safeData)
                    dump(decodedData)
                    completion(decodedData.places)
                } catch {
                    print("Decode Error")
                }
            }
        }.resume()
    }
    
    // 여행지 데이터 불러오기
    /// - parameter sid : User ID
    /// - parameter completion : Place 데이터를 이용한 화면 작업
    func read(sid: Int, completion: @escaping ([Place])->()) {
        
        guard let url = URL(string: "\(Bundle.main.REST_API_URL)/api/place/read/\(sid)") else { return }
        print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, res, err in
            if err != nil {
                print("Place Net Error")
                return
            }
            
            guard let response = res as? HTTPURLResponse, (200 ..< 299) ~=
                    response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            
            if let safeData = data {
                do {
                    let decodedData = try JSONDecoder().decode(PlaceData.self, from: safeData)
                    dump(decodedData)
                    completion(decodedData.places)
                } catch {
                    print("Decode Error")
                }
            }
        }.resume()
    }
    
    
    func update(place: Place, completion: @escaping ()->()) {
        guard let url = URL(string: "\(Bundle.main.REST_API_URL)/api/place/update") else { return }
        
        
        guard let jsonData = try? JSONEncoder().encode(place) else {
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
}
