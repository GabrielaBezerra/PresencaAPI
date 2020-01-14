//
//  Presenca.swift
//  
//
//  Created by Mateus Rodrigues on 14/01/20.
//

import Foundation

import Vapor
import Fluent
import FluentSQLite

final class Presenca: SQLiteModel {
    var id: Int?
    var nome: String
    var hora: Date?
    
    static var createdAtKey: TimestampKey? { return \.hora }

    
}

extension Presenca: Migration {
    static func prepare(on connection: SQLiteConnection) -> EventLoopFuture<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.unique(on: \.nome)
        }
    }
}

extension Presenca: Content { }
