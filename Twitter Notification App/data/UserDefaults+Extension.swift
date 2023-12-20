//
//  UserDefaults+Extension.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 11/3/23.
//

import Foundation

extension UserDefaults {

    class var authSession: AuthSessionEntity? {
        get {
            if let data = standard.object(forKey: "\(Bundle.main.bundleIdentifier!).authSession") as? Data {
                do {
                    return try JSONDecoder().decode(AuthSessionEntity.self, from: data)
                } catch {
                    print("ERROR: Error while decode UserDefaults.authSession: \(error.localizedDescription)")
                }
            }
            return nil
        }
        set {
            let key = "\(Bundle.main.bundleIdentifier!).authSession"
            if let newValue = newValue {
                do {
                    let data = try JSONEncoder().encode(newValue)
                    UserDefaults.standard.set(data, forKey: key)
                } catch {
                    print("ERROR: Error while encode UserDefaults.authSession: \(error.localizedDescription)")
                }
            } else {
                standard.removeObject(forKey: key)
            }
            standard.synchronize()
        }
    }
}
