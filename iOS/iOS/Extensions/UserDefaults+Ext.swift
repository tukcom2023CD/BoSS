//
//  UserDefaults+Ext.swift
//  iOS
//
//  Created by 이정동 on 2023/02/01.
//

import Foundation

extension UserDefaults {
    func setLoginUser(user: User) {
        let encoder = JSONEncoder()
        
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.setValue(encoded, forKey: UserDefaultsKey.key)
        }
    }
    
    func getLoginUser() -> User? {
        
        guard let savedData = UserDefaults.standard.object(forKey: UserDefaultsKey.key) as? Data else { return nil }
        
        let decoder = JSONDecoder()
        
        guard let savedObject = try? decoder.decode(User.self, from: savedData) else { return nil }
        
        return savedObject
    }
    
    func unsetLoginUser() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.key)
    }
}
