//
//  TweetService.swift
//  Twitter_SwiftUI
//
//  Created by Sai Lakshmi on 9/9/22.
//

import Firebase

struct TweetService {
    
    func uploadTweet(caption: String, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let data = ["uid": uid,
                    "caption": caption,
                    "likes": 0,
                    "timestamp": Timestamp(date: Date())] as [String : Any]
        Firestore.firestore().collection("tweets").document()
            .setData(data) { error in
                if let error = error {
                    print("DEBUG: Failed to upload tweet with error: \(error.localizedDescription) ")
                    completion(false)
                    return
                }
                completion(true)
            }
    }
   
    // Fetch tweets of all the users and display them on home page
    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
        Firestore.firestore().collection("tweets")
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            // we are decoding the tweets data from document and trying to map into our Tweet object
            let tweets = documents.compactMap({ try? $0.data(as: Tweet.self)})
            completion(tweets)
//            documents.forEach { doc in
//                print(doc.data())
//            }
        }
    }
    
    // Fetch tweets of a loggedin user to display them on the profile page
    func fetchTweets(foruid uid: String, completion: @escaping([Tweet]) -> Void) {
        Firestore.firestore().collection("tweets")
            .whereField("uid", isEqualTo: uid) //firestore filters tweets data gives all the logged in user's tweets
            .getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            // we are decoding the tweets data from document and trying to map into our Tweet object
                let tweets = documents.compactMap({ try? $0.data(as: Tweet.self)})
                completion(tweets.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue()}))
        }
    }
    
    func likeTweet() {
        
    }
}
