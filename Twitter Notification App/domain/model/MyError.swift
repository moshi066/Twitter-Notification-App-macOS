//
//  MyError.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 11/3/23.
//

import Foundation

public enum MyError: Error, CustomStringConvertible, LocalizedError {

    case invocationFailed(reason: (message: String?, statusCode: Int))

    public var description: String {
        switch self {
        case .invocationFailed(let reason):
            return reason.message ?? "Unknown error."
        }
    }

    public var errorDescription: String? {
        switch self {
        case .invocationFailed(let reason):
            return reason.message
        }
    }
}
