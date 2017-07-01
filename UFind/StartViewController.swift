//
//  InicioViewController.swift
//  UFind
//
//  Created by ginppian on 27/02/17.
//  Copyright © 2017 ginppian. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire
import Alamofire_Synchronous
import MBProgressHUD

//Get Constrains SupvarView
extension UIView {
    
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
    }
}
//Alertas
extension UIViewController {
    func customAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
class StartViewController: UIViewController, FBSDKLoginButtonDelegate {

    //Outlets
    @IBOutlet weak var inicioImgBackground: UIImageView!
    @IBOutlet weak var viewSesion: UIView!
    @IBOutlet weak var viewFb: UIView!
    @IBOutlet weak var viewRegistro: UIView!

    //Facebook
    let loginButton = FBSDKLoginButton()
    
    //Heders
    let headers: HTTPHeaders = [
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]
    
    //Propertys
    var banderaExisteEmail = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Fb
        //Cumple 🎂 🛑 El user_birthday necesita ser validado por facebook
        //self.loginButton.readPermissions = ["email", "user_birthday"]
        self.loginButton.readPermissions = ["email"]
        self.loginButton.delegate = self
        self.viewFb.addSubview(loginButton)
        self.loginButton.bindFrameToSuperviewBounds()
        
        //Paralax Effect
        applyMotionEffect(toView: inicioImgBackground, magnitude: 34)
        
        //Border Radio Buttons
        applyViewsLayerOptions()
    }
    
    //Fb
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil {
            print("Something went wrong \(error)")
            return
        }
        
        print("Success Login in FB")
        getFBUserData()
        
    }
    
    //Fb
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Succes Logout in Fb")
    }
    
    //Fb
    func getFBUserData(){
        print("Entra getFBUserData")
        
        //Activity
        self.showLoadingHUD()
        
        if((FBSDKAccessToken.current()) != nil){
            
            print("Fb_UserId: \(FBSDKAccessToken.current().userID)")
            print("Fb_Toke: \(FBSDKAccessToken.current().tokenString)")
            
            //Si queremos el Cumple 🎂
            //FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, gender, birthday"]).start(completionHandler: { (connection, result, error) -> Void in
            
            //Solicitamos a Fb datos de usuario
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, gender"]).start(completionHandler: { (connection, result, error) -> Void in
                
                //Sino hubo error entramos
                if (error == nil){
                

                    
                    //Thread Background
                    DispatchQueue.global(qos: .background).async {
                        
                        //Diccionario de recibidos casteamos a Diccionario
                        let dict = result as! [String : AnyObject]
                        print("dict: \(dict)")
                        
                        //Almacenamos datos en una clase Usuario
                        var usr = Usuario()
                        usr = self.deserealizarDatosUsuario(dictionary: dict)
                        
                        //Preguntamos si: Existe Usuario - Servicio Web
                        let link = Servicio.sharedInstance.existeUsuario(email: usr.email)
                        
                        //Caracteres especiales
//                        let url = link.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                        
                        //Enviamos...
                        let response = Alamofire.request(link, parameters: nil).responseJSON()
                        if let json = response.result.value {
                            print("json: \(json)")
                            
                            //Casteamos
                            let JSON = json as! [String: AnyObject]
                            
                            //Obtenemos banderas
                            let estatus = JSON["estatus"] as! Int
                            let objetoResultado = JSON["objetoResultado"] as! Bool
                            
                            //Existe el usuario, Actualizar modo de login, mandarlo a Home
                            if estatus == 1 && objetoResultado {
                                
                                let actualizacion = self.actualizaUsuarioXAutenticacion(email: usr.email, contrasenia: usr.pass, tipoAutentificacion: 2)
                                
                                //Se realizo correctamento la actualizacion
                                if actualizacion {
                                    
                                    //Persistencia
                                    usr.sesion = "on"
                                    let dict = self.crearDiccionario(email: usr.email, nombre: usr.nombre, paterno: usr.paterno, materno: usr.materno, genero: usr.genero, sesion: usr.sesion)
                                    
                                    //Guardamos datos en disco
                                    self.persistenciaUserData(dict: dict)
                        
                                    //Cerrar sesion en fb
                                    FBSDKLoginManager().logOut()
                                    
                                    //Activity
                                    DispatchQueue.main.async {
                                        
                                        //Hide Activity
                                        self.hideLoadingHUD()
                                        
                                        //Vamonos a Home
                                        self.performSegue(withIdentifier: "segueHome", sender: self)
                                    }
                                    
                                //No se realizo correctamente la actualizacion
                                } else {
                                    
                                    //Activity
                                    self.hideLoadingHUD()
                                    
                                    self.customAlert(title: Alerta.sharedInstance.alerta(), message: Alerta.sharedInstance.errorServidoresLogInFb())
                                }
                            } else {
                                print("Entra crear usuario")
                                //Creamos usuario
                                let banderaSuccesCreateUser = self.creaUsuario(email: usr.email, contrasenia: "", nombre: usr.nombre, paterno: usr.paterno, materno: usr.materno, nacimiento: "", genero: usr.genero, telefono: "", tipoAutenticacion: usr.tipoAutentificacion, activo: true)
                                print("Bandera vale: \(banderaSuccesCreateUser)")
                                if banderaSuccesCreateUser {
                                    //Activity
                                    self.hideLoadingHUD()
                                    
                                    //Vamonos a Home
                                    self.performSegue(withIdentifier: "segueHome", sender: self)
                                    
                                } else {
                                    self.customAlert(title: Alerta.sharedInstance.alerta(), message: Alerta.sharedInstance.errorServidoresLogInFb())
                                }
                            }
                            
                        } else {
                            //Enviamos una alerta de error
                            self.customAlert(title: Alerta.sharedInstance.alerta(), message: Alerta.sharedInstance.errorServidoresLogInFb())
                            
                            //Activity
                            self.hideLoadingHUD()
                            
                        //Else response
                        }
                        
                        DispatchQueue.main.async {
                            print("This is run on the main queue, after the previous code in outer block")
                            
                        //Main Thread
                        }
                        
                    //Thread
                    }

                //Error
                }
                
            //Completion handler
            })
        
        //Current token
        } else {
            
            //Hide Activity
            self.hideLoadingHUD()
        }
    
    //getUserData
    }
     //Servicio Actualizar Usuario
    func actualizaUsuarioXAutenticacion(email:String, contrasenia:String, tipoAutentificacion: Int) -> Bool{
        
        var bandera = false
        
        let link = Servicio.sharedInstance.actualizaUsuarioXAutenticacion(email: email, contrasenia: contrasenia, tipoAutentificacion: tipoAutentificacion)
        let url = link.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        let response = Alamofire.request(url!, method: .post, parameters: nil).responseJSON(options: .allowFragments)
        if let json = response.result.value {
            print(json)
            
            //Casteamos
            let JSON = json as! [String: AnyObject]
            
            //Obtenemos banderas
            let estatus = JSON["estatus"] as! Int
            let objetoResultado = JSON["objetoResultado"] as! Bool
            
            if estatus == 1 && objetoResultado {
                bandera = true
            }
        }
        
        
        return bandera
        
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
            let objetoResultado = JSON["objetoResultado"] as! Bool
            
            //Existe el usuario, Actualizar modo de log in, mandarlo a Home
            if estatus == 1 && objetoResultado {
                bandera = true
            }
        }
        
        return bandera
    }
    //Deserializar datos usuario
    func deserealizarDatosUsuario(dictionary:[String : AnyObject]) -> Usuario{
        let usr = Usuario()
        
        //Nombre
        usr.nombre = dictionary["first_name"] as! String
        if usr.nombre == "" {
            usr.nombre = ""
        }
        
        //Apellidos
        var apellidos = String()
        apellidos = dictionary["last_name"] as! String
        if apellidos == "" {
            apellidos = ""
        }
        
        //Separa apellidos
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
        
        usr.email = dictionary["email"] as! String
        if usr.email == ""{
            usr.email = ""
        }
        
        //Genero
        usr.genero = dictionary["gender"] as! String
        if usr.genero == ""{
            usr.genero = ""
        }
        
        //Cumple 🎂
        //usr.nacimiento = dictionary["birthday"] as! String
        //if usr.nacimiento == ""{
        //    usr.nacimiento = "00/00/0000"
        //}
        
        //id=2 para Fb
        usr.tipoAutentificacion = 2
        
        return usr
    }
    //Persistencia
    func persistenciaUserData(dict: [String : String]){

        UserDefaults.standard.set(dict, forKey: "userDataUFind")
        //let result = UserDefaults.standard.value(forKey: "userDataUFind")
        //print(result!)
    }
    //Paralax Effect
    func applyMotionEffect(toView view:UIView, magnitude:Float){
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion, yMotion]
        
        view.addMotionEffect(group)
    }
    //Views Buttons Border Radious
    func applyViewsLayerOptions(){
        //borderRadiousView(view: self.viewSesion, radio: 8.0, opacity: 0.0)
        borderRadiousView(view: self.viewFb, radio: 8.0, opacity: 0.0)
        //borderRadiousView(view: self.viewRegistro, radio: 8.0, opacity: 0.0)
    }
    //BorderRadious
    func borderRadiousView(view:UIView, radio:Float, opacity:Float){
        view.layer.cornerRadius = CGFloat(radio)
        view.layer.shadowOpacity = opacity
    }
    //Mail valido
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    //Hidden navigation bar
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    //Actions
    @IBAction func registroAction(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "segueRegistro", sender: self)
    }
    
    @IBAction func iniciarSesionAction(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "segueInicioSesion", sender: self)
    }
    
    //Unwind
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        
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
        if segue.identifier == "segueHome" {
            //let vc = segue.destination as! HomeViewController
            //vc.usr = self.usr
        }
    }

}

