//
//  Usuario.swift
//  UFind
//
//  Created by ginppian on 27/02/17.
//  Copyright © 2017 ginppian. All rights reserved.
//

import UIKit

class Usuario: NSObject {
    var id = Int()
    var arrayFavoritos = [Int]()
    var foto = String()
    var nombre = String()
    var paterno = String()
    var materno = String()
    var genero = String()
    var nacimiento = String()
    var telefono = String()
    var email = String()
    var contrasenia = String()
    var tipoAutentificacion = Int()
    var pass = String()
    var sesion = String()//open or close for session
}
