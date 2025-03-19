//
//  FirbeaseModel.swift
//  HydrateMe
//
//  Created by english on 2025-03-19.
//
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseDatabase

import Foundation

class FirebaseModel{
    static let shared = FirebaseModel()
    
    private init(){
        FirebaseApp.configure()
    }
    
    private var auth: Auth {
        return Auth.auth()
    }
    
    private var db: Firestore {
        return Firestore.firestore()
    }
    
    func singUp(firstName: String, lastName: String, email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                self.saveUserData(userId: user.uid, firstName: firstName, lastName: lastName, email: email) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(user))
                    }
                }
            }
        }
    }
    
    private func saveUserData(userId: String, firstName: String,lastName: String, email: String, completion: @escaping (Error?) -> Void) {
            let ref = Database.database().reference().child("users").child(userId)
            let userData: [String: Any] = [
                "firstName": firstName,
                "lastName": lastName,
                "email": email,
            ]
            
            ref.setValue(userData) { error, _ in
                completion(error) 
            }
        }
    
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                completion(.success(user))
            }
        }
    }
    
    func signOut() throws {
        try auth.signOut()
    }
    
    func fetchUserFromFirestore(uid: String, completion: @escaping (Result<DocumentSnapshot, Error>) -> Void) {
        db.collection("users").document(uid).getDocument() { document, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                completion(.success(document))
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
            }
        }
    }
    
    func observeUserChanges(uid: String, completion: @escaping (Result<DocumentSnapshot, Error>) -> Void) {
        db.collection("users").document(uid).addSnapshotListener { document, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = document {
                completion(.success(document))
            }
        }
    }
}
