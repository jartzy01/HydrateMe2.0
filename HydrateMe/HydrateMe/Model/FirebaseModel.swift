//
//  FirbeaseModel.swift
//  HydrateMe
//
//  Created by english on 2025-03-19.
//
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase
import FirebaseFirestore
import Foundation

class FirebaseModel {
    static let shared = FirebaseModel()
    
    private init() {
        FirebaseApp.configure()
    }
    
    @Published var currentRecord: HydrationRecord?
    
    private var auth: Auth {
        return Auth.auth()
    }
    
    private var firestoreDb: Firestore {
        return Firestore.firestore() // Firestore instance
    }
    
    private var realtimeDb: Database {
        return Database.database() // Realtime Database instance
    }
    
    // Sign-up function to create a new user and save to Realtime Database
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
                
                // Save user data to Firebase Realtime Database
                let ref = self.realtimeDb.reference().child("Users").child(user.uid)
                ref.setValue(userData) { error, _ in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(user)) // Success when data is saved
                    }
                }
            }
        }
    }
    
    // Sign-in function
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                completion(.success(user))
            }
        }
    }
    
    // Sign-out function
    func signOut() throws {
        try auth.signOut()
    }
    
    // Change password function
    func changePassword(email: String, newPassword: String, confirmPassword: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No user is currently signed in."])))
            return
        }

        guard newPassword == confirmPassword else {
            completion(.failure(NSError(domain: "", code: 2, userInfo: [NSLocalizedDescriptionKey: "Passwords do not match."])))
            return
        }

        currentUser.updatePassword(to: newPassword) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // Save hydration record to Firebase Realtime Database
    func saveHydration(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid,
              let record = currentRecord else {
            completion(.failure(NSError(domain: "Missing Data", code: 1)))
            return
        }

        let updatedData: [String: Any] = [
            "recordId": record.recordId,
            "date": record.date,
            "amountIntake": record.amountIntake
        ]
        
        // Save hydration record to Realtime Database
        let ref = self.realtimeDb.reference().child("Users").child(userId).child("HydrationRecords").child(record.recordId)
        ref.setValue(updatedData) { error, _ in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // Observe user changes in Realtime Database
    func observeUserChanges(uid: String, completion: @escaping (Result<DataSnapshot, Error>) -> Void) {
        let ref = self.realtimeDb.reference().child("Users").child(uid)
        ref.observe(.value) { snapshot, error in
            if let error = error {
                // Check if the error is of type NSError
                let errorDescription = (error as? NSError)?.localizedDescription ?? "Unknown error"
                let nsError = NSError(domain: "FirebaseError", code: 0, userInfo: [NSLocalizedDescriptionKey: errorDescription])
                completion(.failure(nsError))
            } else {
                completion(.success(snapshot))
            }
        }
    }
}
