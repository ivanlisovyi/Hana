import Foundation
import Combine

@_implementationOnly import KeychainAccess

public struct KeychainError: LocalizedError, Equatable {
  public let underlayingError: Error

  public var id: String {
    underlayingError.localizedDescription
  }

  public var errorDescription: String? {
    underlayingError.localizedDescription
  }

  public static func ==(lhs: Self, rhs: Self) -> Bool {
    lhs.id == rhs.id
  }
}

public struct Keychain {
  public struct Credentials: Equatable {
    public let username: String
    public let password: String

    public init(username: String, password: String) {
      self.username = username
      self.password = password
    }
  }

  public let save: (Credentials) -> AnyPublisher<Void, KeychainError>
  public let retrieve: () -> AnyPublisher<Credentials, KeychainError>
  public let clear: () -> AnyPublisher<Void, KeychainError>

  public init(
    save: @escaping (Credentials) -> AnyPublisher<Void, KeychainError>,
    retrieve: @escaping () -> AnyPublisher<Credentials, KeychainError>,
    clear: @escaping () -> AnyPublisher<Void, KeychainError>
  ) {
    self.save = save
    self.retrieve = retrieve
    self.clear = clear
  }
}

public extension Keychain {
  static func live(service: String = "com.ivanlisovyi.hana") -> Keychain {
    let keychain = KeychainAccess.Keychain(service: "com.ivanlisovyi.hana-apiKey")
      .label("danbooru.donmai.us (hana)")
      .comment("username & apiKey for Danbooru API")
    let usernameKey = "hana.username"
    let passwordKey = "hana.password"

    return Self(
      save: { credentials in
        result {
          _ = (
            try keychain.set(credentials.username, key: usernameKey),
            try keychain.set(credentials.password, key: passwordKey)
          )
        }
      },
      retrieve: {
        result {
          Credentials(
            username: try keychain.get(usernameKey),
            password: try keychain.get(passwordKey)
          )
        }
      },
      clear: {
        result {
          _ = (
            try keychain.remove(usernameKey),
            try keychain.remove(passwordKey)
          )
        }
      }
    )
  }
}

public extension Keychain {
  static func mock(
    save: @escaping (Credentials) -> AnyPublisher<Void, KeychainError> = { _ in
      _unimplemented("save")
    },
    retrieve: @escaping () -> AnyPublisher<Credentials, KeychainError> = {
      _unimplemented("retrieve")
    },
    clear: @escaping () -> AnyPublisher<Void, KeychainError> = {
      _unimplemented("clear")
    }
  ) -> Keychain {
    Self(
      save: save,
      retrieve: retrieve,
      clear: clear
    )
  }
}

private extension Keychain {
  static func result<Value>(catching: () throws -> Value) -> AnyPublisher<Value, KeychainError>  {
    Result(catching: catching)
    .publisher
    .mapError(KeychainError.init(underlayingError:))
    .eraseToAnyPublisher()
  }
}

private extension KeychainAccess.Keychain {
  func get(_ key: String) throws -> String {
    guard let value = try self.get(key, ignoringAttributeSynchronizable: true) else {
      throw KeychainAccess.Status.itemNotFound
    }

    return value
  }
}


public func _unimplemented(
  _ function: StaticString, file: StaticString = #file, line: UInt = #line
) -> Never {
  fatalError(
    """
    `\(function)` was called but is not implemented. Be sure to provide an implementation for
    this endpoint when creating the mock.
    """,
    file: file,
    line: line
  )
}
