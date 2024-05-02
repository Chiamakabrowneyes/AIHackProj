//
//  AuthViewModel.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 10/5/23.
//

//initialize the user object to variable
//collect user data and update user info in FireStore database using unique UID as key
//allows user to compute prequate data before user session is launched

//backtracks to an empty user id as reflected in firebase
//reconfigures the sign out interface

import SwiftUI
import Firebase
import FirebaseAuth

enum AuthError: Error {
    case notLoggedIn
    case customError(message: String)
}

class AuthSceneModel: NSObject, ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var didSendResetPasswordLink = false
    @Published var didRegister = false
    @Published var navigationPath = NavigationPath()
    private var tempCurrentUser: FirebaseAuth.User?
    
    static let shared = AuthSceneModel()
    
    override init() {
        super.init()
        tempCurrentUser = nil
        userSession = Auth.auth().currentUser
        fetchUser()
    }
    
    func login(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Login failed: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            self.userSession = user
            self.fetchUser()
        }
    }
    
    func register(withEmail email: String, password: String, fullname: String, username: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                print("DEBUG: Failed to register with error: \(error.localizedDescription)")
                return
            }

            guard let user = result?.user else { return }
            
            let data: [String: Any] = [
                "email": email,
                "username": username,
                "fullname": fullname,
                "uid": user.uid,
                "status": UserStatus.notConfigured.rawValue
            ]
            
            // Create or get a reference to the siren list document with the user's UID
            let sirenListRef = COLLECTION_SIRENS.document(user.uid)
            
            // Set the user data and the siren list in a batch to ensure both operations complete
            let batch = Firestore.firestore().batch()
            
            // Set user data in USERS collection
            let userRef = COLLECTION_USERS.document(user.uid)
            batch.setData(data, forDocument: userRef)
            
            // Set siren list data in SIRENS collection
            let sirenListData: [String: Any] = [
                "name": "\(username)'s Siren List",
                "creator": user.uid,
                "uids": []  // Start with the user's UID in the list
            ]
            batch.setData(sirenListData, forDocument: sirenListRef)
            
            // Commit the batch
            batch.commit { error in
                if let error = error {
                    print("Error writing batch: \(error)")
                } else {
                    print("Batch write succeeded.")
                    self.tempCurrentUser = user
                    self.didRegister = true
                }
            }
        }
    }

    
    func uploadProfileImage(_ image: UIImage) {
        guard let uid = tempCurrentUser?.uid else { return }
        
        ImageUploader.uploadImage(image: image, type: .profile) { profileImageUrl in
            COLLECTION_USERS.document(uid).updateData(["profileImageUrl": profileImageUrl]) { _ in
                self.userSession = self.tempCurrentUser
                self.fetchUser()
            }
        }
    }
    
    func signout() {
        self.userSession = nil
        try? Auth.auth().signOut()
    }
    
    func resetPassword(withEmail email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("Failed to send link with error \(error.localizedDescription)")
                return
            }
            
            self.didSendResetPasswordLink = true
        }
    }
    
    func fetchUser() {
        guard let uid = userSession?.uid else { return }
        UserService.fetchUser(withUid: uid) { user in
            self.currentUser = user
        }
    }
    
    func fetchSirenListId(completion: @escaping (String?) -> Void) {
            guard let currentUid = self.currentUser?.id else {
                completion(nil)
                return
            }

            COLLECTION_SIRENS.whereField("creator", isEqualTo: currentUid).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting siren list: \(error.localizedDescription)")
                    completion(nil)
                } else {
                    // Assuming each user has only one siren list they've created
                    let document = querySnapshot?.documents.first
                    completion(document?.documentID)
                }
            }
        }
    
    func deleteAccount(completion: @escaping (Error?) -> Void) {
        guard let user = userSession else {
            completion(AuthError.notLoggedIn)
            return
        }

        // Delete user data from your Firestore database (assuming user data is stored in Firestore)
        let userRef = COLLECTION_USERS.document(user.uid)
        userRef.delete { error in
            if let error = error {
                print("Error deleting user data: \(error.localizedDescription)")
                completion(error)
                return
            }

            // Revoke the user's authentication token (sign them out)
            Auth.auth().currentUser?.delete { error in
                if let error = error {
                    print("Error deleting user account: \(error.localizedDescription)")
                    completion(error)
                    return
                }

                // Account successfully deleted
                self.userSession = nil
                completion(nil)
            }
        }
    }

}

