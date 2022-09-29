//
//  FeedViewModel.swift
//  Twitter_SwiftUI
//
//  Created by Sai Lakshmi on 9/10/22.
//

import Foundation

class FeedViewModel: ObservableObject {
    @Published var tweets = [Tweet]()
    let service = TweetService()
    let userService = UserService()
    
    init() {
        fetchTweets()
    }
    
    func fetchTweets() {
        service.fetchTweets { tweets in
            self.tweets = tweets
            // we go through a loop of tweets of all users, get their uid and get all user details through userService.fetchUser
            for i in 0 ..< tweets.count {
                let uid = tweets[i].uid
                self.userService.fetchUser(withUid: uid) { user in
                    self.tweets[i].user = user
                }
            }
            
                
        }
    }
    
}
