//
//  PostsRequests.swift
//  
//
//  Created by Ivan Lisovyi on 27.12.20.
//

import Foundation

public struct PostsRequest: Codable, Equatable {
  public enum AssociatedAttributes: String, Codable {
    case uploader
    case updater
    case approver
    case parent
    case children
    case upload
    case artistCommentary = "artist_commentary"
    case notes
    case comments
    case flags
    case appeals
    case approvals
    case replacements
  }

  public let page: Int
  public let limit: Int

  public let tags: String?
  public let only: String?

  public init(
    page: Int,
    limit: Int,
    tags: [Tag]? = nil,
    only: [AssociatedAttributes]? = nil
  ) {
    self.page = page
    self.limit = limit
    self.tags = tags?.joined(separator: "+")
    self.only = only?.map(\.rawValue).joined(separator: ",")
  }
}
