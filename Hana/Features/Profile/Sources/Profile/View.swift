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
      Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
