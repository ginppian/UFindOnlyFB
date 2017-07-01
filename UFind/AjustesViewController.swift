//
//  AjustesViewController.swift
//  UFind
//
//  Created by ginppian on 01/03/17.
//  Copyright © 2017 ginppian. All rights reserved.
//

import UIKit
import Foundation
import MessageUI

extension UIImage {
    func tint(with color: UIColor) -> UIImage {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        
        image.draw(in: CGRect(origin: .zero, size: size))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

class AjustesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    struct objetos {
        var seccion:String!
        var contenido:[String]!
    }
    
    var objetosArray = [objetos]()
    
    //Usuario
    var usr = Usuario()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Obtenemos campos Usuario
        let dict = UserDefaults.standard.value(forKey: "userDataUFind") as! [String : String]
        print(dict)
        self.usr = self.datosFromDict(dict: dict)
        
        let nomComplet = "\(self.usr.nombre) \(self.usr.paterno) \(self.usr.materno)"
        let email = "\(self.usr.email)"
        
        //Agregar categoria favoritos
//        objetosArray = [objetos(seccion: "perfil", contenido: [nomComplet, email]),
//                        objetos(seccion: "eventos", contenido: ["Favoritos", "Política de privacidad", "Califícanos", "Danos tu opinión"]),
//                        objetos(seccion: "cerrarSesion", contenido: ["Cerrar sesión"])
//        ]
        objetosArray = [objetos(seccion: "perfil", contenido: [nomComplet, email]),
                        objetos(seccion: "eventos", contenido: ["Política de privacidad", "Califícanos", "Danos tu opinión"]),
                        objetos(seccion: "cerrarSesion", contenido: ["Cerrar sesión"])
        ]
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Perfil
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellPerfil", for: indexPath) as! PerfilTableViewCell
            
            cell.nombre.text = objetosArray[0].contenido[0]
            cell.email.text = objetosArray[0].contenido[1]
            
            let imag = cell.perfil.image
            let imag2 = imag?.tint(with: UIColor.white)
            
            cell.perfil.image = imag2
            
            return cell
            
        }
        //Cerrar Sesion
        if indexPath.section == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellCerrarSesion", for: indexPath) as! CerrarSesionTableViewCell
            
            
            return cell
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellAjustes", for: indexPath) as! AjustesTableViewCell
            
            cell.label.text = objetosArray[1].contenido[indexPath.row]
            let imag = cell.imagen.image
            let imag2 = imag?.tint(with: UIColor(red: 255/255, green: 136/255, blue: 0.0, alpha: 1.0))
            cell.imagen.image = imag2
            
            //Seccion politicas
            if indexPath.section == 1 {
                
                //Favoritos 
//                if indexPath.row == 0 {
//                    let imagi = UIImage(named: "fav")
//                    let imagn = imagi?.tint(with: UIColor(red: 255/255, green: 136/255, blue: 0.0, alpha: 1.0))
//                    cell.imagen.image = imagn
//                }
                //Politicas
                if indexPath.row == 0 {
                    
                    let imagi = UIImage(named: "politic")
                    let imagn = imagi?.tint(with: UIColor(red: 255/255, green: 136/255, blue: 0.0, alpha: 1.0))
                    cell.imagen.image = imagn
                    
                }
                //Calificanos
                if indexPath.row == 1 {
                    
                    let imagi = UIImage(named: "califica")
                    let imagn = imagi?.tint(with: UIColor(red: 255/255, green: 136/255, blue: 0.0, alpha: 1.0))
                    cell.imagen.image = imagn
                    
                }
                //OpinionEmail
                if indexPath.row == 2 {
                    
                    let imagi = UIImage(named: "email")
                    let imagn = imagi?.tint(with: UIColor(red: 255/255, green: 136/255, blue: 0.0, alpha: 1.0))
                    cell.imagen.image = imagn
                    
                }
            }
            
            
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 82.0
        } else {
            return 45.0
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return UIScreen.main.bounds.height/21
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var aux = 0
        if section == 0 {
            aux = 1
        }
        if section == 1 {
            aux = 3
        }
        if section == 2 {
            aux = 1
        }
        return aux
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return objetosArray.count
    }
    
    //Datos from registro
    func datosFromDict(dict: [String:String]) -> Usuario {
        let usr = Usuario()
        
        usr.email = dict["email"]!
        usr.genero = dict["genero"]!
        usr.materno = dict["materno"]!
        usr.paterno = dict["paterno"]!
        usr.nombre = dict["nombre"]!
        
        return usr
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Deseleccionamos cualquier celda
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        //Perfil
        if indexPath.section == 0 {
            //Do nothing
        }
        
        //Politicas, Calificanos, Danos Opinion
        if indexPath.section == 1 {
        
            //Favoritos
//            if indexPath.row == 0 {
//                print("click favoritos")
//            }
            
            //Politicas
            if indexPath.row == 0 {
                
                performSegue(withIdentifier: "segueAjustesPoliticas", sender: self)
                
            }
            
            //Calificanos App Store
            if indexPath.row == 1 {
                
                print("app store")
                
                UIApplication.shared.open(URL(string: "itms://itunes.apple.com/app/id" + "1149480304")!, options: [:], completionHandler: nil)

            }
            
            //DanosOpinionEmail
            if indexPath.row == 2 {
                
                print("DanosOpinion")
                
                let mailComposeViewController = configuredMailComposeViewController()
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailComposeViewController, animated: true, completion: nil)
                } else {
                    self.showSendMailErrorAlert()
                }
                
            }
            
        }
        
        //Cerrar sesion
        if indexPath.section == 2 {
            
            //Crear alerta
            let alertController = UIAlertController(title: "Cerrar sesión", message: "Has iniciado sesión como \(self.usr.nombre) \(self.usr.paterno) \(self.usr.materno)", preferredStyle: .alert)
            
            //Cancelar
            let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            alertController.addAction(cancelar)
            
            //Cerrar sesion
            let cerrarSesion = UIAlertAction(title: "Cerrar sesión", style: .destructive, handler: { (action: UIAlertAction!) in
                
                //Cerramos persistencia de sesion
                let dict = self.crearDiccionario(email: "", nombre: "", paterno: "", materno: "", genero: "", sesion: "off")
                UserDefaults.standard.set(dict, forKey: "userDataUFind")
                
                //Regresamos al inicio de la aplicacion
                let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "StoryBoardStart")
                UIApplication.shared.keyWindow?.rootViewController = loginViewController
                
                
            })
            alertController.addAction(cerrarSesion)
            
            //Show alert
            present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    func crearDiccionario(email:String, nombre:String, paterno:String, materno:String, genero:String, sesion:String) -> [String:String] {
        
        let dict: [String: String] = ["email": email, "nombre": nombre, "paterno": paterno, "materno": materno, "genero": genero, "sesion":sesion]
        
        return dict
    }
    
    //MARK: - Email
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["contacto@ufind.com.mx"])
        //mailComposerVC.setSubject("")
        //mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        
        self.customAlert(title: Alerta.sharedInstance.noEmail(), message: Alerta.sharedInstance.noEmailConfi())
    
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    /*func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     return objectsArray[section].sectionName
     }
     
     
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     let view = UIView()
     view.backgroundColor = UIColor.red
     view.clipsToBounds = true
     
     return view
     }*/
    
    
    /*func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 50.0
     }*/
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
 
    
}
