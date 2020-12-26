//
//  Pagination.swift
//  
//
//  Created by Ivan Lisovyi on 26.12.20.
//

import Foundation

import Combine
import ComposableArchitecture

public typealias PaginationItem = Hashable & Identifiable & Comparable

public struct PaginationError: LocalizedError, Equatable, Identifiable {
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

public enum PaginationAction<Item: PaginationItem>: Equatable {
  case first
  case next(after: Item.ID)

  case response(Result<[Item], PaginationError>)
}

public struct PaginationState<Item: PaginationItem>: Equatable {
  public var items: [Item]

  public var current: Int
  public var requested: Int

  public var limit: Int
  public var threshold: Int

  public var isInflight: Bool {
    requested == current + 1
  }

  public init(
    items: [Item] = [],
    current: Int = 1,
    requested: Int = 1,
    limit: Int = 20,
    threshold: Int? = nil
  ) {
    self.items = items
    self.current = current
    self.requested = requested
    self.limit = limit
    self.threshold = threshold ?? max(1, limit / 2)
  }
}

public struct PaginationEnvironment<Item: PaginationItem>  {
  let fetch: (Int, Int) -> AnyPublisher<[Item], PaginationError>
  let mainQueue: AnySchedulerOf<DispatchQueue>

  public init(
    fetch: @escaping (Int, Int) -> AnyPublisher<[Item], PaginationError>,
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.fetch = fetch
    self.mainQueue = mainQueue
  }
}

public extension Reducer {
  func pagination<Item>(
    state: WritableKeyPath<State, PaginationState<Item>>,
    action: CasePath<Action, PaginationAction<Item>>,
    environment: @escaping (Environment) -> PaginationEnvironment<Item>
  ) -> Reducer where Item: Equatable {
    .combine(
      self,
      Reducer<PaginationState<Item>, PaginationAction<Item>, PaginationEnvironment<Item>> {
        state, action, environment in
        switch action {
        case .first:
          state.requested = 1

          return paginatedFetchEffect(
            environment: environment,
            state: state,
            skipDeduplication: true
          )

        case let .next(id):
          guard let index = state.items.firstIndex(where: { $0.id == id }),
             index >= state.items.count - state.threshold,
             !state.isInflight else {
            return .none
          }
          
          state.requested = state.current + 1

          return paginatedFetchEffect(
            environment: environment,
            state: state
          )

        case let .response(.success(items)):
          state.current = state.requested

          if state.current == 1 {
            state.items = items
          } else {
            state.items.append(contentsOf: items)
          }

          return .none

        case .response(.failure):
          return .none
        }
      }
      .pullback(state: state, action: action, environment: environment)
    )
  }
}

func paginatedFetchEffect<Item: PaginationItem>(
  environment: PaginationEnvironment<Item>,
  state: PaginationState<Item>,
  skipDeduplication: Bool = false
) -> Effect<PaginationAction<Item>, Never> {
  var effect: AnyPublisher<[Item], PaginationError> = environment.fetch(state.requested, state.limit)

  if !skipDeduplication {
    effect = Effect(value: state.items.suffix(state.limit)).zip(effect)
      .map { old, new in Array(Set(new).subtracting(old)).sorted(by: >) }
      .eraseToAnyPublisher()
  }

  return effect
    .receive(on: environment.mainQueue)
    .catchToEffect()
    .map(PaginationAction.response)
}
