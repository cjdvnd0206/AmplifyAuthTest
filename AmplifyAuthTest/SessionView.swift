//
//  SessionView.swift
//  AmplifyAuthTest
//
//  Created by user on 2021/04/26.
//
import Amplify
import SwiftUI

struct SessionView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    let user: AuthUser
    
    var body: some View {
        VStack {
            Spacer()
            Text("\(user.username)님 환영합니다!")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            
            Spacer()
            Button("로그아웃", action: {
                    sessionManager.signOut().store(in: &sessionManager.cancelableSet)
            })
        }
        .padding()
    }
}

struct SessionView_Previews: PreviewProvider {
    private struct DummyUser: AuthUser {
        let userId: String = "1"
        let username: String = "dummy"
    }
    
    static var previews: some View {
        SessionView(user: DummyUser())
    }
}
