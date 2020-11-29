//
//  Session.swift
//  
//
//  Created by Lisovyi, Ivan on 29.11.20.
//

import Foundation
import Combine

/// `Session` creates and manages request publishers types during their lifetimes.
///
/// `Session` only works with the request against the `Service` it was created with.
/// It also provides common functionality for all request publishers, including
/// - Response validation
/// - Cache handling
/// - Request retrying
open class Session<Service: ServiceType>: SessionProtocol {
  private let urlSession: URLSession

  /// Creates a `Session` instance with the given `SessionConfiguration`.
  ///
  /// - Parameter configuration: The session configuration which defines the behavior of this `Session` instance.
  ///                            Defaults to `SessionConfiguration.default`.
  public init(
    baseURL: URL,
    configuration: URLSessionConfiguration = .default
  ) {
    self.urlSession = URLSession(configuration: configuration)
  }

  deinit {
    urlSession.invalidateAndCancel()
  }

  open func request<Value: Decodable>(_ service: Service, of type: Value.Type = Value.self) -> AnyPublisher<Response<Value>, Error> {
    do {
      let request = try urlRequest(for: service)

      return urlSession.dataTaskPublisher(for: request)
        .validate { 200..<300 ~= $1.statusCode }
        .response()
        .eraseToAnyPublisher()
    } catch {
      return Fail(error: error).eraseToAnyPublisher()
    }
  }
}

// MARK: - Private Methods

fileprivate extension Session {
  private func urlRequest(for service: ServiceType) throws -> URLRequest {
    guard let path = URL(string: service.endpoint.path, relativeTo: service.baseURL) else {
      throw SessionError.invalidURL
    }

    var components = URLComponents(url: path, resolvingAgainstBaseURL: true)
    components?.queryItems = service.endpoint.parameters?.reduce(into: []) { acc, param in
      acc?.append(URLQueryItem(name: param.key, value: "\(param.value)"))
    }

    guard let url = components?.url else {
      throw SessionError.invalidURL
    }

    var request = URLRequest(url: url)
    request.httpMethod = service.endpoint.httpMethod.rawValue
    request.allHTTPHeaderFields = service.endpoint.httpHeaders.reduce(into: [String: String]()) { acc, header in
      acc[header.key] = header.value
    }

    return request
  }
}

extension URLSession.DataTaskPublisher {
  func validate(
    using validator: @escaping (Data, HTTPURLResponse) -> Bool
  ) -> Publishers.TryMap<Self, (Data, HTTPURLResponse)> {
    tryMap { data, response -> (Data, HTTPURLResponse) in
      guard let response = response as? HTTPURLResponse else {
        throw SessionError.unknown("Cannot map response to HTTPURLResponse.")
      }

      if validator(data, response) {
        return (data, response)
      }

      let localizedDescription = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
      throw SessionError.network(localizedDescription)
    }
  }
}

extension Publisher where Output == (Data, HTTPURLResponse) {
  func response<Value: Decodable>(
    decoder: JSONDecoder = .init()
  ) -> Publishers.TryMap<Self, Response<Value>> {
    tryMap { (data, response) in
      let value = try decoder.decode(Value.self, from: data)
      return Response(value: value, response: response)
    }
  }
}
