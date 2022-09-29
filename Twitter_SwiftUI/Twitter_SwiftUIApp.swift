//
//  Twitter_SwiftUIApp.swift
//  Twitter_SwiftUI
//
//  Created by Sai Lakshmi on 7/7/22.
//

import SwiftUI
import FirebaseCore

@main
struct Twitter_SwiftUIApp: App {
    //you should initialize @EnvironmentObject var viewModel: AuthViewModel in here 
    @StateObject var viewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView { 
               ContentView()
            }
            .environmentObject(viewModel)
        }
    }
}
