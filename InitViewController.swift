//
//  InitViewController.swift
//  UFind
//
//  Created by ginppian on 07/03/17.
//  Copyright © 2017 ginppian. All rights reserved.
//

import UIKit
import CoreLocation
import MBProgressHUD
import SwiftyJSON

class InitViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {

    //MARK: - Outlets
    //Search Bar 🔎
    @IBOutlet weak var textField: TintTextField!
    
    //MARK: - Location
    private var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Dismiss keyboard
        self.hideKeyboardWhenTappedAround()
        
        //Keyboard Buscar Button
        //Search Bar 🔎
        textField.delegate = self
        
        //Location
        switch CLLocationManager.authorizationStatus() {
            
        //Autorizo
        case .authorizedWhenInUse:
            
            let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressHUD.label.text = "Ubicación..."
            
            //Activity
            DispatchQueue.global(qos: .background).async {
                print("This is run on the background queue")
                
                //Ubicacion 📍
                self.locationManager.requestWhenInUseAuthorization()
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.requestLocation()
                
                DispatchQueue.main.async {
                    print("This is run on the main queue, after the previous code in outer block")
                    
                }
            }
            
        //No autorizo
        case .denied:
            print("denegado")
            
            //Crear alerta
            let alertController = UIAlertController(title: Alerta.sharedInstance.ubicacion(), message: Alerta.sharedInstance.ubicacionRequerida(), preferredStyle: .alert)
            
            //Cancelar
            let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            alertController.addAction(cancelar)
            
            //Preferencias de usuario
            let activar = UIAlertAction(title: "Activar", style: .default, handler: { (action: UIAlertAction!) in
                
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                }
                
            })
            alertController.addAction(activar)
            
            //Show alert
            present(alertController, animated: true, completion: nil)
            
        //Default
        default:
            print("Primera vez")
            
            let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressHUD.label.text = "Ubicación..."
            
            //Activity
            DispatchQueue.global(qos: .background).async {
                print("This is run on the background queue")
                
                //Ubicacion 📍
                self.locationManager.requestWhenInUseAuthorization()
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.requestLocation()
                
                DispatchQueue.main.async {
                    print("This is run on the main queue, after the previous code in outer block")
                    
                }
            }
            
            //End activity
            
        //End Switch
        }
    }
    
    //MARK: - Location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("entra location manager...")
        
        if let location = locations.first {
            
            //Ocultamos animacion
            hideLoadingHUD()
            
            //Conseguimos localizacion
            print("Found user's location: \(location)")
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            
            //Obtenemos las coordenadas
            let latitud = "\(locValue.latitude)"
            let longitud = "\(locValue.longitude)"
            
            //Guardamos en una instancia global
            Coordenadas.sharedInstance.setLati(lati: latitud)
            Coordenadas.sharedInstance.setLongi(longi: longitud)
            
            print("Latitud: \(Coordenadas.sharedInstance.getLati())")
            print("Longitud: \(Coordenadas.sharedInstance.getLongi())")
            
        }
    
    }
    
    //Error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(error.localizedDescription)

        //Hide Activity
        self.hideLoadingHUD()
        
        //Crear alerta
        let alertController = UIAlertController(title: Alerta.sharedInstance.ubicacion(), message: Alerta.sharedInstance.ubicacionRequerida(), preferredStyle: .alert)
        
        //Cancelar
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelar)
        
        //Preferencias de usuario
        let activar = UIAlertAction(title: "Activar", style: .default, handler: { (action: UIAlertAction!) in
            
            if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
            
        })
        alertController.addAction(activar)
        
        //Show alert
        present(alertController, animated: true, completion: nil)
        
    }
    
    //Search Bar 🔎
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.returnKeyType==UIReturnKeyType.search)
        {
            print("Search go...")
            print(textField.text!)
            textField.resignFirstResponder()
            
            performSegue(withIdentifier: "segueInitNegocios", sender: self)
            
        }
        return true
    }
    //func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    //    print(searchBar.text!)
    //    searchBar.resignFirstResponder()
    //
    //    performSegue(withIdentifier: "segueInitNegocios", sender: self)
    //}
    
    //Hide navigation bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
        //Search Bar 🔎
        //Cambiamos el estilo por uno custom: TintTextField
        self.textField.layer.borderColor = UIColor.white.cgColor
        self.textField.tintColor = UIColor.white
        self.textField.textColor = UIColor.white
        
        self.textField.text = ""
    }
    
    //Hide navigation bar
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.textField.becomeFirstResponder()
        
    }
    
    //Activity On
    private func showLoadingHUD() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "Loading..."
    }
    //Activity Off
    private func hideLoadingHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueInitNegocios" {
            let vc = segue.destination as! HomeViewController
            let texto = textField.text!
            let newString = texto.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
            print(newString)
            vc.descripcion = newString
            
        }
    }
 

}
