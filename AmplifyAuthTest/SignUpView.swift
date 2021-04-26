//
//  SignUpView.swift
//  AmplifyAuthTest
//
//  Created by user on 2021/04/26.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var username = ""
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            TextField("아이디", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("이메일", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("비밀번호", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("로그인", action: {
                sessionManager.signUp(username: username, email: email, password: password)
            })
            
            Spacer()
            Button("이미 계정이 있으신가요? 로그인하기", action: {
                    sessionManager.showLogin()
            })
        }
        .padding()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
