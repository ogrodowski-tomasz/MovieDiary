//
//
// File.swift
// CoreNetwork
//
// Created by Tomasz Ogrodowski on 11/03/2026
// Copyright © 2026 Tomasz Ogrodowski. All rights reserved.
//
        

import Foundation

public enum HTTPError: Error {
    case invalidRequest(Endpoint)
    case invalidJsonData(Endpoint, Error)
}
