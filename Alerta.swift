//
//  Alerta.swift
//  UFind
//
//  Created by ginppian on 01/03/17.
//  Copyright © 2017 ginppian. All rights reserved.
//

import Foundation

struct Alerta {
    static let sharedInstance = Alerta()
    
    func alerta() -> String {
        return "Alerta ⚠️"
    }

    func errorServidoresLogInFb() -> String {
        return "Nuestros servidores están presentando problemas\npor favor haz Log Out en el boton de FaceBook e\nintenta más tarde."
    }
    
    func errorExisteCuentaFb() -> String {
        return "Al parecer esta cuenta ya está siendo usuada\n por favor intente con otro usuario."
    }
    
    func error() -> String {
        return "🛑 Error"
    }
    
    func conexion() -> String {
        return "Conexión ⚠️"
    }
    
    func exito() -> String {
        return "✅ Éxito"
    }
    
    func verificarConexion() -> String {
        return "Verfifique su conexión a internet"
    }
    
    func completarCampos() -> String {
        return "Por favor complete todos los campos correctamente"
    }
    
    func emailIncorrecto() -> String {
        return "Por favor ingrese un email válido"
    }
    
    func existe() -> String {
        return "Existe 😎"
    }
    
    func usuarioExistente() -> String {
        return "Ya existe un usuario registrado con este correo\n por favor regresa al apartado: Iniciar Sesión"
    }
    
    func servidoresFallando() -> String {
        return "Error Servicio 😔"
    }
    
    func errorServicios() -> String {
        return "Nuestros servidores están presentando problemas\ndisculpa las molestias\npor favor intentá más tarde."
    }
    
    func terminos() -> String {
        return "📙 Terminos y Condiciones"
    }
    
    func aceptarTerminos() -> String {
        return "Al hacer click en Aceptar usted está aceptando nuestra política de terminos y condiciones."
    }
    
    func usuarioNoRegistrado() -> String {
        return "El usuario no se encutra registrado\npor favor regresa al apartado: Registro o Registro con FaceBook"
    }
    
    func password() -> String {
        return "🔐 Contraseña"
    }
    
    func passInvalida() -> String {
        return "Su contraseña es invalida por favor verifique nuevamente\no vaya al apartado: Olvidé mi contraseña."
    }
    
    func passEnviada() -> String {
        return "Se envió la contraseña correctamente a su correo electrónico\npor favor regrese al apartado: Iniciar Sesión"
    }
    
    func ubicacion() -> String {
        return "Ubicación 📍"
    }
    
    func ubicacionRequerida() -> String {
        return "Tu ubicación es requerida para mostrar los negocios más cercanos"
    }
    
    func ubicacionError(error: String) -> String {
        return "Ocurrio un error al obtener tu ubicacón: \(error)"
    }
    
    func buscar() -> String {
        return "🕵🏻 Busqueda"
    }
    
    func noEmail() -> String {
        return "📧 No se pudeo enviar Email"
    }
    
    func noEmailConfi() -> String {
        return "El dispositivo no pudo enviar el Email, por favor la configuración de tu Email e intenta de nuevo"
    }
    
    func whats() -> String {
        return "📞 Abrir WhatsApp"
    }
    
    func whatsAlert() -> String {
        return "Para enviar un mensaje debe tener agregado este contacto, desea copiar este número en el portapapeles o ir a la aplicación"
    }
    func favoritos() -> String {
        return "⭐️ Favoritos"
    }
    func favoritosAlta() -> String {
        return "Se agrego correctamente al Favoritos"
    }
    func iosDevelop() -> String {
        return "📱 iOS Developer"
    }
    func noResultados() -> String {
        return "No se encontraron resultados"
    }
}

//let messageDatosIncorrectos = "Datos Incorrectos"
//let usuarioExiste = "Ya existe un usuario registrado con este correo"
//let creadoExito = "Usuario creado con éxito\npor favor regrese al menú inicio de sesión"
//let creadoSinExito = "Ocurrio algo al crear su usuario 😔\npor favor intente nuevamente"
//let completarCampos = "Por favor complete todos los campos"



