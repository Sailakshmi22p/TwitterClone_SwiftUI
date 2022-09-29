//
//  User.swift
//  Twitter_SwiftUI
//
//  Created by Sai Lakshmi on 8/31/22.
//

// You'd have to import this FirebaseFirestoreSwift to work with Decodable protocol through the firebase code
import FirebaseFirestoreSwift

// we created an object to map data in firestore to this user object
struct User: Identifiable, Decodable {
    // this is a document id that has all the info
    @DocumentID var id: String?
    var fullname: String
    var username: String
    var profileImageUrl: String
    var email: String
}
