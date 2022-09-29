//
//  Tweet.swift
//  Twitter_SwiftUI
//
//  Created by Sai Lakshmi on 9/10/22.
//

import FirebaseFirestoreSwift
import Firebase

struct Tweet: Identifiable, Decodable {
    @DocumentID var id: String?
    let caption: String
    let timestamp: Timestamp
    let uid: String
    var likes: Int
    
    var user: User?
}

