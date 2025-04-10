//
//  ProfileViewModel.swift
//  HydrateMe
//
//  Created by english on 2025-04-10.
//

import Foundation
import FirebaseFirestore

class ProfileViewModel: ObservableObject {
    @Published var user: Users?
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var errorMsg = ""
    @Published var alert = false
    
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    func fetchUserInfo(uid: String) {
        listener = db.collection("Users").document(uid).addSnapshotListener { documentSnapshot, error in
            if let error = error {
                self.errorMsg = error.localizedDescription
                self.alert = true
                return
            }
            
            do {
                if let user = try documentSnapshot?.data(as: Users.self) {
                    self.user = user
                    self.firstName = user.firstName
                    self.lastName = user.lastName
                    self.email = user.email
                }
            } catch {
                self.errorMsg = "Failed to decode user data"
                self.alert = true
            }
        }
    }
    
    func updateField(_ field: String, value: String, uid: String) {
        db.collection("Users").document(uid).updateData([field: value]) { error in
            if let error = error {
                self.errorMsg = error.localizedDescription
                self.alert = true
            }
        }
    }
    
    deinit {
        listener?.remove()
    }
}
