//
//  Download.swift
//  
//
//  Created by Ivan Lisovyi on 04.01.21.
//

import Foundation
import ComposableArchitecture

struct DownloadState<ID: Hashable>: Equatable {
  let id: ID
  let url: URL

  var mode: DownloadStatus
}

enum DownloadStatus: Equatable {
  case downloaded
  case downloading(progress: Double)
  case notDownloaded
  case startingToDownload

  var progress: Double {
    if case let .downloading(progress) = self {
      return progress
    }

    return 0
  }

  var isDownloading: Bool {
    switch self {
    case .downloaded, .notDownloaded:
      return false
    case .downloading, .startingToDownload:
      return true
    }
  }
}

enum DownloadAction: Equatable {
  case downloadTapped
  case downloadResponse(Result<DownloadClient.Action, DownloadClient.Error>)
}

struct DownloadEnvironment {
  var downloadClient: DownloadClient
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

struct DownloadClient {
  var cancel: (AnyHashable) -> Effect<Never, Never>
  var download: (AnyHashable, URL) -> Effect<Action, Error>

  struct Error: Swift.Error, Equatable {}

  enum Action: Equatable {
    case response(Data)
    case updateProgress(Double)
  }
}

extension Reducer {
  func downloadable<ID: Hashable>(
    state: WritableKeyPath<State, DownloadState<ID>>,
    action: CasePath<Action, DownloadAction>,
    environment: @escaping (Environment) -> DownloadEnvironment
  ) -> Reducer {
    .combine(
      Reducer<DownloadState<ID>, DownloadAction, DownloadEnvironment> {
        state, action, environment in
        switch action {
        case .downloadTapped:
          switch state.mode {
          case .downloaded, .downloading:
            return .none

          case .notDownloaded:
            state.mode = .startingToDownload
            return environment.downloadClient
              .download(state.id, state.url)
              .throttle(for: 1, scheduler: environment.mainQueue, latest: true)
              .catchToEffect()
              .map(DownloadAction.downloadResponse)

          case .startingToDownload:
            return .none
          }

        case .downloadResponse(.success(.response)):
          state.mode = .downloaded
          return .none

        case let .downloadResponse(.success(.updateProgress(progress))):
          state.mode = .downloading(progress: progress)
          return .none

        case .downloadResponse(.failure):
          state.mode = .notDownloaded
          return .none
        }
      }
      .pullback(state: state, action: action, environment: environment),
      self
    )
  }
}
