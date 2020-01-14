//
//  PresencaController.swift
//  
//
//  Created by Mateus Rodrigues on 14/01/20.
//

import Vapor
import FluentSQLite

final class PresencaController {
    
    func assinar(_ req: Request) throws -> Future<Presenca> {
        return try req.content.decode(Presenca.self).flatMap { presenca in
            return presenca.save(on: req).catchMap { (error) -> (Presenca) in
                if error.localizedDescription.lowercased().contains("sqliteerror.constraint") {
                    throw Abort(.forbidden, reason: "Presença já assinada!")
                } else {
                    throw Abort(.internalServerError, reason: error.localizedDescription)
                }
            }
        }
    }
    
    func listar(_ req: Request) throws -> Future<[Presenca]> {
        return Presenca.query(on: req).all()
    }
    
}
