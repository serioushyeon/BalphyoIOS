//
//  TokenManager.swift
//  Balphyo
//
//  Created by jin on 6/17/24.
//

import Foundation

class TokenManager {
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }

    // UID를 저장하는 메서드
    func saveUid(_ uid: String) {
        userDefaults.set(uid, forKey: "uid")
    }

    // UID를 가져오는 메서드
    func getUid() -> String? {
        return userDefaults.string(forKey: "uid")
    }

    // UID를 삭제하는 메서드
    func deleteUid() {
        userDefaults.removeObject(forKey: "uid")
    }
}
