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
    
    func addHydrationRecord(amount: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "No User logged In", code: 0)))
            return
        }
        
        let record = HydrationRecord(date: Date(), amountIntake: amount)
        
        let documentId = record.recordId
        
        let data: [String: Any] = [
            "recordId": record.recordId,
            "date": record.getDate,  // Use the public property or getter
            "amountIntake": record.getAmountIntake
        ]
        
        db.collection("User")
            .document(userId)
            .collection("HydrationRecord")
            .document(documentId)
            .setData(data) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
    }
    
    func increaseHydration(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "No User logged In", code: 0)))
            return
        }
        
        let hydrationQuery = db.collection("User")
            .document(userId)
            .collection("HydrationRecord")
            .order(by: "date", descending: true)
            .limit(to: 1)
        
        hydrationQuery.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = snapshot?.documents.first else {
                completion(.failure(NSError(domain: "No Hydration Record Found", code: 1)))
                return
            }
            
            var record = try?  document.data(as: HydrationRecord.self)
            record?.amountIntake += 10
            
            let updatedData: [String: Any] = [
                "recordId": record?.recordId ?? "",
                "date": record?.getDate() ?? Date(),
                "amountIntake": record?.getAmountIntake() ?? 0
            ]
            
            document.reference.setData(updatedData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
    
    func decreaseHydration(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "No User logged In", code: 0)))
            return
        }
        
        let hydrationRecordRef = db.collection("User")
            .document(userId)
            .collection("HydrationRecord")
            .order(by: "date", descending: true)
            .limit(to: 1)
        
        hydrationRecordRef.getDocuments() { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = snapshot?.documents.first else {
                completion(.failure(NSError(domain: "No Hydration Record Found", code: 1)))
                return
            }
                    
            var record = try? document.data(as: HydrationRecord.self)
            record?.amountIntake -= 10
                    
            let updatedData: [String: Any] = [
                "recordId": record?.recordId ?? "",
                "date": record?.getDate() ?? Date(),
                "amountIntake": record?.getAmountIntake() ?? 0
            ]
                    
            document.reference.setData(updatedData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
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
