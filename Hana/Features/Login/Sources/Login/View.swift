//
//  LoginView.swift
//  
//
//  Created by Ivan Lisovyi on 19.12.20.
//

import SwiftUI
import Combine

import Kaori
import Components 
import ComposableArchitecture

public struct LoginView: View {
  public let store: Store<LoginState, LoginAction>

  public init(store: Store<LoginState, LoginAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store) { viewStore in
      VStack {
        Form {
          Section(header: Text("Username")) {
            TextField(
              "danbooru_user",
              text: viewStore.binding(get: \.username, send: LoginAction.formUsernameChanged)
            )
            .textContentType(.username)
            .autocapitalization(.none)
          }
          Section(header: Text("Password")) {
            SecureField(
              "••••••••",
              text: viewStore.binding(get: \.password, send: LoginAction.formPasswordChanged)
            )
            .textContentType(.password)
          }
          Section {
            Button(action: { viewStore.send(.loginButtonTapped) }, label: {
              HStack {
                Text("Log in")
                Spacer()
                if viewStore.isLoggingIn {
                  ActivityIndicator()
                }
              }
              .frame(maxWidth: .infinity)
            })
            .disabled(!viewStore.isFormValid)
          }
        }
        .disabled(viewStore.isLoggingIn)
      }
      .alert(self.store.scope(state: \.alert), dismiss: .alertDismissed)
    }
    .navigationBarTitle("Login")
    .navigationBarItems(trailing: EmptyView())
  }
}

#if DEBUG
struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      LoginView(
        store: Store(
          initialState: LoginState(),
          reducer: loginReducer,
          environment: LoginEnvironment(
            apiClient: Kaori.mock(
              login: { _ in },
              profile: {
                KaoriMocks.decodePublisher(Profile.self, from: .profile)
                  .delay(for: 3.0, scheduler: DispatchQueue.global())
                  .eraseToAnyPublisher()
              }
            ),
            mainQueue: DispatchQueue.main.eraseToAnyScheduler()
          )
        )
      )
    }
  }
}
#endif
