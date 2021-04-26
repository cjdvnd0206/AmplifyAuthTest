//
//  LoginView.swift
//  AmplifyAuthTest
//
//  Created by user on 2021/04/26.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var username = ""
    @State var password = ""

    var body: some View {
        VStack {
            Spacer()
            
            TextField("아이디", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("비밀번호", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("로그인", action: {
                sessionManager.login(username: username, password: password)
            })
            
            Spacer()
            Button("계정이 없으신가요? 회원가입하기", action: {
                    sessionManager.showSignUp()
            })
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
