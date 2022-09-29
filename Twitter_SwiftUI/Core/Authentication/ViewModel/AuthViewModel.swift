//
//  AuthViewModel.swift
//  Twitter_SwiftUI
//
//  Created by Sai Lakshmi on 7/23/22.
//

import SwiftUI
import Firebase

class AuthViewModel: ObservableObject {
    //If the user is logged in, the userSession property is gonna have a value otherwise nil
    //And whenever the published variable is set, it's going to publish that notification to the view that is utilizing this view model(in this case, ContentView)
    @Published var userSession: FirebaseAuth.User?
    @Published var didAuthenticateUser = false
    // the reason it is optional is that we have to reach out to the API to fetch the user data before we can set it. so when the app launches intially it will be nil. since it always takes time to execute an API call we need to initialize this as an optional.
    @Published var currentUser: User?
    
    private var tempUserSession: FirebaseAuth.User?
    
    private let service = UserService()
    
    init() {
        self.userSession = Auth.auth().currentUser
        print("DEBUG: User session is \(self.userSession?.uid)")
        // to get the newly registered user's details
        self.fetchUser()
    }
    
    func login(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail:email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to sign in with error \(error.localizedDescription)")
                return
            }
            guard let user = result?.user else { return }
            self.userSession = user
            // to get and display the newly registered user's details and not the previously logged in user
            self.fetchUser()
        }
    }
    
    func register(withEmail email: String, password: String, fullname: String, username: String) {
        //To create a user in the firebase(Authentication page) when you register a new user in the app
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error { //checks if error is nil. if not then store the error in error
                print("DEBUG: Failed to register with error \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            //self.userSession = user ///not yet coz after registration, it has to go to the profile page instead of MainInterfaceView in ContentView.
            //So instead we use the tempUserSession
            
            self.tempUserSession = user
           
           //print("DEBUG: User registered successfully")
           // print("DEBUG: User is \(self.userSession)")
            
            // creates a user in Firestore Database with a collection name of "users", document of user id
            let data = ["email" : email,
                        "username" : username.lowercased(),
                        "fullname" : fullname,
                        "uid" : user.uid]
            
            Firestore.firestore().collection("users")
                .document(user.uid)
                .setData(data) { _ in //user data uploaded
                    // Change the published variable to true (Authenticate/ upload user information to database.)
                    self.didAuthenticateUser = true
                }
        }
    }
    
    func signOut() {
        //sets user sessio to nil so we show login view
        userSession = nil
        //signs user out on server side
        try? Auth.auth().signOut()
    }
    
    func uploadProfileImage(_ image: UIImage) {
        guard let uid = tempUserSession?.uid  else { return }
        //upload image into the storage and download the path of the image and go to the firestore collection "users" with appropriate uid and create a new field called "profileImageUrl" with downloaded profile image URL
        ImageUploader.uploadImage(image: image) { profileImageUrl in
            Firestore.firestore().collection("users")
                .document(uid)
                .updateData(["profileImageUrl": profileImageUrl]) { _ in
                    // we set the user session now to go to the main interface since we are done with registration and uploading a profile picture 
                    self.userSession = self.tempUserSession
                    // to get and display the newly registered user's details and not the previously logged in user
                    self.fetchUser()
                }
        }
    }
    
    func fetchUser() {
        guard let uid = self.userSession?.uid else { return }
        //when this function call completes you are gonna get access to the user.
        service.fetchUser(withUid: uid) { user in
            self.currentUser = user
        }
    }
}

