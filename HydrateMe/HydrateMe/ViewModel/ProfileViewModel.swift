//
//  ProfileViewModel.swift
//  HydrateMe
//
//  Created by english on 2025-04-10.
//

import Foundation
import FirebaseDatabase

class ProfileViewModel: ObservableObject {
    @Published var user: Users?
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var errorMsg = ""
    @Published var alert = false

    private var db = Database.database().reference()

    func fetchUserInfo(uid: String) {
        db.child("Users").child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let data = snapshot.value as? [String: Any] else {
                DispatchQueue.main.async {
                    self.errorMsg = "User profile does not exist."
                    self.alert = true
                }
                return
            }
            DispatchQueue.main.async {
                self.firstName = data["firstName"] as? String ?? ""
                self.lastName = data["lastName"] as? String ?? ""
                self.email = data["email"] as? String ?? ""
            }
        } withCancel: { error in
            DispatchQueue.main.async {
                self.errorMsg = error.localizedDescription
                self.alert = true
            }
        }
    }

    func updateField(_ field: String, value: Any, uid: String) {
        guard !uid.isEmpty else {
            print("UID is empty — skipping update for field: \(field)")
            return
        }

        db.child("Users").child(uid).child(field).setValue(value) { error, _ in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMsg = error.localizedDescription
                    self.alert = true
                }
            }
        }
    }
}
