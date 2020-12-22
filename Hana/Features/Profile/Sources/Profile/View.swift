//
//  View.swift
//  
//
//  Created by Ivan Lisovyi on 21.12.20.
//

import SwiftUI
import Combine

import ComposableArchitecture

import Kaori
import Login

import Components
import Extensions

public struct ProfileView: View {
  public let store: Store<ProfileState, ProfileAction>

  public init(store: Store<ProfileState, ProfileAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      IfLetElse(viewStore.profile, trueContent: profileView) {
        LoginView(store: self.store.scope(state: \.login, action: ProfileAction.login))
      }
      .transition(.slide)
      .navigationBarTitle(viewStore.isLoggedIn ? "Profile" : "Login")
      .navigationBarItems(trailing: EmptyView())
    }
  }

  @ViewBuilder private func profileView(_ profile: Profile) -> some View {
    WithViewStore(self.store) { viewStore in
      Form {
        Section(header: Text("General")) {
          cellView(title: "ID", detail: "\(profile.id)")
          cellView(title: "Username", detail: profile.name)
          cellView(title: "Level", detail: "\(profile.level.rawValue)")
        }

        Section(header: Text("Favorites")) {
          cellView(title: "Favorites", detail: "\(profile.favoriteCount)")
          cellView(title: "Favorites Limit", detail: "\(profile.favoriteLimit)")
        }

        Section(header: Text("Tags")) {
          cellView(title: "Favorite", detail: "\(profile.tags.favorite.joined(separator: ","))")
          cellView(title: "Blocked", detail: "\(profile.tags.blacklisted.joined(separator: ","))")
        }

        Section {
          Button(action: { viewStore.send(.logoutButtonTapped) }, label: {
            HStack {
              Text("Logout")
                .frame(maxWidth: .infinity)
                .foregroundColor(.red)
            }
          })
        }
      }
    }
  }

  @ViewBuilder private func cellView(title: String, detail: String) -> some View {
    HStack {
      Text(title)
        .bold()

      Spacer()

      Text(detail)
        .multilineTextAlignment(.trailing)
    }
  }
}

#if DEBUG
struct Profile_Previews: PreviewProvider {
  static var previews: some View {
    let profile = try! Kaori.decodeMock(
      of: Profile.self,
      for: "profile.json",
      in: .module
    )

    return StackNavigationView {
      ProfileView(
        store: .init(
          initialState: .init(profile: profile),
          reducer: profileReducer,
          environment: ProfileEnvironment(
            apiClient: .mock(
              login: { _ in },
              logout: {},
              profile: {
                Just(profile)
                  .setFailureType(to: KaoriError.self)
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
