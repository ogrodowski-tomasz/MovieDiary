//
//
// File.swift
// CoreEnvironment
//
// Created by Tomasz Ogrodowski on 11/03/2026
// Copyright © 2026 Tomasz Ogrodowski. All rights reserved.
//
        

import Foundation

public struct TVSpecificListModel: Decodable, Sendable, Hashable, Identifiable {
    public let id: Int
    public let overview: String?
    public let poster_path: String?
    public let first_air_date: String
    public let name: String
    public let vote_average: Double?
}
