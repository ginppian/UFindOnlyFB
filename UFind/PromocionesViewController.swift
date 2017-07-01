//
//  PromocionesViewController.swift
//  UFind
//
//  Created by ginppian on 11/03/17.
//  Copyright © 2017 ginppian. All rights reserved.
//

import UIKit
import MXSegmentedPager
import MBProgressHUD
import Alamofire
import SwiftyJSON

class PromocionesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //Propertys
    var negocio = String()
    var objNego = objNegocio()
    
    //Array
    var arrayPromos = [objPromociones]()
    
    //Mark: - Constructor
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("PromocionesViewController")

        //TableView
        tableView.separatorColor = UIColor.orange
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0)
        
        
        self.obtenNegocioXId(id: self.negocio)
    
    }

    //MARK: - TableView
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayPromos.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detallPromocionesCell") as! detallPromocioensTableViewCell
        
        cell.imagen.downloadedFrom(link: self.arrayPromos[indexPath.row].imagen)
        cell.labelPromocion.text = self.arrayPromos[indexPath.row].promocion
        cell.labelRestriccion.text = self.arrayPromos[indexPath.row].descripcion
        
        //Primer split
        var fecha = String()
        
        let inicio = self.arrayPromos[indexPath.row].fechaInicio
        let split = inicio.components(separatedBy: "T")
        if (split.count) > 1 {
            
            let cadena = (split[0])
            fecha += cadena
            
        }

        //Agregamos un separador
        fecha += "  -  "
        
        //Segundo split
        let fin = self.arrayPromos[indexPath.row].fechaInicio
        let split2 = fin.components(separatedBy: "T")
        if (split2.count) > 1 {
            
            let cadena = (split2[0])
            fecha += cadena
            
        }
        
        //Agregamos la vigencia
        cell.labelVigencia.text = fecha
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 410.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Deselect the row
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Servicios
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
                                    
//                                    let algo = resData["logotipo"] as? String
//                                    print("algo: \(algo)")
//                                    
//                                    //Estado
//                                    self.objNego.negocioId = resData["negocioId"] as! Int
//                                    print(self.objNego.negocioId)
//                                    
//                                    
//                                    //Datos generales
//                                    self.objNego.logotipo = resData["logotipo"] as! String
//                                    print(self.objNego.logotipo)
//                                    
//                                    
//                                    self.objNego.negocio = resData["negocio"] as! String
//                                    print(self.objNego.negocio)
//                                    
//                                    
//                                    self.objNego.direccion = resData["direccion"] as! String
//                                    print(self.objNego.direccion)
//                                    self.objNego.longitud = resData["longitud"] as! String
//                                    print(self.objNego.longitud)
//                                    self.objNego.latitud = resData["latitud"] as! String
//                                    print(self.objNego.latitud)
//                                    
//                                    
//                                    self.objNego.telefono = resData["telefono"] as! String
//                                    print(self.objNego.telefono)
//                                    self.objNego.whatsApp = resData["whatsApp"] as! String
//                                    print(self.objNego.whatsApp)
//                                    self.objNego.sitioWeb = resData["sitioWeb"] as! String
//                                    print(self.objNego.sitioWeb)
//                                    self.objNego.correoElectronico = resData["correoElectronico"] as! String
//                                    print(self.objNego.correoElectronico)
//                                    
//                                    
//                                    self.objNego.efectivo = resData["efectivo"] as! Bool
//                                    print(self.objNego.efectivo)
//                                    self.objNego.tarjetaMasterCard = resData["tarjetaMasterCard"] as! Bool
//                                    print(self.objNego.tarjetaMasterCard)
//                                    self.objNego.tarjetaVisa = resData["tarjetaVisa"] as! Bool
//                                    print(self.objNego.tarjetaVisa)
//                                    self.objNego.tarjetaAmex = resData["tarjetaAmex"] as! Bool
//                                    print(self.objNego.tarjetaAmex)
//                                    
//                                    
//                                    self.objNego.facebook = resData["facebook"] as! String
//                                    print(self.objNego.facebook)
//                                    self.objNego.twitter = resData["twitter"] as! String
//                                    print(self.objNego.twitter)
//                                    self.objNego.instagram = resData["instagram"] as! String
//                                    print(self.objNego.instagram)
//                                    
//                                    //Descripcion
//                                    self.objNego.descripcion = resData["descripcion"] as! String
//                                    print(self.objNego.descripcion)
//                                    
//                                    //ProductoServicio
//                                    self.objNego.productoServicio = resData["productoServicio"] as! String
//                                    print(self.objNego.productoServicio)
//                                    
//                                    //Galeria
//                                    self.objNego.galeria = resData["galeria"] as! [String]
//                                    print(self.objNego.galeria)
                                    
                                    //Promociones
                                    self.objNego.promociones = resData["promociones"] as! [[String:AnyObject]]
                                    print(self.objNego.promociones)

                                    //Get promos
                                    for p in self.objNego.promociones {
                                        
                                        let objPromo = objPromociones()
                                        
                                        objPromo.imagen = p["imagen"] as! String
                                        objPromo.promocion = p["promocion"] as! String
                                        objPromo.descripcion = p["descripcion"] as! String
                                        objPromo.fechaInicio = p["fechaInicio"] as! String
                                        objPromo.fechaFin = p["fechaFin"] as! String
                                        objPromo.promocionId = p["promocionId"] as! Int
                                        
                                        self.arrayPromos.append(objPromo)
                                    }
                                    
                                    //Stop activity
                                    progressHUD.hide(animated: true)
                                    
                                    //Reload data
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}