//
//  ContentView.swift
//  Twitter_SwiftUI
//
//  Created by Sai Lakshmi on 7/7/22.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    @State private var showMenu = false
    //we're gonna need this viewModel in various files such as ContentView, LoginView, RegistrationView.
    //so instead of initializing viewModel over and over again, we pass it around all the different views using @EnvironmentObject to use viewModel within the whole environment of views.
    // and you need to intitialize it somewhere (in App file)
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            //if no user logged in i.e. The user has'nt signed up yet or the user purposely logged out of the app.
            if viewModel.userSession == nil {
                LoginView()
            } else {
                // have a logged in user
                mainInterfaceView
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension ContentView {
    var mainInterfaceView: some View {
        ZStack(alignment: .topLeading) {
            MainTabView()
                .navigationBarHidden(showMenu)
            //its gonna create a shadow view in the background and then when you click on it, the side menu gonna disappear
            if showMenu {
                ZStack {
                    Color(.black).opacity(showMenu ? 0.25 : 0.0)
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        showMenu = false
                    }
                }
                .ignoresSafeArea()
            }
            
            SideMenuView()
                .frame(width: 300)
                .offset(x: showMenu ? 0 : -300, y: 0)
                .background(showMenu ? Color.white : Color.clear)
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if let user = viewModel.currentUser {
                    Button {
                        withAnimation(.easeInOut) {
                            showMenu.toggle()
                        }
                    } label: {
                        KFImage(URL(string: user.profileImageUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 32, height: 32)
                            .clipShape(Circle())
                    }
                }
                
            }
        }
        .onAppear { //when you go back from another view to this main tab view, it doesn't show side menu since we set it to false.
            showMenu = false
        }
    }
}
