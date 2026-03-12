//
//
// File.swift
// CoreNetwork
//
// Created by Tomasz Ogrodowski on 11/03/2026
// Copyright © 2026 Tomasz Ogrodowski. All rights reserved.
//
        

import Foundation

public enum ClientEnvironment {
    case prod
    case mock

    var host: String {
        "api.themoviedb.org"
    }

    var subsystem: String {
        switch self {
        case .prod:
            "HTTPClient"
        case .mock:
            "MockHTTPClient"
        }
    }
}
