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
            .autocapitalization(.none)
          }
          Section(header: Text("Password")) {
            SecureField(
              "••••••••",
              text: viewStore.binding(get: \.password, send: LoginAction.formPasswordChanged)
            )
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
          initialState: LoginState(username: "", password: "", isLoggingIn: false),
          reducer: loginReducer,
          environment: LoginEnvironment(
            apiClient: Kaori.mock(
              authenticate: { _ in
                guard let json = Bundle.module.url(forResource: "profile", withExtension: "json"),
                      let data = try? Data(contentsOf: json) else {
                  return Fail(error: Kaori.KaoriError.network)
                    .eraseToAnyPublisher()
                }

                let dateFormatter = DateFormatter()
                dateFormatter.locale = .autoupdatingCurrent
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                guard let profile = try? decoder.decode(Profile.self, from: data) else {
                  return Fail(error: Kaori.KaoriError.decoding)
                    .eraseToAnyPublisher()
                }

                return Just(profile)
                  .setFailureType(to: Kaori.KaoriError.self)
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
