//
//  View.swift
//  
//
//  Created by Ivan Lisovyi on 21.12.20.
//

import SwiftUI

import ComposableArchitecture
import Kaori

public struct ProfileView: View {
  public let store: Store<ProfileState, ProfileAction>

  public init(store: Store<ProfileState, ProfileAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(self.store) { store in
      Form {
        Section(header: Text("General")) {
          cell(title: "ID", detail: "\(store.profile.id)")
          cell(title: "Username", detail: store.profile.name)
          cell(title: "Level", detail: "\(store.profile.level.rawValue)")
        }

        Section(header: Text("Favorites")) {
          cell(title: "Favorites", detail: "\(store.profile.favoriteCount)")
          cell(title: "Favorites Limit", detail: "\(store.profile.favoriteLimit)")
        }

        Section(header: Text("Tags")) {
          cell(title: "Favorite", detail: "\(store.profile.tags.favorite.joined(separator: ","))")
          cell(title: "Blocked", detail: "\(store.profile.tags.blacklisted.joined(separator: ","))")
        }

        Section {
          Button(action: { store.send(.logoutButtonTapped) }, label: {
            HStack {
              Text("Logout")
                .frame(maxWidth: .infinity)
                .foregroundColor(.red)
            }
          })
        }
      }
    }
    .navigationBarTitle("Profile")
    .navigationBarItems(trailing: EmptyView())
  }

  @ViewBuilder private func cell(title: String, detail: String) -> some View {
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

    return ProfileView(
      store: .init(
        initialState: .init(profile: profile),
        reducer: profileReducer,
        environment: ProfileEnvironment(
          apiClient: .mock(),
          mainQueue: DispatchQueue.main.eraseToAnyScheduler()
        )
      )
    )
  }
}
#endif
