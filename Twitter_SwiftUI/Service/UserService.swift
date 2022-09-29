//
//  UserService.swift
//  Twitter_SwiftUI
//
//  Created by Sai Lakshmi on 8/31/22.
//

import Firebase
import FirebaseFirestoreSwift

// To fetch user info from API
struct UserService {
    func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        Firestore.firestore().collection("users")
            .document(uid)
            .getDocument { snapshot, _ in
               // guard let data = snapshot?.data() else { return }
               // print("DEBUG: User data is \(data)")
                guard let snapshot = snapshot else { return }
                // need not write catch if you have ? after try and if it is in guard statement
                // we are decoding the data from document and map it into our user object
                guard let user = try? snapshot.data(as: User.self) else { return }
                
                completion(user)
            }
    }
    
    // to explore all the users
    func fetchUsers(completion: @escaping([User]) -> Void) {
        //var users = [User]()
        Firestore.firestore().collection("users")
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                // we are decoding the data from document and mapping it into our user object
                let users = documents.compactMap({ try? $0.data(as: User.self) })
//                documents.forEach { document in
//                    guard let user = try? document.data(as: User.self) else { return }
//                    users.append(user)
//                }
                completion(users)
            }
    }
}
