//
//  GeneralesViewController.swift
//  UFind
//
//  Created by ginppian on 11/03/17.
//  Copyright © 2017 ginppian. All rights reserved.
//

import UIKit
import Foundation
import MXSegmentedPager
import MBProgressHUD
import Alamofire
import Alamofire_Synchronous
import SwiftyJSON
import MessageUI

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}
class GeneralesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {

    //Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //Propertys
    var negocio = String()
    var objNego = objNegocio()
    var link = "http://www.google.com"
    var myUsr = Usuario()
    
    //MARK: - Constructor
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("GeneralesViewController...")
        
        //Table View
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 120, 0)
        
        //Nego
        self.obtenNegocioXId(id: self.negocio)
        
        //Favoritos
        self.serviciosFavoritos(email: self.getCorreo())
        
    }

    //MARK: - TableView
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var aux = 0
        
        //Logotipo
        if section == 0 {
            aux = 1
        }
        
        //Titulo
        if section == 1 {
            aux = 1
        }
        
        //Direccion
        if section == 2 {
            aux = 1
        }
        
        //Contacto
        if section == 3 {
            aux = 4
        }
        
        //FormasPago
        if section == 4 {
            
            aux = 4
        }
        
        //RedesSociales
        if section == 5 {
            
            aux = 3
        }
        
        //Favoritos
        if section == 6 {
            
            aux = 1
            
        }
        
        return aux
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        //Logotipo
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "detallGeneralImgCell") as! detallGeneralImgTableViewCell
            
            cell.imagen.downloadedFrom(link: self.objNego.logotipo)

            return cell
        }
        
        //Titulo
        if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "detallGeneralTitCell") as! detallGeneralTituloTableViewCell
            cell.labelTitulo.text = self.objNego.negocio
            
            return cell
        }
        
        //Direccion
        if indexPath.section == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "detallGeneralUbiCell") as! detallGeneralUbicacionTableViewCell
            cell.label.text = self.objNego.direccion
            
            
            let imagi = UIImage(named: "map")
            let imagn = imagi?.tint(with: UIColor(red: 255/255, green: 136/255, blue: 0.0, alpha: 1.0))
            cell.imagen.image = imagn
            
            return cell
        }
        
        //Contacto
        if indexPath.section == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "detallGeneralContacto") as! detallGeneralContactoTableViewCell
            
            //Telefono
            if indexPath.row == 0 {
                
                if self.objNego.telefono != "" {
                
                    cell.label.text = self.objNego.telefono
                    
                    let imagi = UIImage(named: "phone")
                    let imagn = imagi?.tint(with: UIColor(red: 255/255, green: 136/255, blue: 0.0, alpha: 1.0))
                    cell.imagen.image = imagn
                    
                } else {
                
                    cell.label.text = "Telefono"
                    
                    let imagi = UIImage(named: "phone")
                    let imagn = imagi?.tint(with: UIColor.darkGray)
                    cell.imagen.image = imagn
                    
                }
                
            }
            
            //Whats
            if indexPath.row == 1 {
                
                if self.objNego.whatsApp != "" {
                
                    cell.label.text = self.objNego.whatsApp
                    
                    let imagi = UIImage(named: "whatsapp")
                    let imagn = imagi?.tint(with: UIColor(red: 255/255, green: 136/255, blue: 0.0, alpha: 1.0))
                    cell.imagen.image = imagn
                    
                } else {
                
                    cell.label.text = "WhatsApp"
                    
                    let imagi = UIImage(named: "whatsapp")
                    let imagn = imagi?.tint(with: UIColor.darkGray)
                    cell.imagen.image = imagn
                    
                }
            }
            //SitioWeb
            if indexPath.row == 2 {
            
                if self.objNego.sitioWeb != "" {
                
                    cell.label.text = self.objNego.sitioWeb
                    
                    let imagi = UIImage(named: "web")
                    let imagn = imagi?.tint(with: UIColor(red: 255/255, green: 136/255, blue: 0.0, alpha: 1.0))
                    cell.imagen.image = imagn
                    
                } else {
                    
                    cell.label.text = "Sitio Web"
                
                    let imagi = UIImage(named: "web")
                    let imagn = imagi?.tint(with: UIColor.darkGray)
                    cell.imagen.image = imagn
                    
                
                }
                
            }
            //Correo
            if indexPath.row == 3 {
                
                if self.objNego.correoElectronico != "" {
                
                    cell.label.text = self.objNego.correoElectronico
                    
                    let imagi = UIImage(named: "email")
                    let imagn = imagi?.tint(with: UIColor(red: 255/255, green: 136/255, blue: 0.0, alpha: 1.0))
                    cell.imagen.image = imagn
                    
                } else {
                
                    cell.label.text = "Email"
                    
                    let imagi = UIImage(named: "email")
                    let imagn = imagi?.tint(with: UIColor.darkGray)
                    cell.imagen.image = imagn
                    
                }
                
            }
            
            return cell
        }
        
        //FormasPago
        if indexPath.section == 4 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "detallGeneralContacto") as! detallGeneralContactoTableViewCell
            
            //Efectivo
            if indexPath.row == 0 {
                
                if self.objNego.efectivo {
                    
                    cell.label.text = "Efectivo"
                    
                    let imagi = UIImage(named: "cash")
                    let imagn = imagi?.tint(with: UIColor(red: 255/255, green: 136/255, blue: 0.0, alpha: 1.0))
                    cell.imagen.image = imagn
                    
                    cell.accessoryType = .checkmark
                    
                } else {
                
                    cell.label.text = "Efectivo"
                    
                    let imagi = UIImage(named: "cash")
                    let imagn = imagi?.tint(with: UIColor.darkGray)
                    cell.imagen.image = imagn
                    
                    cell.accessoryType = .none
                }
                
            }
            
            //Mastercard
            if indexPath.row == 1 {
                
                if self.objNego.tarjetaMasterCard {

                    cell.label.text = "Master Card"
                    
                    let imagi = UIImage(named: "masterCard")
                    let imagn = imagi?.tint(with: UIColor(red: 255/255, green: 136/255, blue: 0.0, alpha: 1.0))
                    cell.imagen.image = imagn
                    
                    cell.accessoryType = .checkmark

                } else {
                    
                    cell.label.text = "Master Card"
                    
                    let imagi = UIImage(named: "masterCard")
                    let imagn = imagi?.tint(with: UIColor.darkGray)
                    cell.imagen.image = imagn
                    
                    cell.accessoryType = .none
                }

            }
            
            //Visa
            if indexPath.row == 2 {
                
                if self.objNego.tarjetaVisa {
                
                    cell.label.text = "Visa"
                    
                    let imagi = UIImage(named: "visa")
                    let imagn = imagi?.tint(with: UIColor(red: 255/255, green: 136/255, blue: 0.0, alpha: 1.0))
                    cell.imagen.image = imagn
                    
                    cell.accessoryType = .checkmark
                    
                } else {
                
                    cell.label.text = "Visa"
                    
                    let imagi = UIImage(named: "visa")
                    let imagn = imagi?.tint(with: UIColor.darkGray)
                    cell.imagen.image = imagn
                    
                    cell.accessoryType = .none
                
                }

            }
            
            //AmericanExpres
            if indexPath.row == 3 {
                
                if self.objNego.tarjetaAmex {
                
                    cell.label.text = "American Express"
                    
                    let imagi = UIImage(named: "american")
                    let imagn = imagi?.tint(with: UIColor(red: 255/255, green: 136/255, blue: 0.0, alpha: 1.0))
                    cell.imagen.image = imagn
                    
                    cell.accessoryType = .checkmark
                    
                } else {
                
                    cell.label.text = "American Express"
                    
                    let imagi = UIImage(named: "american")
                    let imagn = imagi?.tint(with: UIColor.darkGray)
                    cell.imagen.image = imagn
                    
                    cell.accessoryType = .none
                
                }

            }
            
            return cell
        }
        
        //RedesSociales
        if indexPath.section == 5 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "detallGeneralContacto") as! detallGeneralContactoTableViewCell
            
            //Facebook
            if indexPath.row == 0 {
                
                if self.objNego.facebook != "" {
                    
                    cell.label.text = "FaceBook"
                    
                    let imagi = UIImage(named: "facebook")
                    let imagn = imagi?.tint(with: UIColor(red: 255/255, green: 136/255, blue: 0.0, alpha: 1.0))
                    cell.imagen.image = imagn
                    
                } else {
                
                    cell.label.text = "FaceBook"
                    
                    let imagi = UIImage(named: "facebook")
                    let imagn = imagi?.tint(with: UIColor.darkGray)
                    cell.imagen.image = imagn
                    
                    cell.accessoryType = .none
                
                }
            
            }
            
            //Twitter
            if indexPath.row == 1 {
                
                if self.objNego.twitter != "" {
                
                    cell.label.text = "Twitter"
                    
                    let imagi = UIImage(named: "twitter")
                    let imagn = imagi?.tint(with: UIColor(red: 255/255, green: 136/255, blue: 0.0, alpha: 1.0))
                    cell.imagen.image = imagn
                    
                } else {
                
                    cell.label.text = "Twitter"
                    
                    let imagi = UIImage(named: "twitter")
                    let imagn = imagi?.tint(with: UIColor.darkGray)
                    cell.imagen.image = imagn
                
                    cell.accessoryType = .none
                    
                }

            }
            
            //Instagram
            if indexPath.row == 2 {
                
                if self.objNego.instagram != "" {
                
                    cell.label.text = "Instagram"
                    
                    let imagi = UIImage(named: "instagram")
                    let imagn = imagi?.tint(with: UIColor(red: 255/255, green: 136/255, blue: 0.0, alpha: 1.0))
                    cell.imagen.image = imagn
                    
                } else {
                
                    cell.label.text = "Instagram"
                    
                    let imagi = UIImage(named: "instagram")
                    let imagn = imagi?.tint(with: UIColor.darkGray)
                    cell.imagen.image = imagn
                    
                    cell.accessoryType = .none
                
                }
            }
            
            return cell
        }
        
        //Favoritos
        if indexPath.section == 6 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "detallGeneralFav") as! detallGeneralFavoritosTableViewCell
            
            if self.objNego.esFavorito {
                
                cell.imagen.image = UIImage(named: "starFilled")
                cell.favoritoActivo = true
                
            } else {
            
                cell.imagen.image = UIImage(named: "star")

            }
            
            return cell
        }
        
        //Cualquier otro caso
        else {
        
            return UITableViewCell()
        
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //Logotipo
        if indexPath.section == 0 {
            return 144.0
        }
        
        //Titulo
        if indexPath.section == 1 {
            return 45.0
        }
        
        //Direccion
        if indexPath.section == 2 {
            return 45.0
        }
        
        //Contacto
        if indexPath.section == 3 {
            return 45.0
        }
        
        //Formas de pago
        if indexPath.section == 4 {
            return 45.0
        }
        
        //Redes sociales
        if indexPath.section == 5 {
            return 45.0
        }
        
        //Favoritos
        if indexPath.section == 6 {
            return 45.0
        }
        
        else {
        
            return 45.0
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2.0
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //Logotipo
        if section == 0 {
            return ""
        }
        
        //Titulo
        if section == 1 {
            return ""
        }
        
        //Direccion
        if section == 2 {
            return "Ubicación"
        }
        
        //Contacto
        if section == 3 {
            return "Contacto"
        }
        
        //Formas de pago
        if section == 4 {
            return "Formas de pago"
        }
        
        //Redes sociales
        if section == 5 {
            return "Redes sociales"
        }
        
        //Favoritos
        if section == 6 {
            return "Favoritos"
        }
            
        else {
            
            return ""
            
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Deseleccionamos la row
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Logotipo
        if indexPath.section == 0 {
            
            print("Logotipo")
        }
        
        //Titulo
        if indexPath.section == 1 {
            
            print("Titulo")
        }
        
        //Direccion
        if indexPath.section == 2 {
            
            print("Direccion")
            
            performSegue(withIdentifier: "segueGeneralesMapa", sender: self)
        }
        
        //Contacto
        if indexPath.section == 3 {
            
            print("Contacto")
            
            //Telefono
            if indexPath.row == 0 {
                
                print("Telefono")
                
                if self.objNego.telefono != "" {
                
                    if let phoneCallURL = URL(string: "tel://\(self.objNego.telefono)") {
                        let application:UIApplication = UIApplication.shared
                        if (application.canOpenURL(phoneCallURL)) {
                            application.open(phoneCallURL, options: [:], completionHandler: nil)
                        }
                    }
                    
                }
                
            }
            
            //Whats
            if indexPath.row == 1 {
                
                print("Whats")

                if self.objNego.whatsApp != "" {
                    
                    let refreshAlert = UIAlertController(title: Alerta.sharedInstance.whats(), message: Alerta.sharedInstance.whatsAlert(), preferredStyle: UIAlertControllerStyle.alert)
                    
                    //Cancelar
                    refreshAlert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
                    
                    //Copia
                    refreshAlert.addAction(UIAlertAction(title: "Copiar", style: .default, handler: { (action: UIAlertAction!) in
                        print("Copiar al portapapeles")
                        
                        UIPasteboard.general.string = self.objNego.whatsApp
                        
                    }))
                    
                    //Ir
                    refreshAlert.addAction(UIAlertAction(title: "Ir", style: .default, handler: { (action: UIAlertAction!) in
                        print("Ir a Whatsapp")
                        
                        //Abrir whats
                        //let usefullWhere: String = "whatsapp://?app"
                        //let url = URL(string: usefullWhere)!
                        //UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        
                        //Enviar mensaje
                        let usefullWhere: String = "whatsapp://send?text=Power%20by%20UFind"
                        let url = URL(string: usefullWhere)!
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }))
                    
                    present(refreshAlert, animated: true, completion: nil)
                    
                }
                
            }
            
            //Web
            if indexPath.row == 2 {
                
                print("Web")
                
                if self.objNego.sitioWeb != "" {
                    
                    self.link = self.objNego.sitioWeb
                    performSegue(withIdentifier: "segueGeneralesWeb", sender: self)
                
                }
                
            }
            
            //Mail
            if indexPath.row == 3 {
                
                print("Mail")
                
                if self.objNego.correoElectronico != "" {
                
                    let mailComposeViewController = configuredMailComposeViewController()
                    if MFMailComposeViewController.canSendMail() {
                        self.present(mailComposeViewController, animated: true, completion: nil)
                    } else {
                        self.showSendMailErrorAlert()
                    }
                    
                }
                
            }
            
        }
        
        //Formas de pago
        if indexPath.section == 4 {
            
            print("Formas pago")
        }
        
        //Redes sociales
        if indexPath.section == 5 {
            
            print("Redes sociales")
            
            //Facebook
            if indexPath.row == 0 {
            
                if self.objNego.facebook != "" {
                
                    self.link = self.objNego.facebook
                    performSegue(withIdentifier: "segueGeneralesWeb", sender: self)
                }
            }
            
            //Twitter
            if indexPath.row == 1 {
                
                if self.objNego.twitter != "" {
                
                    self.link = self.objNego.twitter
                    performSegue(withIdentifier: "segueGeneralesWeb", sender: self)
                }
            }
            
            //Insta
            if indexPath.row == 2 {
            
                if self.objNego.instagram != "" {
                
                    self.link = self.objNego.instagram
                    performSegue(withIdentifier: "segueGeneralesWeb", sender: self)
                }
            }
            
        }
        
        //Favoritos
        if indexPath.section == 6 {
            
            print("Favoritos")
            
            if self.objNego.esFavorito {
                //Damos de baja
                
                self.bajaFavorito(negocioId: self.objNego.negocioId, usuarioId: self.myUsr.id)
            
            } else {
                //Damos de alta
                
                self.altaFavorito(negocioId: self.objNego.negocioId, usuarioId: self.myUsr.id)
            }
            
        }
        
    }
    
    //MARK: - Enviar Email
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        print("Email a enviar: \(self.objNego.correoElectronico)")
        mailComposerVC.setToRecipients([self.objNego.correoElectronico])
        //mailComposerVC.setSubject("Sending you an in-app e-mail...")
        //mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        
        self.customAlert(title: Alerta.sharedInstance.noEmail(), message: Alerta.sharedInstance.noEmailConfi())

    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Servicios Favoritos
    func marcarCeldaComoFavorito() {
        self.objNego.esFavorito = true
    }
    func desMarcarCeldaComoFavorito() {
        self.objNego.esFavorito = false
    }
    func comparamosSi(idEsteNegocio: Int, esFavorito: [Int]) -> Bool {
        
        for idFavorito in esFavorito {
            if idEsteNegocio == idFavorito {
                return true
            }
        }
        return false
    }
    
    func obtenNegocioId() -> Int {
        return self.objNego.negocioId
    }

    func altaFavorito(negocioId: Int, usuarioId: Int) {
        //Checamos la conexion a internet
        if Reachability.isConnectedToNetwork()
        {
            print("Connection Available!")
            
            let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressHUD.label.text = "Loading..."
            
            //Activity
            DispatchQueue.global(qos: .background).async {
                
                print("This is run on the background queue")
                
                //Servicio
                let url = Servicio.sharedInstance.registraNegocioFavorito(negocioId: "\(negocioId)", usuarioId: "\(usuarioId)")
                let response = Alamofire.request(url, method: .post, parameters: nil).responseJSON(options: .allowFragments)
                
                debugPrint("response: \(response)")
                
                if((response.result.value) != nil) {
                    
                    //Deserealizacion
                    let swiftyJsonVar = JSON(response.result.value!)
                    print("swiftyJsonVar: \(swiftyJsonVar)")
                    
                    //Obtenemos el array de objetos
                    if let resData = swiftyJsonVar["objetoResultado"].bool {
                        
                        //ObjetoResultado regresa true, es decir, se realizo correctamente
                        if resData {
                            
                            self.marcarCeldaComoFavorito()
                            print("es favorito: \(self.objNego.esFavorito)")
                            
                            //Stop activity
                            DispatchQueue.main.async {
                                //progressHUD.hide(animated: true)
                                
                                //self.tableView.reloadData()
                                //self.hideLoadingHUD()
                            }

                        }
                            //Ocurrio un error al procesar el servicio
                        else {
                            self.hideLoadingHUD()
                            
                            //Servidores fallando
                            self.customAlert(title: Alerta.sharedInstance.servidoresFallando(), message: Alerta.sharedInstance.errorServicios())
                            
                        }
                        
                        //Si no obtiene un bool del objeto resultado
                    } else {
                        
                        self.hideLoadingHUD()
                        //Servidores fallando
                        self.customAlert(title: Alerta.sharedInstance.servidoresFallando(), message: Alerta.sharedInstance.errorServicios())
                    }
                    //Nil Response
                } else {
                    
                    self.hideLoadingHUD()
                    //Servidores fallando
                    self.customAlert(title: Alerta.sharedInstance.servidoresFallando(), message: Alerta.sharedInstance.errorServicios())
                }
                DispatchQueue.main.async {
                    
                    print("This is run on the main queue, after the previous code in outer block")
                    self.tableView.reloadData()
                    self.hideLoadingHUD()
                }
                //End thread
            }
            //End conexion
        }
        //End function
    }
    func bajaFavorito(negocioId: Int, usuarioId: Int) {
        
        //Checamos la conexion a internet
        if Reachability.isConnectedToNetwork()
        {
            print("Connection Available!")
            
            let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressHUD.label.text = "Loading..."
            
            //Activity
            DispatchQueue.global(qos: .background).async {
                
                print("This is run on the background queue")
                
                //Servicio
                let url = Servicio.sharedInstance.eliminarNegocioFavorito(negocioId: "\(negocioId)", usuarioId: "\(usuarioId)")
                let response = Alamofire.request(url, method: .post, parameters: nil).responseJSON(options: .allowFragments)
                
                debugPrint("response: \(response)")
                
                if((response.result.value) != nil) {
                    
                    //Deserealizacion
                    let swiftyJsonVar = JSON(response.result.value!)
                    print("swiftyJsonVar: \(swiftyJsonVar)")
                    
                    //Obtenemos el array de objetos
                    if let resData = swiftyJsonVar["objetoResultado"].bool {
                        
                        //ObjetoResultado regresa true, es decir, se realizo correctamente
                        if resData {
                            
                            self.desMarcarCeldaComoFavorito()
                            print("es favorito: \(self.objNego.esFavorito)")

                            //Stop activity
                            DispatchQueue.main.async {
                                //progressHUD.hide(animated: true)
                                
                                self.tableView.reloadData()
                                self.hideLoadingHUD()
                            }
                            
                        }
                        //Ocurrio un error al procesar el servicio
                        else {
                            self.hideLoadingHUD()
                            
                            //Servidores fallando
                            self.customAlert(title: Alerta.sharedInstance.servidoresFallando(), message: Alerta.sharedInstance.errorServicios())
                        
                        }
                        
                    //Si no obtiene un bool del objeto resultado
                    } else {
                        
                        self.hideLoadingHUD()
                        //Servidores fallando
                        self.customAlert(title: Alerta.sharedInstance.servidoresFallando(), message: Alerta.sharedInstance.errorServicios())
                    }
                //Nil Response
                } else {
                    
                    self.hideLoadingHUD()
                    //Servidores fallando
                    self.customAlert(title: Alerta.sharedInstance.servidoresFallando(), message: Alerta.sharedInstance.errorServicios())
                }
                DispatchQueue.main.async {
                    
                    print("This is run on the main queue, after the previous code in outer block")
                }
            //End thread
            }
        //End conexion
        }
    //End function
    }

    //MARK: - Servicios
    func serviciosFavoritos(email: String) {
        
        //Checamos la conexion a internet
        if Reachability.isConnectedToNetwork()
        {
            print("Connection Available!")
            
            //Activity
            //showLoadingHUD()
            //Thread
            DispatchQueue.global(qos: .background).async {
                print("This is run on the background queue")
                
                //Obtenemos el Id del usuario
                let response = Alamofire.request(Servicio.sharedInstance.obtenUsuarioXCorreoElectronico(email: email), parameters: nil).responseJSON()
                
                //Response
                if((response.result.value) != nil) {
                    
                    //Deserealizacion
                    let swiftyJsonVar = JSON(response.result.value!)
                    print("swiftyJsonVarUsuarioXEmail: \(swiftyJsonVar)")
                    
                    //Status🛑🛑
                    if let estatus = swiftyJsonVar["estatus"].int {
                        //Todo bien
                        if estatus == 1 {
                            //ObjetoResultado
                            if let resData = swiftyJsonVar["objetoResultado"].dictionaryObject {
                                print("resData: \(resData)")
                                self.myUsr.id = resData["usuarioId"] as! Int
                                
                                let response = Alamofire.request(Servicio.sharedInstance.obtenNegociosFavoritosXUsuarioId(usuarioId: "\(self.myUsr.id)"), parameters: nil).responseJSON()
                                //Response
                                if((response.result.value) != nil) {
                                    
                                    //Deserealizacion
                                    let swiftyJsonVar = JSON(response.result.value!)
                                    print("swiftyJsonVarNegociosFavoritos: \(swiftyJsonVar)")
                                    
                                    //Status
                                    if let estatus = swiftyJsonVar["estatus"].int {
                                        //Todo bien
                                        if estatus == 1 {
                                            //ObjetoResultado
                                            if let resData = swiftyJsonVar["objetoResultado"].arrayObject {
                                                
                                                print("resData: \(resData)")
                                                
                                                //Casteamos
                                                let arrayFavIdInt = resData as! [Int]
                                                
                                                //Agregamos los Id's Favoritos
                                                for favoritoId in arrayFavIdInt {
                                                    print("favoritoId: \(favoritoId)")
                                            
                                                    self.myUsr.arrayFavoritos.append(favoritoId)
                                                }
                                            }
                                            
                                            print("arrayFavoritos: \(self.myUsr.arrayFavoritos)")
                                            
                                            //Preguntamos si trajo algun favorito
                                            if self.myUsr.arrayFavoritos.count > 0 {
                                                
                                                //Preguntamos si este negocio es favorito
                                                if self.comparamosSi(idEsteNegocio: self.obtenNegocioId(), esFavorito: self.myUsr.arrayFavoritos) {
                                                    
                                                    //Marcamos como favorito
                                                    self.marcarCeldaComoFavorito()
                                                    print("es favorito: \(self.objNego.esFavorito)")
                                                    
                                                    //Recargamos para que cargue la celda
                                                    self.tableView.reloadData()
                                                }
                                            }
                                        //Obtener favoritos distinto de 1, ocurrio un error
                                        } else {
                                        
                                            //Servidores fallando
                                            self.customAlert(title: Alerta.sharedInstance.alerta(), message: Alerta.sharedInstance.errorServicios())
                                        }
                                    //Nil status obtener favoritos
                                    } else {
                                    
                                        //Servidores fallando
                                        self.customAlert(title: Alerta.sharedInstance.servidoresFallando(), message: Alerta.sharedInstance.errorServicios())
                                    }
                                //Nil obtener favoritos usuario por id
                                } else {
                                
                                    //Servidores fallando
                                    self.customAlert(title: Alerta.sharedInstance.servidoresFallando(), message: Alerta.sharedInstance.errorServicios())
                                    
                                }
                            //Problemas al obtener el objeto resultado
                            } else {
                            
                                //Servidores fallando
                                self.customAlert(title: Alerta.sharedInstance.servidoresFallando(), message: Alerta.sharedInstance.errorServicios())
                            }
                        //Bad status obtener id usuario diferente de 1 algo salio mal
                        } else {
                        
                            //Servidores fallando
                            self.customAlert(title: Alerta.sharedInstance.servidoresFallando(), message: "Id usuario diferente 1")
                        }
                    //Nil status obtener id usuario
                    } else {
                        print("Aqui marca error en el iphone de Alex porque el json de status lo casteabamos a bool y era a int")
                        //Servidores fallando
                        self.customAlert(title: Alerta.sharedInstance.servidoresFallando(), message: Alerta.sharedInstance.errorServicios())
                    
                    }
                //🛑🛑 BREAK
                print("Error ALex")
                //Bad response id usuario nil 🛑🛑 BREAK
                } else {
                
                    //Servidores fallando
                    self.customAlert(title: Alerta.sharedInstance.servidoresFallando(), message: "Error Alex")
                
                }
            //End thread
            }
        //End conexion
        } else {
        
            print("Internet Connection not Available!")
            self.customAlert(title: Alerta.sharedInstance.conexion(), message: Alerta.sharedInstance.verificarConexion())
        
        }
    //End serviciosFavoritos
    }
    
    func getCorreo() -> String {
        
        //Conseguimos el diccionario
        let result = UserDefaults.standard.value(forKey: "userDataUFind")
        print("result: \(result)")
        
        //Si tiene algo
        if result != nil {
            
            //Casteamos
            let res = result as! [String:String]
            
            //Obtenemos correo
            let correo = res["email"]
            print("Correo: \(correo!)")
            
            return correo!
            
        } else {
            
            return ""
            
        }
    }

    func obtenNegocioXId(id: String){
        //Checamos la conexion a internet
        if Reachability.isConnectedToNetwork()
        {
            print("Connection Available!")
            
            //Activity
            let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressHUD.label.text = "Loading..."
            
            DispatchQueue.global(qos: .background).async {
                print("This is run on the background queue")
                
                //Servicio
                Alamofire.request(Servicio.sharedInstance.obtenNegocioX(id: id)).responseJSON { response in
                    
                    debugPrint("response: \(response)")
                    
                    if((response.result.value) != nil) {
                        
                        //Deserealizacion
                        let swiftyJsonVar = JSON(response.result.value!)
                        print("swiftyJsonVar: \(swiftyJsonVar)")
                        
                        //Obtenemos el estatus
                        if let estatus = swiftyJsonVar["estatus"].int {
                            
                            //Todo bien
                            if estatus == 1 {
                                
                                //Obtenemos el array de objetos
                                if let resData = swiftyJsonVar["objetoResultado"].dictionaryObject {
                                    
                                    print("resData: \(resData)")
                                    
                                    //let algo = resData["logotipo"] as? String
                                    //print("algo: \(algo)")
                                    
                                    //Estado
                                    self.objNego.negocioId = resData["negocioId"] as! Int
                                    print(self.objNego.negocioId)
                                    
                                    
                                    //Datos generales
                                    self.objNego.logotipo = resData["logotipo"] as! String
                                    print(self.objNego.logotipo)
                                    
                                    
                                    self.objNego.negocio = resData["negocio"] as! String
                                    print(self.objNego.negocio)
                                    
                                    
                                    self.objNego.direccion = resData["direccion"] as! String
                                    print(self.objNego.direccion)
                                    self.objNego.longitud = resData["longitud"] as! String
                                    print(self.objNego.longitud)
                                    self.objNego.latitud = resData["latitud"] as! String
                                    print(self.objNego.latitud)
                                    
                                    
                                    self.objNego.telefono = resData["telefono"] as! String
                                    print(self.objNego.telefono)
                                    self.objNego.whatsApp = resData["whatsApp"] as! String
                                    print(self.objNego.whatsApp)
                                    self.objNego.sitioWeb = resData["sitioWeb"] as! String
                                    print(self.objNego.sitioWeb)
                                    self.objNego.correoElectronico = resData["correoElectronico"] as! String
                                    print(self.objNego.correoElectronico)
                                    
                                    
                                    self.objNego.efectivo = resData["efectivo"] as! Bool
                                    print(self.objNego.efectivo)
                                    self.objNego.tarjetaMasterCard = resData["tarjetaMasterCard"] as! Bool
                                    print(self.objNego.tarjetaMasterCard)
                                    self.objNego.tarjetaVisa = resData["tarjetaVisa"] as! Bool
                                    print(self.objNego.tarjetaVisa)
                                    self.objNego.tarjetaAmex = resData["tarjetaAmex"] as! Bool
                                    print(self.objNego.tarjetaAmex)
                                    
                                    
                                    self.objNego.facebook = resData["facebook"] as! String
                                    print(self.objNego.facebook)
                                    self.objNego.twitter = resData["twitter"] as! String
                                    print(self.objNego.twitter)
                                    self.objNego.instagram = resData["instagram"] as! String
                                    print(self.objNego.instagram)
                                    
                                    //Descripcion
                                    self.objNego.descripcion = resData["descripcion"] as! String
                                    print(self.objNego.descripcion)
                                    
                                    //ProductoServicio
                                    self.objNego.productoServicio = resData["productoServicio"] as! String
                                    print(self.objNego.productoServicio)
                                    
                                    //Galeria
                                    self.objNego.galeria = resData["galeria"] as! [String]
                                    print(self.objNego.galeria)
                                    
                                    //Promociones
                                    self.objNego.promociones = resData["promociones"] as! [[String:AnyObject]]
                                    print(self.objNego.promociones)
                                    
                                    
                                    self.objNego.promociones = resData["promociones"] as! [[String:AnyObject]]
                                    
                                    //                                    for p in promo {
                                    //                                        let algo = p["fechaInicio"]
                                    //                                        print(algo)
                                    //                                    }
                                    
                                    //Stop activity
                                    progressHUD.hide(animated: true)
                                    
                                    //Recargamos
                                    self.tableView.reloadData()
                                }
                                
                                //Bad Status
                            } else {
                                
                                //Stop activity
                                progressHUD.hide(animated: true)
                                
                                //Servidores fallando
                                self.customAlert(title: Alerta.sharedInstance.servidoresFallando(), message: Alerta.sharedInstance.errorServicios())
                                
                            }
                            
                            //Status Nil
                        } else {
                            
                            //Stop activity
                            progressHUD.hide(animated: true)
                            
                            //Servidores fallando
                            self.customAlert(title: Alerta.sharedInstance.servidoresFallando(), message: Alerta.sharedInstance.errorServicios())
                            
                        }
                        
                        //Response
                    } else {
                        
                        //Stop activity
                        progressHUD.hide(animated: true)
                        
                        //Servidores fallando
                        self.customAlert(title: Alerta.sharedInstance.servidoresFallando(), message: Alerta.sharedInstance.errorServicios())
                    }
                    
                //End Thread
                }
                
                DispatchQueue.main.async {
                    print("This is run on the main queue, after the previous code in outer block")
                    
                }
            }
            
        //No Conexion
        } else {
            
            print("Internet Connection not Available!")
            self.customAlert(title: Alerta.sharedInstance.conexion(), message: Alerta.sharedInstance.verificarConexion())
        }
    }
    
    //MARK: - Activity
    private func showLoadingHUD() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "Loading..."
    }
    
    private func hideLoadingHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "segueGeneralesMapa" {
            let vc = segue.destination as! MapasViewController
            vc.titulo = self.objNego.negocio
            vc.latitud = self.objNego.latitud.toDouble()!
            vc.longitud = self.objNego.longitud.toDouble()!
        }
        
        if segue.identifier == "segueGeneralesWeb" {
            let vc = segue.destination as! WebViewController
            vc.link = self.link
        }
        
    }
 

}
