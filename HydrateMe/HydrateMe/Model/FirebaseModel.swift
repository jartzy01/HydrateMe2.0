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
    
    @Published var currentRecord: HydrationRecord?
    
    private var auth: Auth {
        return Auth.auth()
    }
    
    private var db: Firestore {
        return Firestore.firestore()
    }
    
    func signUp(email: String, password: String, firstName: String, lastName: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                let userData: [String: Any] = [
                    "firstName": firstName,
                    "lastName": lastName,
                    "email": email
                ]
                
                // Save to Firestore
                self.db.collection("Users").document(user.uid).setData(userData) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(user))
                    }
                }
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
    
    func changePassword(email: String, newPassword: String, confirmPassword: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No user is currently signed in."])))
            return
        }

        // Verify passwords match
        guard newPassword == confirmPassword else {
            completion(.failure(NSError(domain: "", code: 2, userInfo: [NSLocalizedDescriptionKey: "Passwords do not match."])))
            return
        }

        // Update password
        currentUser.updatePassword(to: newPassword) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
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
    
//    func fetchUserDetails(uid: String, completion: @escaping (Result<UserDetails, Error>) -> Void) {
//        let db = Firestore.firestore()
//        
//        // Fetch the user document from Firestore
//        db.collection("users").document(uid).getDocument { document, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let document = document, document.exists else {
//                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
//                return
//            }
//            
//            // Try to decode the user details from the Firestore document
//            do {
//                if let data = document.data() {
//                    let firstName = data["firstName"] as? String ?? "Unknown"
//                    let lastName = data["lastName"] as? String ?? "Unknown"
//                    let email = data["email"] as? String ?? "Unknown"
//                    
//                    let userDetails = UserDetails(firstName: firstName, lastName: lastName, email: email)
//                    completion(.success(userDetails))
//                } else {
//                    completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data found for user"])))
//                }
//            } catch {
//                completion(.failure(error))
//            }
//        }
//    }
    
    func fetchLatestHydration(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "No User Logged In", code: 0)))
            return
        }
        
        let query = db.collection("User")
            .document(userId)
            .collection("HydrationRecord")
            .order(by: "date", descending: true)
            .limit(to: 1)
        
        query.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = snapshot?.documents.first,
                  let record = try? document.data(as: HydrationRecord.self) else {
                completion(.failure(NSError(domain: "No Hydration Record Found", code: 1)))
                return
            }
            
            self.currentRecord = record
            completion(.success(()))
        }
    }
    
    func increaseHydrationValue() {
        currentRecord?.amountIntake += 10
    }

    func decreaseHydrationValue() {
        currentRecord?.amountIntake -= 10
    }
    
    func saveHydration(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid,
              let record = currentRecord else {
            completion(.failure(NSError(domain: "Missing Data", code: 1)))
            return
        }

        // Directly access properties instead of using getter methods
        let updatedData: [String: Any] = [
            "recordId": record.recordId,
            "date": record.date,  // Access date directly
            "amountIntake": record.amountIntake  // Access amountIntake directly
        ]

        db.collection("User")
            .document(userId)
            .collection("HydrationRecord")
            .document(record.recordId)
            .setData(updatedData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
    }
//    func increaseHydration(completion: @escaping (Result<Void, Error>) -> Void) {
//        guard let userId = Auth.auth().currentUser?.uid else {
//            completion(.failure(NSError(domain: "No User logged In", code: 0)))
//            return
//        }
//        
//        let hydrationQuery = db.collection("User")
//            .document(userId)
//            .collection("HydrationRecord")
//            .order(by: "date", descending: true)
//            .limit(to: 1)
//        
//        hydrationQuery.getDocuments { snapshot, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let document = snapshot?.documents.first else {
//                completion(.failure(NSError(domain: "No Hydration Record Found", code: 1)))
//                return
//            }
//            
//            var record = try?  document.data(as: HydrationRecord.self)
//            record?.amountIntake += 10
//            
//            let updatedData: [String: Any] = [
//                "recordId": record?.recordId ?? "",
//                "date": record?.getDate() ?? Date(),
//                "amountIntake": record?.getAmountIntake() ?? 0
//            ]
//            
//            document.reference.setData(updatedData) { error in
//                if let error = error {
//                    completion(.failure(error))
//                } else {
//                    completion(.success(()))
//                }
//            }
//        }
//    }
//    
//    func decreaseHydration(completion: @escaping (Result<Void, Error>) -> Void) {
//        guard let userId = Auth.auth().currentUser?.uid else {
//            completion(.failure(NSError(domain: "No User logged In", code: 0)))
//            return
//        }
//        
//        let hydrationRecordRef = db.collection("User")
//            .document(userId)
//            .collection("HydrationRecord")
//            .order(by: "date", descending: true)
//            .limit(to: 1)
//        
//        hydrationRecordRef.getDocuments() { snapshot, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let document = snapshot?.documents.first else {
//                completion(.failure(NSError(domain: "No Hydration Record Found", code: 1)))
//                return
//            }
//                    
//            var record = try? document.data(as: HydrationRecord.self)
//            record?.amountIntake -= 10
//                    
//            let updatedData: [String: Any] = [
//                "recordId": record?.recordId ?? "",
//                "date": record?.getDate() ?? Date(),
//                "amountIntake": record?.getAmountIntake() ?? 0
//            ]
//                    
//            document.reference.setData(updatedData) { error in
//                if let error = error {
//                    completion(.failure(error))
//                } else {
//                    completion(.success(()))
//                }
//            }
//        }
//    }
    
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
