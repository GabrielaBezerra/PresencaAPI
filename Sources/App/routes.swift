import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    let presencaController = PresencaController()

    router.group("presenca") { (group) in
       group.post("assinar", use: presencaController.assinar)
       group.get("listar", use: presencaController.listar)
    }

}
