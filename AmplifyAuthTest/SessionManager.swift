//
//  SessionManager.swift
//  AmplifyAuthTest
//
//  Created by user on 2021/04/26.
//

import Amplify
import Combine

enum AuthState {
    case signUp
    case login
    case confirmCode(username: String)
    case session(user: AuthUser)
}

final class SessionManager: ObservableObject {
    @Published var authState: AuthState = .login
    @Published var errorRecieve = PassthroughSubject<AuthError, Never>()
    var cancelableSet = Set<AnyCancellable>()
    
    
    func getCurrentAuthUser() {
        if let user = Amplify.Auth.getCurrentUser() {
            DispatchQueue.main.async {
                self.authState = .session(user: user)
            }
            
        } else {
            DispatchQueue.main.async {
                self.authState = .login
            }
        }
    }
    
    func showSignUp() {
        DispatchQueue.main.async {
            self.authState = .signUp
        }
        
    }
    
    func showLogin() {
        DispatchQueue.main.async {
            self.authState = .login
        }
    }
    
    func signUp(username: String, email: String, password: String) -> AnyCancellable {
        let attributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: attributes)
        
        let sink = Amplify.Auth.signUp(username: username, password: password, options: options)
            .resultPublisher
            .sink {
                if case let .failure(error) = $0 {
                    print("인증번호 전송 실패: ", error)
                }
            }
            receiveValue: { signUpResult in
                if case let .confirmUser(details, _) = signUpResult.nextStep {
                    print(details ?? "세부사항 없음")
                } else {
                    print("인증번호 전송 완료")
                }
                
                DispatchQueue.main.async {
                    self.authState = .confirmCode(username: username)
                }
            }
        
        return sink
    }
    
    func confirm(username: String, code: String) -> AnyCancellable {
        Amplify.Auth.confirmSignUp(for: username, confirmationCode: code)
            .resultPublisher
            .sink {
                if case let .failure(error) = $0 {
                    print("인증실패: ", error)
                }
            }
            receiveValue: { _ in
                print("인증 성공!")
                self.showLogin()
            }
    }
    
    func resendCode() -> AnyCancellable {
        Amplify.Auth.resendConfirmationCode(for: .email)
            .resultPublisher
            .sink {
                if case let .failure(error) = $0 {
                    print("인증번호 재전송 실패: \(error)")
                }
            }
            receiveValue: { deliveryDetails in
                print("인증번호 재전송 성공 - \(deliveryDetails)")
            }
    }
    
    func login(username: String, password: String) -> AnyCancellable {
        Amplify.Auth.signIn(username: username, password: password)
            .resultPublisher
            .sink {
                if case let .failure(error) = $0 {
                    print("로그인 실패: ", error)
                    self.errorRecieve.send(error)
                    
                }
            }
            receiveValue: { _ in
                print("로그인 성공!")
                self.getCurrentAuthUser()
            }
    }
    
    func signOut() -> AnyCancellable {
        Amplify.Auth.signOut()
            .resultPublisher
            .sink {
                if case let .failure(error) = $0 {
                    print("로그아웃 실패: ", error)
                }
            }
            receiveValue: {
                print("로그아웃 성공!")
                self.getCurrentAuthUser()
            }
    }
}
