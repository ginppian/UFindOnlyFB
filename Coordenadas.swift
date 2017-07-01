//
//  Coordenadas.swift
//  UFind
//
//  Created by ginppian on 11/03/17.
//  Copyright © 2017 ginppian. All rights reserved.
//

import Foundation

class Coordenadas {
    static let sharedInstance = Coordenadas()
    
    
    private var longitud = ""
    private var latitud = ""
    
    func getLongi() -> String {
        return longitud
    }
    
    func getLati() -> String {
        return latitud
    }
    
    func setLongi(longi: String) {
        longitud = longi
    }
    
    func setLati(lati: String) {
        latitud = lati
    }
    
    private init () {
        
    }
    
}
