//
//  TweetRowViewModel.swift
//  Twitter_SwiftUI
//
//  Created by Sai Lakshmi on 9/12/22.
//

import Foundation

class TweetRowViewModel: ObservableObject {
   
    let tweet: Tweet
    private let service = TweetService()
    
    
    init(tweet: Tweet) {
        self.tweet = tweet
    }
    
    func likeTweet() {
        service.likeTweet()
    }
}
