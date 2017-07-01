//
//  RegistroViewController.swift
//  UFind
//
//  Created by ginppian on 28/02/17.
//  Copyright © 2017 ginppian. All rights reserved.
//

import UIKit
import Alamofire
import Alamofire_Synchronous
import MBProgressHUD

class RegistroViewController: UIViewController {

    @IBOutlet weak var enviar: UIView!
    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tfApellidos: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var segmentedGender: UISegmentedControl!
    @IBOutlet weak var tfPass: UITextField!
    
    //Headers
    let headers: HTTPHeaders = [
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Load dismiss keyboard
        self.hideKeyboardWhenTappedAround()
        
        //Round to buttons
        applyViewsLayerOptions()
        
    }
    
    @IBAction func enviarAction(_ sender: UIButton) {
        
        //Checamos la conexion a internet
        if Reachability.isConnectedToNetwork()
        {
            print("Connection Available!")
            
            //Activity
            self.showLoadingHUD()
            
            //Thread Background
            DispatchQueue.global(qos: .background).async {
                
                //Obtenemos los datos
                let nombre = self.tfNombre.text
                let apellidos = self.tfApellidos.text
                let email = self.tfEmail.text
                let passw = self.tfPass.text
                let gender = self.segmentedGender.selectedSegmentIndex
                
                
                //Validacion otros campos
                let validacion = self.validarOtrosCampos(nombre: nombre!, apellidos: apellidos!, pass: passw!)
                
                if validacion {
                    
                    //Validacion email
                    if self.validarMail(email: email!)
                    {
                        
                        //Acepta terminos y condiciones
                        let refreshAlert = UIAlertController(title: Alerta.sharedInstance.terminos(), message: Alerta.sharedInstance.aceptarTerminos(), preferredStyle: UIAlertControllerStyle.alert)
                        
                        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
                            
                            print("Handle Cancel Logic here")
                            
                        }))
                        
                        refreshAlert.addAction(UIAlertAction(title: "Leer terminos y condiciones", style: .default, handler: { (action: UIAlertAction!) in
                            
                            DispatchQueue.main.async {
                                print("This is run on the main queue, after the previous code in outer block")
                                self.hideLoadingHUD()
                                self.performSegue(withIdentifier: "segueRegistroTerminos", sender: self)

                            //Main Thread
                            }
                            
                        }))
                        
                        refreshAlert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: { (action: UIAlertAction!) in
                            
                            print("Handle Ok logic here")
                            
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
                                
                                //No existe el usuario puedo crearlo
                                if estatus == 1 && objetoResultado == false {
                                    
                                    //Deserealizamos datos usuario
                                    let usr = self.deserealizarDatosUsuario(nombre: nombre!, apellidos: apellidos!, email: email!, passw: passw!, gender: gender)
                                    
                                    //Creamos Usuario
                                    let banderaSuccesCreateUser = self.creaUsuario(email: usr.email, contrasenia: usr.contrasenia, nombre: usr.nombre, paterno: usr.paterno, materno: usr.materno, nacimiento: "", genero: usr.genero, telefono: "", tipoAutenticacion: usr.tipoAutentificacion, activo: true)
                                    
                                    if banderaSuccesCreateUser {
                                        
                                        
                                        //Persistencia
                                        usr.sesion = "on"
                                        let dict = self.crearDiccionario(email: usr.email, nombre: usr.nombre, paterno: usr.paterno, materno: usr.materno, genero: usr.genero, sesion: usr.sesion)
                                        
                                        self.persistenciaUserData(dictionary: dict)
                                        
                                        //Vamonos a Home
                                        DispatchQueue.main.async {
                                            print("This is run on the main queue, after the previous code in outer block")
                                            
                                            self.hideLoadingHUD()
                                            self.performSegue(withIdentifier: "segueRegistroHome", sender: self)
                                            
                                        //Main Thread
                                        }
                                        
                                    } else {
                                        
                                        self.customAlert(title: Alerta.sharedInstance.alerta(), message: Alerta.sharedInstance.errorServicios())
                                        
                                    }
                                    
                                }
                                
                                //Inicia sesion
                                if estatus == 1 && objetoResultado == true {
                                    
                                    self.customAlert(title: Alerta.sharedInstance.existe(), message: Alerta.sharedInstance.usuarioExistente())
                                    
                                    DispatchQueue.main.async {
                                        print("This is run on the main queue, after the previous code in outer block")
                                        self.hideLoadingHUD()
                                    //Main Thread
                                    }
                                    
                                }
                                
                                //Error servicios
                                if estatus != 1 {
                                    
                                    self.customAlert(title: Alerta.sharedInstance.servidoresFallando(), message: Alerta.sharedInstance.errorServicios())
                                    
                                    DispatchQueue.main.async {
                                        print("This is run on the main queue, after the previous code in outer block")
                                        self.hideLoadingHUD()
                                        //Main Thread
                                    }
                                    
                                }
                                
                                //Sino es capaz de regresar un JSON
                            } else {
                                
                                DispatchQueue.main.async {
                                    print("This is run on the main queue, after the previous code in outer block")
                                    self.hideLoadingHUD()
                                    //Main Thread
                                }
                                
                                self.customAlert(title: Alerta.sharedInstance.servidoresFallando(), message: Alerta.sharedInstance.errorServicios())
                                
                            }
                            
                        }))
                        
                        //Acepta Terminos y Condiciones
                        self.present(refreshAlert, animated: true, completion: nil)
                        
                    //Validacion
                    }
                    else {
                        
                        self.customAlert(title: Alerta.sharedInstance.alerta(), message: Alerta.sharedInstance.emailIncorrecto())
                        
                    }
                    
                //Validar otros campso
                }
                else {
                    
                    self.customAlert(title: Alerta.sharedInstance.error(), message: Alerta.sharedInstance.completarCampos())
                    
                }

            //Thread
            }

        //Conexion
        }
        else {
            
            print("Internet Connection not Available!")
            self.customAlert(title: Alerta.sharedInstance.conexion(), message: Alerta.sharedInstance.verificarConexion())
            
        }
    }
    
    //Crear diccionario a partir de Usuario
    func crearDiccionario(email:String, nombre:String, paterno:String, materno:String, genero:String, sesion:String) -> [String:String] {
        
        let dict: [String: String] = ["email": email, "nombre": nombre, "paterno": paterno, "materno": materno, "genero": genero, "sesion":sesion]
        
        return dict
    }
    //Servicio Crear Usuario
    func creaUsuario(email:String, contrasenia:String, nombre:String, paterno:String, materno: String, nacimiento:String, genero:String, telefono:String, tipoAutenticacion:Int, activo:Bool) -> Bool{
        
        var bandera = false
        
        let link = Servicio.sharedInstance.crearUsuario(email: email, contrasenia: contrasenia, nombre: nombre, paterno: paterno, materno: materno, nacimiento: nacimiento, genero: genero, telefono: telefono, tipoAutenticacion: tipoAutenticacion, activo: activo)
        
        let url = link.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        //Enviamos...
        let response = Alamofire.request(url!, method: .post, parameters: nil).responseJSON(options: .allowFragments)
        if let json = response.result.value {
            print("json: \(json)")
            
            //Casteamos
            let JSON = json as! [String: AnyObject]
            
            //Obtenemos banderas
            let estatus = JSON["estatus"] as! Int
            //let objetoResultado = JSON["objetoResultado"] as! Int
            
            //Existe el usuario, Actualizar modo de log in, mandarlo a Home
            if estatus == 1 {
                bandera = true
            }
        }
        
        return bandera
    }
    
    //Deserializar datos usuario
    func deserealizarDatosUsuario(nombre:String, apellidos:String, email:String, passw:String, gender:Int) -> Usuario{
        let usr = Usuario()
        
        //Nombre
        usr.nombre = nombre
        if usr.nombre == "" {
            usr.nombre = ""
        }
        
        //Apellidos
        if apellidos != ""{
            let arrayApellidos = apellidos.components(separatedBy: " ")
            let longi = arrayApellidos.count
            
            if longi == 1 {
                usr.paterno = arrayApellidos[0]
                usr.materno = ""
            }
            
            if arrayApellidos.count > 1 {
                
                usr.paterno = arrayApellidos[0]
                
                for (index, element) in arrayApellidos.enumerated(){
                    if index != 0{
                        usr.materno += "\(element) "
                    }
                }
                
            } else {
                usr.paterno = apellidos
                usr.materno = ""
            }
        } else {
            usr.paterno = ""
            usr.materno = ""
        }
        
        //Email
        usr.email = email
        if usr.email == "" {
            usr.email = ""
        }
        
        //Pass
        usr.contrasenia = passw
        
        //Genero

        if gender == 0 {
            usr.genero = "male"
        } else {
            usr.genero = "female"
        }
        
        //id=1 para Registro
        usr.tipoAutentificacion = 1
        
        return usr
    }
    //Persistencia
    func persistenciaUserData(dictionary:[String : String]){
        
        UserDefaults.standard.set(dictionary, forKey: "userDataUFind")
        //let result = UserDefaults.standard.value(forKey: "userData")
        //print(result!)
    }

    //Validacion
    func validarOtrosCampos(nombre:String, apellidos:String, pass:String) -> Bool{
        var bandera = true
        if nombre.characters.count < 2 {
            bandera = false
        }
        if apellidos.characters.count < 2 {
            bandera = false
        }
        if pass.characters.count < 2 {
            bandera = false
        }
        return bandera
    }
    
    //Validar Mail
    func validarMail(email:String) -> Bool{
        if email.characters.count < 2 {
            return false
        }
        if isValidEmail(testStr: email) {
            return true
        } else {
            return false
        }
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
    
    //Hidden navigation bar
    override func viewWillAppear(_ animated: Bool) {
        
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.isNavigationBarHidden = false

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
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
        if segue.identifier == "segueRegistroHome" {
            //let vc = segue.destination as! HomeViewController
            //vc.usr = self.usr
        }
        if segue.identifier == "segueRegistroTerminos" {
            
        }
    }

}
