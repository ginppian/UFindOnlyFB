//
//  objNegocio.swift
//  UFind
//
//  Created by ginppian on 13/03/17.
//  Copyright © 2017 ginppian. All rights reserved.
//

import Foundation

class objNegocio {

    //Estado
    var estatus = Int()
    var detalleError = String()
    var negocioId = Int()

    //Datos generales
    var logotipo = String()
    
    var negocio = String()
    
    var direccion = String()
    var longitud = String()
    var latitud = String()

    var telefono = String()
    var whatsApp = String()
    var sitioWeb = String()
    var correoElectronico = String()

    var efectivo = Bool(false)
    var tarjetaMasterCard = Bool(false)
    var tarjetaVisa = Bool(false)
    var tarjetaAmex = Bool(false)

    var facebook = String()
    var twitter = String()
    var instagram = String()
    
    //Descripcion
    var descripcion = String()

    //ProductoServicio
    var productoServicio = String()

    //Galeria
    var galeria = [String]()

    //Promociones
    var promociones = [[String:AnyObject]]()
    
    //Favorito
    var esFavorito = Bool(false)

}
