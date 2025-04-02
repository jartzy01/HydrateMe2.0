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
    
    func singUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                completion(.success(user))
            }
        }
    }
    
    func signIn(firstName: String, lastName: String, email: String, password: String, completion: @escaping (Result<Users, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                let userId = user.uid
                let newUser = Users(firstName: firstName, lastName: lastName, email: email, password: password)

                let userData: [String: Any] = [
                    "userId": newUser.userId,
                    "firstName": newUser.firstName,
                    "email": newUser.email,
                    "password": newUser.password,
                    "hydrationGoal": newUser.hydrationGoal,
                    "hydrationHistory": newUser.hydrationHistory,
                    "rewards": newUser.rewards,
                    "reminders": newUser.reminders
                ]

                self.db.collection("users").document(user.uid).setData(userData) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(newUser))
                    }
                }
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
