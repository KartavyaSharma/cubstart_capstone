//
//  SignupView.swift
//  Emojii Generator
//
//  Created by Kartavya Sharma on 5/1/23.
//

import Foundation
import SwiftUI

struct SignupView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var signupStatus: SignupStatus = .none
    
    enum SignupStatus {
        case none, success, failure
    }

    var body: some View {
        ZStack {
            Color(hex: "F3E1A0", alpha: 27)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Signup")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 40)

                VStack {
                    TextField("Name", text: $name)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        .padding(.bottom, 20)

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

                Button("Sign up") {
                    createUser(name: name, email: email, password: password)
                }
                .padding(.top, 20)
                
                
                if signupStatus == .success {
                    Text("Signup successful")
                        .foregroundColor(.green)
                        .padding(.top)
                } else if signupStatus == .failure {
                    Text("Signup failed")
                        .foregroundColor(.red)
                        .padding(.top)
                }
            }
            .padding()
        }
    }

    func createUser(name: String, email: String, password: String) {
        let url = URL(string: "http://localhost:3333/auth/create-user")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "name": name,
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
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP response: \(httpResponse)")
                
                DispatchQueue.main.async {
                    if httpResponse.statusCode == 200 {
                        self.signupStatus = .success
                    } else {
                        self.signupStatus = .failure
                    }
                }
            } else {
                print("Non-HTTP response: \(response)")
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("JSON: \(json)")
                } catch {
                    print("Error: \(error)")
                }
            } else {
                print("No data received")
            }
        }

        task.resume()
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
