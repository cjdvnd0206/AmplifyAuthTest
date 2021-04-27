//
//  ConfirmationView.swift
//  AmplifyAuthTest
//
//  Created by user on 2021/04/26.
//

import SwiftUI

struct ConfirmationView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var confirmationCode = ""
    
    let username: String
    
    var body: some View {
        VStack {
            Text("이메일 인증")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            
            Text("아이디: \(username)")
            TextField("인증번호", text: $confirmationCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("확인", action: {
                sessionManager.confirm(username: username, code: confirmationCode).store(in: &sessionManager.cancelableSet)
            })
        }
        .padding()
    }
}

struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationView(username: "")
    }
}
