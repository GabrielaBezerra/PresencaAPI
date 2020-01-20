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
        
        let all: EventLoopFuture<[Presenca]> = Presenca.query(on: req).all()
        
        let filteredResult: Future<[Presenca]> = all.map { (presencas) -> ([Presenca]) in
            return presencas.filter { Calendar.current.isDateInToday($0.hora!) }
        }
        
        return filteredResult.flatMap { (presencasDeHoje) -> EventLoopFuture<Presenca> in
            
            return try req.content.decode(Presenca.self).flatMap { presenca in
                
                if presencasDeHoje.contains(where: { $0.nome == presenca.nome }) {
                    
                    throw Abort(.forbidden, reason: "Presença já assinada!")
                    
                } else {
                    
                    return presenca.save(on: req).catchMap { (error) -> (Presenca) in
                        if error.localizedDescription.lowercased().contains("sqliteerror.constraint") {
                            throw Abort(.forbidden, reason: "Presença já assinada!")
                        } else {
                            throw Abort(.internalServerError, reason: error.localizedDescription)
                        }
                    }
                    
                }
            }
            
        }
       
    }
    
    func listar(_ req: Request) throws -> Future<[Presenca]> {
        
        let all: EventLoopFuture<[Presenca]> = Presenca.query(on: req).all()
        
        let filteredResult: EventLoopFuture<[Presenca]> = all.map { (presencas) -> ([Presenca]) in
            return presencas.filter { Calendar.current.isDateInToday($0.hora!) }
        }
        
        return filteredResult
    }
    
}
