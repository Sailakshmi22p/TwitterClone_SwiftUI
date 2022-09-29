//
//  UploadTweetViewModel.swift
//  Twitter_SwiftUI
//
//  Created by Sai Lakshmi on 9/9/22.
//

import Foundation

class UploadTweetViewModel: ObservableObject {
    @Published var didUploadTweet = false
    let service = TweetService()
    
    // the func call is from a button in NewTweetView
    func uploadTweet(withCaption caption: String) {
        service.uploadTweet(caption: caption) { success in // success is either true/false from completion handler in TweetService
            if success {
                //dismiss screen somehow(after tweet is uploaded successfully)
                self.didUploadTweet = true
            } else {
                //show error msg to user..
            }
        }
    }
}
