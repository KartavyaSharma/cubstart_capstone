//
//  startupPage.swift
//  Emojii Generator
//
//  Created by Tom on 2023-04-23.
//

import SwiftUI

struct startupPage: View {
    var body: some View {
        NavigationView {
            VStack{
                Divider()
                Spacer()
                Text("Welcome!")
                    .font(.largeTitle)
                    .frame(width: 300,height: 79)
                    .foregroundColor(.black)
                Spacer()
                Button(action: {}){
                    NavigationLink(destination: LoginView()) {
                        Text("Sign In")
                    }
                }
                .font(.headline)
                .frame(width: 258, height: 75)
                .foregroundColor(Color.black)
                .background(Color(UIColor(red: CGFloat(0x0B) / 255, green: CGFloat(0xC4) / 255, blue: CGFloat(0xFF) / 255, alpha: 1)))
                Spacer()
                    .frame(width: 300, height: 50)
                Button(action: {}){
                    NavigationLink(destination: SignupView()) {
                        Text("Sign Up")
                    }
                }
                    .font(.headline)
                    .frame(width: 258, height: 75)
                    .foregroundColor(Color.black)
                    .background(Color(UIColor(red: CGFloat(0x0B) / 255, green: CGFloat(0xC4) / 255, blue: CGFloat(0xFF) / 255, alpha: 1)))
                Spacer()
                Button(action: {}){
                    NavigationLink(destination: Files()) {
                        Text("Continue Without Sign In")
                            .foregroundColor(Color.blue)
                            .navigationBarHidden(true)
                    }
                }
                Spacer()
            }
            .background(Color(UIColor(red: CGFloat(0xf3) / 255, green: CGFloat(0xe1) / 255, blue: CGFloat(0xa1) / 255, alpha: 0.625)))
        }
    }
}

struct startupPage_Previews: PreviewProvider {
    static var previews: some View {
        startupPage()
    }
}
