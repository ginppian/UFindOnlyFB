//
//  Servicio.swift
//  UFind
//
//  Created by ginppian on 27/02/17.
//  Copyright © 2017 ginppian. All rights reserved.
//

import Foundation

struct Servicio {
    static let sharedInstance = Servicio()
    
    func existeUsuario(email:String) -> String{
        
        //let service = "http://cuvitek.no-ip.net:41133/api/Usuario/ExisteUsuario?"
        //let parameters = "correoElectronico=\(email)"
        
        let service = "http://www.ufind.com.mx:12345/uFind/api/Usuario/ExisteUsuario?"
        let parameters = "correoElectronico=\(email)"
        
        let url = "\(service)\(parameters)"
        print("url: \(url)")
        
        return url
    }
    
    func actualizaUsuarioXAutenticacion(email:String, contrasenia:String, tipoAutentificacion:Int) -> String {
        
        //let service = "http://cuvitek.no-ip.net:41133/api/Usuario/ActualizaUsuarioXAutenticacion?"
        //let parameters = "correoElectronico=\(email)&contrasenia=\(contrasenia)&tipoAutenticacion=\(tipoAutentificacion)"

        let service = "http://www.ufind.com.mx:12345/uFind/api/Usuario/ActualizaUsuarioXAutenticacion?"
        let parameters = "correoElectronico=\(email)&contrasenia=\(contrasenia)&tipoAutenticacion=\(tipoAutentificacion)"
        
        let url = "\(service)\(parameters)"
        print("url: \(url)")
        
        return url
    }
    
    func crearUsuario(email:String, contrasenia:String, nombre:String, paterno:String, materno:String, nacimiento:String, genero:String, telefono:String, tipoAutenticacion:Int, activo:Bool) -> String{
        
        var activo2 = String()
        
        if activo {
            activo2 = "true"
        } else {
            activo2 = "false"
        }
    
        //let service = "http://cuvitek.no-ip.net:41133/api/Usuario/CreaUsuario?"
        //let parameters = "correoElectronico=\(email)&contrasenia=\(contrasenia)&nombre=\(nombre)&apellidoPaterno=\(paterno)&apellidoMaterno=\(materno)&fechaNacimiento=\(nacimiento)&genero=\(genero)&telefonoMovil=\(telefono)&tipoAutenticacion=\(tipoAutenticacion)&activo=\(activo2)"
        
        let service = "http://www.ufind.com.mx:12345/uFind/api/Usuario/CreaUsuario?"
        let parameters = "correoElectronico=\(email)&contrasenia=\(contrasenia)&nombre=\(nombre)&apellidoPaterno=\(paterno)&apellidoMaterno=\(materno)&fechaNacimiento=\(nacimiento)&genero=\(genero)&telefonoMovil=\(telefono)&tipoAutenticacion=\(tipoAutenticacion)&activo=\(activo2)"
        
        let url = "\(service)\(parameters)"
        print("url: \(url)")
        
        return url
    }
    
    func autenticacion(email:String, contrasenia:String) -> String {
        
        //let service = "http://cuvitek.no-ip.net:41133/api/Usuario/Autenticacion?"
        //let parameters = "correoElectronico=\(email)&contrasenia=\(contrasenia)"
        
        let service = "http://www.ufind.com.mx:12345/uFind/api/Usuario/Autenticacion?"
        let parameters = "correoElectronico=\(email)&contrasenia=\(contrasenia)"
        
        let url = "\(service)\(parameters)"
        print("url: \(url)")
        
        return url
    }
    
    func obtenUsuarioXCorreoElectronico(email:String) -> String {

        //let service = "http://cuvitek.no-ip.net:41133/api/Usuario/ObtenUsuarioXCorreoElectronico?"
        //let parameters = "correoElectronico=\(email)"
        
        let service = "http://www.ufind.com.mx:12345/uFind/api/Usuario/ObtenUsuarioXCorreoElectronico?"
        let parameters = "correoElectronico=\(email)"
        
        let url = "\(service)\(parameters)"
        print("url: \(url)")
        
        return url
    }
    
    func enviaContrasenia(email:String) -> String {
        
        //let service = "http://cuvitek.no-ip.net:41133/api/Usuario/EnviaContrasenia?"
        //let parameters = "correoElectronico=\(email)"
        
        let service = "http://www.ufind.com.mx:12345/uFind/api/Usuario/EnviaContrasenia?"
        let parameters = "correoElectronico=\(email)"
        
        let url = "\(service)\(parameters)"
        print("url: \(url)")
        
        return url
    }
    
    func negocioObtenCategorias () -> String {
        
        let service = "http://www.ufind.com.mx:12345/ufind/api/Negocio/ObtenCategorias"
        let parameters = ""
        
        let url = "\(service)\(parameters)"
        print("url: \(url)")
        
        return url
    }
    
    func obtenerNegociosPor(categoria: String, numeroPagina: String, latitud: String, longitud: String) -> String {
        let service = "http://www.ufind.com.mx/api/businessByCategory?"
        let parameters = "categoria=\(categoria)&numeroPagina=\(numeroPagina)&latitud=\(latitud)&longitud=\(longitud)"
        
        let url = "\(service)\(parameters)"
        print("url: \(url)")
        
        return url
    }
    
    func obtenerNegocioPor(descripcion: String, numeroPagina: String, latitud: String, longitud: String) -> String {
        let service = "http://www.ufind.com.mx/api/businessByDescription?"
        let parameters = "descripcion=\(descripcion)&numeroPagina=\(numeroPagina)&latitud=\(latitud)&longitud=\(longitud)"
        
        let url = "\(service)\(parameters)"
        print("url: \(url)")
        
        return url
    }
    
    func obtenNegocioX(id: String) -> String {
        let service = "http://www.ufind.com.mx:12345/uFind/api/Negocio/ObtenNegocioXId?"
        let parameters = "negocioId=\(id)"
        
        let url = "\(service)\(parameters)"
        print("url: \(url)")
        
        return url
    }
    
    func obtenEventoPaginadoXCategoriaId(categoriaId: String, numeroPagina: String) -> String {
        let service = "http://www.ufind.com.mx:12345/uFind/api/Evento/ObtenEventosPaginadosXCategoriaId?"
        let parameters = "categoriaId=\(categoriaId)&numeroPagina=\(numeroPagina)"
        
        let url = "\(service)\(parameters)"
        print("url: \(url)")
        
        return url
    }
    
    func obtenUsuarioXCorreoElectronico(correoElectronico: String) -> String {
        let service = "http://www.ufind.com.mx:12345/uFind/api/Usuario/ObtenUsuarioXCorreoElectronico?"
        let parameters = "correoElectronico=\(correoElectronico)"
        
        let url = "\(service)\(parameters)"
        print("url: \(url)")
        
        return url
    }

    func obtenNegociosFavoritosXUsuarioId(usuarioId: String) -> String {
        let service = "http://www.ufind.com.mx:12345/uFind/api/Negocio/ObtenNegociosFavoritosXUsuarioId?"
        let parameters = "usuarioId=\(usuarioId)"
        
        let url = "\(service)\(parameters)"
        print("url: \(url)")
        
        return url
    }

    func eliminarNegocioFavorito(negocioId: String, usuarioId: String) -> String {
        let service = "http://www.ufind.com.mx:12345/uFind/api/Negocio/EliminaNegocioFavorito?"
        let parameters = "negocioId=\(negocioId)&usuarioId=\(usuarioId)"
        
        let url = "\(service)\(parameters)"
        print("url: \(url)")
        
        return url
    }
    
    func registraNegocioFavorito(negocioId: String, usuarioId: String) -> String {
        let service = "http://www.ufind.com.mx:12345/uFind/api/Negocio/RegistraNegocioFavorito?"
        let parameters = "negocioId=\(negocioId)&usuarioId=\(usuarioId)"
        
        let url = "\(service)\(parameters)"
        print("url: \(url)")
        
        return url
    }
    
    func obtenPromocionesPaginadasXCategoriaId(categoriaId: String, numeroPagina: String) -> String {
        let service = "http://www.ufind.com.mx:12345/uFind/api/Promocion/ObtenPromocionesPaginadasXCategoriaId?"
        let parameters = "categoriaId=\(categoriaId)&numeroPagina=\(numeroPagina)"
        
        let url = "\(service)\(parameters)"
        print("url: \(url)")
        
        return url
    }
    
}


























