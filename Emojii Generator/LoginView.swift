//
//  LoginView.swift
//  Emojii Generator
//
//  Created by Kartavya Sharma on 5/1/23.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var loginStatus: LoginStatus = .none

    enum LoginStatus {
        case none, success, failure
    }

    var body: some View {
        ZStack {
            Color(hex: "F3E1A0", alpha: 27)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 40)

                VStack {
                    TextField("Email", text: $email)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .padding(.bottom, 20)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        .autocapitalization(.none)
                        .padding(.bottom, 20)
                }
                .padding(.horizontal, 20)
            Button("Login") {
                loginUser(email: email, password: password)
            }
            .padding()

            if loginStatus == .success {
                Text("Login successful")
                    .foregroundColor(.green)
                    .padding(.top)
            } else if loginStatus == .failure {
                Text("Login failed")
                    .foregroundColor(.red)
                    .padding(.top)
            }
        }
        .padding()
    }
        }

    func loginUser(email: String, password: String) {
        let url = URL(string: "http://localhost:3333/auth/login")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("PostmanRuntime/7.29.2", forHTTPHeaderField: "User-Agent")

        let body: [String: Any] = [
            "email": email,
            "password": password
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Error creating JSON body: \(error)")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Status code: \(httpResponse.statusCode)")

                DispatchQueue.main.async {
                    if httpResponse.statusCode == 200 {
                        self.loginStatus = .success
                    } else {
                        self.loginStatus = .failure
                    }
                }
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print("JSON: \(json)")
            } catch {
                print("Error: \(error)")
            }
        }

        task.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
