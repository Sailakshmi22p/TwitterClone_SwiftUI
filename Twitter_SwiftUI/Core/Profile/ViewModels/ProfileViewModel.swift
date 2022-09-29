//
//  ProfileViewModel.swift
//  Twitter_SwiftUI
//
//  Created by Sai Lakshmi on 9/11/22.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var tweets = [Tweet]()
    private let service = TweetService()
    let user: User
    
    init(user: User) {
        self.user = user
        self.fetchUserTweets()
    }
    
    func fetchUserTweets() {
        guard let uid = user.id else { return }
        self.service.fetchTweets(foruid: uid) { tweets in
            self.tweets = tweets
            // you dont have to get the user details from the tweets because we already have them 
            for i in 0 ..< tweets.count {
                self.tweets[i].user = self.user
            }
        }
    }
}
