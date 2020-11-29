//
//  SessionError.swift
//  
//
//  Created by Lisovyi, Ivan on 29.11.20.
//

import Foundation

/// An error enum used to throw networking-related errors
public enum SessionError: Error, Equatable {
    // Unknown error containing a description
    case unknown(String)

    // Error related to the building of the url
    case invalidURL

    // A networking error containing the localized description of the error
    case network(String)

    // An adapter failed to modify the request
    case adapter(String)
}

extension SessionError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknown(let description):
            return description
        case .invalidURL:
            return "Invalid URL"
        case .network(let description):
            return description
        case .adapter(let description):
            return description
        }
    }
}
