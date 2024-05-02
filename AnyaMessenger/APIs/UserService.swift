//
//  UserService.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 10/14/23.
//

import Foundation

struct UserService {
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        print(uid)
        COLLECTION_USERS.document(uid).getDocument { snapshot, _ in
            print(snapshot)
            guard let user = try? snapshot?.data(as: User.self) else { return }
            completion(user)
        }
    }
}
