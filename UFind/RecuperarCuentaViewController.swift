//
//  RecuperarCuentaViewController.swift
//  UFind
//
//  Created by ginppian on 28/02/17.
//  Copyright © 2017 ginppian. All rights reserved.
//

import UIKit
import Alamofire
import Alamofire_Synchronous
import MBProgressHUD


class RecuperarCuentaViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var enviar: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        applyViewsLayerOptions()
        self.hideKeyboardWhenTappedAround()

        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0

    }
    
    @IBAction func enviarAction(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork()
        {
            print("Internet Connection Available!")
            
            let email = self.textField.text
            
            if self.isValidEmail(testStr: email!) {
            
                //Activity
                showLoadingHUD()
                DispatchQueue.global(qos: .background).async {
                    print("This is run on the background queue")
                    
                    //Servicio
                    let enviarPass = self.enviarPassA(email: email!)
                    if enviarPass {
                        
                        //UI
                        DispatchQueue.main.async {
                            self.hideLoadingHUD()
                            self.customAlert(title: Alerta.sharedInstance.exito(), message: Alerta.sharedInstance.passEnviada())
                        }

                    }
                    
                }

            } else {
                
                self.customAlert(title: Alerta.sharedInstance.alerta(), message: Alerta.sharedInstance.emailIncorrecto())
                
            //Email no valido
            }
            
        //No hay red
        }
        else
        {
            self.customAlert(title: Alerta.sharedInstance.conexion(), message: Alerta.sharedInstance.verificarConexion())
        }
    }
    
    //Enviar contrasena a correo
    func enviarPassA(email:String) -> Bool {
    
        var bandera = false
        
        let link = Servicio.sharedInstance.enviaContrasenia(email: email)
        let url = link.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        let response = Alamofire.request(url!, method: .post, parameters: nil).responseJSON(options: .allowFragments)
        if let json = response.result.value {
            print(json)
            
            //Casteamos
            let JSON = json as! [String: AnyObject]
            
            //Obtenemos estatus
            let estatus = JSON["estatus"] as! Int
            
            //No existe el usuario puedo crearlo
            if estatus == 1  {
                
                bandera = true
            
            }
            
            if estatus == 0 {
                let detalleError = JSON["detalleError"] as! String
                self.customAlert(title: Alerta.sharedInstance.error(), message: detalleError)
            }
            
//            DispatchQueue.main.async {
//                self.hideLoadingHUD()
//            }
        }
        return bandera
    }
    //Mail valido
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    //Views Buttons Border Radious
    func applyViewsLayerOptions(){
        borderRadiousView(view: self.enviar, radio: 8.0, opacity: 0.0)
    }
    //BorderRadious
    func borderRadiousView(view:UIView, radio:Float, opacity:Float){
        view.layer.cornerRadius = CGFloat(radio)
        view.layer.shadowOpacity = opacity
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
    
    //Hidden navigation bar
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
