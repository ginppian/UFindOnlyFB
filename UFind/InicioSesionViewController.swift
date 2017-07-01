//
//  InicioSesionViewController.swift
//  UFind
//
//  Created by ginppian on 28/02/17.
//  Copyright © 2017 ginppian. All rights reserved.
//

import UIKit
import Alamofire
import Alamofire_Synchronous
import MBProgressHUD

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboardView() {
        view.endEditing(true)
    }
}
class InicioSesionViewController: UIViewController {

    @IBOutlet weak var login: UIView!
    @IBOutlet weak var olvidePass: UIView!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPass: UITextField!
    
    //MARK: - Constructor
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyViewsLayerOptions()
        self.hideKeyboardWhenTappedAround()
        
    }
    //MARK: - Shake Gesture
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        print("Device was shaken!")
    }
    
    func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if(event?.subtype == .motionShake) {
            print("You shook me, now what")
        }
    }
    //Enviar
    @IBAction func loginAction(_ sender: UIButton) {
        print("loginAction")
        
        //Checamos la conexion a internet
        if Reachability.isConnectedToNetwork()
        {
            print("Connection Available!")
            
            //Activity
            self.showLoadingHUD()
            
            //Thread
            DispatchQueue.global(qos: .background).async {
                print("This is run on the background queue")
                
                //Obtenemos los datos
                let email = self.tfEmail.text
                let pass = self.tfPass.text
                
                //Validacion email
                if self.isValidEmail(testStr: email!)
                {
                    
                    let link = Servicio.sharedInstance.existeUsuario(email: email!)
                    //let url = link.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                    
                    //Enviamos...
                    let response = Alamofire.request(link, parameters: nil).responseJSON()
                    if let json = response.result.value
                    {
                        print(json)
                        
                        //Casteamos
                        let JSON = json as! [String: AnyObject]
                        
                        //Obtenemos banderas
                        let estatus = JSON["estatus"] as! Int
                        let objetoResultado = JSON["objetoResultado"] as! Bool
                        
                        //No existe el usuario
                        if estatus == 1 && objetoResultado == false {
                            
                            //UI
                            DispatchQueue.main.async {
                                self.hideLoadingHUD()
                                
                            }
                            
                            self.customAlert(title: Alerta.sharedInstance.alerta(), message: Alerta.sharedInstance.usuarioNoRegistrado())
                            
                        }
                        
                        //Si Existe el usuario
                        if estatus == 1 && objetoResultado == true {
                            
                            //Autenticamos
                            if self.autenticacion(email: email!, pass: pass!) {
                                
                                
                                //Persistencia Datos
                                let usr = self.obtenerUsuarioPor(email: email!)
                                
                                //Si los datos no vienen vacios
                                if usr.email != "" {
                                    
                                    //Creamos diccionario
                                    usr.sesion = "on"
                                    let dict = self.crearDiccionario(email: usr.email, nombre: usr.nombre, paterno: usr.paterno, materno: usr.materno, genero: usr.genero, sesion: usr.sesion)
                                    
                                    //Guardamos
                                    self.persistenciaUserData(dictionary: dict)
                                    
                                    //Activity
                                    //UI
                                    DispatchQueue.main.async {
                                        
                                        self.hideLoadingHUD()
                                        
                                        //Mandamos a Home
                                        self.performSegue(withIdentifier: "segueLoginHome", sender: self)
                                    }

                                    
                                //Si los datos vienen vacios
                                } else {
                                    
                                    //Activity
                                    DispatchQueue.main.async {
                                        self.hideLoadingHUD()
                                        
                                    }
                                    
                                    self.customAlert(title: Alerta.sharedInstance.servidoresFallando(), message: Alerta.sharedInstance.errorServicios())
                                    
                                }
                                
                            //Sino existe el usuario
                            } else {
                                
                                //Activity
                                DispatchQueue.main.async {
                                    self.hideLoadingHUD()
                                    
                                }
                                
                                //Datos incorrectos
                                self.customAlert(title: Alerta.sharedInstance.password(), message: Alerta.sharedInstance.passInvalida())
                                
                            }
                            
                        }
                        
                        //Error servicios
                        if estatus != 1 {
                            
                            //Activity
                            DispatchQueue.main.async {
                                self.hideLoadingHUD()
                                
                            }
                            
                            self.customAlert(title: Alerta.sharedInstance.servidoresFallando(), message: Alerta.sharedInstance.errorServicios())
                            
                        }
                        
                        //Sino es capaz de regresar un JSON
                    } else {
                        
                        //Activity
                        DispatchQueue.main.async {
                            self.hideLoadingHUD()
                            
                        }
                        
                        self.customAlert(title: Alerta.sharedInstance.servidoresFallando(), message: Alerta.sharedInstance.errorServicios())
                        
                    }
                    
                //Validar email
                }
                else {
                    
                    self.customAlert(title: Alerta.sharedInstance.alerta(), message: Alerta.sharedInstance.emailIncorrecto())
                    
                }
                
            }
            
        //Conexion
        }
        else {
            
            print("Internet Connection not Available!")
            self.customAlert(title: Alerta.sharedInstance.conexion(), message: Alerta.sharedInstance.verificarConexion())
            
        }
    }
    
    //Persistencia
    func persistenciaUserData(dictionary:[String : String]){
        
        UserDefaults.standard.set(dictionary, forKey: "userDataUFind")
        //let result = UserDefaults.standard.value(forKey: "userData")
        //print(result!)
    }
    
    //Obtener datos del usuario ya registrado
    func obtenerUsuarioPor(email:String) -> Usuario{
        
        let usr = Usuario()
        
        let link = Servicio.sharedInstance.obtenUsuarioXCorreoElectronico(email: email)
        let url = link.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        //Enviamos...
        let response = Alamofire.request(url!, parameters: nil).responseJSON()
        if let json = response.result.value {
            print(json)
            
            //Casteamos
            let JSON = json as! [String: AnyObject]
            
            //Obtenemos banderas
            let estatus = JSON["estatus"] as! Int
            
            //La autentificacion fue correcta, mandarlo a Home
            if estatus == 1 {
                
                let objetoResultado = JSON["objetoResultado"] as! [String: AnyObject]
                
                usr.email = objetoResultado["correoElectronico"] as! String
                usr.nombre = objetoResultado["nombre"] as! String
                usr.paterno = objetoResultado["apellidoPaterno"] as! String
                usr.materno = objetoResultado["apellidoMaterno"] as! String
                usr.genero = objetoResultado["genero"] as! String
                
            }
        }
        
        return usr
    }
    
    //Crear diccionario a partir de Usuario
    func crearDiccionario(email:String, nombre:String, paterno:String, materno:String, genero:String, sesion:String) -> [String:String] {
        
        let dict: [String: String] = ["email": email, "nombre": nombre, "paterno": paterno, "materno": materno, "genero": genero, "sesion":sesion]
        
        return dict
    }
    
    func autenticacion(email:String, pass:String) -> Bool {
        
        var bandera = false
        
        let link = Servicio.sharedInstance.autenticacion(email: email, contrasenia: pass)
        let url = link.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        //Enviamos...
        let response = Alamofire.request(url!, method: .post, parameters: nil).responseJSON(options: .allowFragments)
        if let json = response.result.value {
            print("json: \(json)")
            
            //Casteamos
            let JSON = json as! [String: AnyObject]
            
            //Obtenemos banderas
            let estatus = JSON["estatus"] as! Int
            //let objetoResultado = JSON["objetoResultado"] as! Bool
            
            //La autentificacion fue correcta, mandarlo a Home
            if estatus == 1 {
                bandera = true
            }
            
            if estatus == 0 {
                let detalleError = JSON["detalleError"] as! String
                self.customAlert(title: Alerta.sharedInstance.error(), message: detalleError)
            }
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
        borderRadiousView(view: self.login, radio: 8.0, opacity: 0.0)
        borderRadiousView(view: self.olvidePass, radio: 8.0, opacity: 0.0)
    }
    //BorderRadious
    func borderRadiousView(view:UIView, radio:Float, opacity:Float){
        view.layer.cornerRadius = CGFloat(radio)
        view.layer.shadowOpacity = opacity
    }
    
    @IBAction func olvidePassAction(_ sender: UIButton) {
        print("olvidePassAction")
        self.performSegue(withIdentifier: "segueRecuperar", sender: self)
    }

    //Hidden navigation bar
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
    
    //Prepare For Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueRecuperar" {

        }
        if segue.identifier == "segueLoginHome"{
        
        }
    }
}
