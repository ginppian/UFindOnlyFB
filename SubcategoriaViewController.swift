//
//  SubcategoriaViewController.swift
//  UFind
//
//  Created by ginppian on 06/03/17.
//  Copyright © 2017 ginppian. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import SwiftyJSON

class SubcategoriaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Propertys
    //Recibimos de CategoriaViewController
    var categoria = String()
    var negocio = String()
    //Scroll
    var pageNumber = 1
    var isLoading = false

    //MARK: - Arrays
    var arrRes = [[String:AnyObject]]()
    var arrayObj = [[String:AnyObject]]()
    
    //MARK: - Constructor
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SubcategoriaViewController")
        //TableView
        tableView.separatorColor = UIColor.orange
        //self.edgesForExtendedLayout = UIRectEdge.top
        
        //Subcategorias
        //self.obtenSubcategorias(pageNumber: self.pageNumber)

    }

    //MARK: - Servicios
    func obtenSubcategorias(pageNumber: Int) {
        //Checamos la conexion a internet
        if Reachability.isConnectedToNetwork()
        {
            print("Connection Available!")
            
            let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressHUD.label.text = "Loading..."
            
            //Activity
            DispatchQueue.global(qos: .userInteractive).async {
                
                print("This is run on the background queue")
                
                //Servicio
                Alamofire.request(Servicio.sharedInstance.obtenerNegociosPor(categoria: self.categoria, numeroPagina: "\(self.pageNumber)", latitud: Coordenadas.sharedInstance.getLati(), longitud: Coordenadas.sharedInstance.getLongi())).responseJSON { response in
                    
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
                                if let resData = swiftyJsonVar["objetoResultado"].arrayObject {
                                    self.arrRes = resData as! [[String:AnyObject]]
                                }
                                
                                //Si el array de objetos tiene algo
                                if self.arrRes.count > 0 {
                                    
                                    for obj in self.arrRes
                                    {
                                        
                                        let row = self.arrayObj.count
                                        print(row)
                                        let indexPath = IndexPath(row: row, section: 0)
                                        print(obj)
                                        self.arrayObj.append(obj)
                                        
                                        
                                        self.tableView.beginUpdates()
                                        self.tableView.insertRows(at: [indexPath], with: .fade)
                                        self.tableView.endUpdates()
                                        
                                    }
                                    print("self.pageNumber: \(self.pageNumber)")
                                    self.pageNumber += 1
                                    self.isLoading = false
                                    
                                    //Ocultamos activity
                                    progressHUD.hide(animated: true)
                                    
                                    //Recargamos la tabla
                                    //self.tableView.reloadData()
                                    
                                    //Si no trae datos
                                } else {
                                    
                                    //Ocultamos activity
                                    self.hideLoadingHUD()
                                    
                                }
                                
//                                //Obtenemos el array de objetos
//                                if let resData = swiftyJsonVar["objetoResultado"].arrayObject {
//                                    
//                                    self.arrRes = resData as! [[String:AnyObject]]
//                                    
//                                    //Stop activity
//                                    progressHUD.hide(animated: true)
//                                    
//                                    
//                                } else {
//                                    
//                                    //Stop activity
//                                    progressHUD.hide(animated: true)
//                                
//                                }
//                                
//                                //Si el array de objetos tiene algo
//                                if self.arrRes.count > 0 {
//                                    
//                                    //Recargamos la tabla
//                                    self.tableView.reloadData()
//                                    
//                                }
                            
                            //Bad Status - No trajo NADA
                            } else {
                                
                                print("bad status")
                                
                                //Stop activity
                                progressHUD.hide(animated: true)
                                
                            }
                            
                        //Status Nil
                        } else {
                            print("status nil")
                            //Stop activity
                            progressHUD.hide(animated: true)
                            
                            //Servidores fallando
                            self.customAlert(title: Alerta.sharedInstance.servidoresFallando(), message: Alerta.sharedInstance.errorServicios())
                            
                        }
                        
                     //Response Nil
                    } else {
                        print("response nil")
                        //Stop activity
                        progressHUD.hide(animated: true)
                        
                        //Servidores fallando
                        self.customAlert(title: Alerta.sharedInstance.servidoresFallando(), message: Alerta.sharedInstance.errorServicios())
                    }
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

    //MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayObj.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cellSubcategoria")! as! SubcategoriaTableViewCell

        
        var objeto = self.arrayObj[indexPath.row]
        
        let tit = objeto["negocio"] as? String
        let dir = objeto["direccion"] as? String
        let tel = objeto["telefono"] as? String
        let met = objeto["metros"] as? Float
        let id = objeto["negocioId"] as? String
        let log = objeto["logotipo"] as? String

        //Titulo
        if tit != nil {
            
            cell.titulo.text = tit
            
        } else {
            
            cell.titulo.text = ""
            
        }
        //Direccion
        if dir != nil {
            
            cell.direccion.text = dir
            
        } else {
            
            cell.direccion.text = ""
            
        }
        //Tel
        if tel != nil {
            
            cell.telefono.text = tel
            
        } else {
            
            cell.telefono.text = ""
            
        }
        //Metros - Distancia
        if met != nil {
            
            cell.distancia.text = "\(met!/1000) Km"
            
        } else {
            
            cell.distancia.text = ""
            
        }
        //Imagen
        if log != nil {
            
            cell.imagen.downloadedFrom(link: log!)
            
        }
        //NegocioID
        if id != nil {
            
            cell.id = id!
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Deseleccionamos la row
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Recuperamos la cell
        let cell = tableView.cellForRow(at: indexPath) as! SubcategoriaTableViewCell
        
        //Asignamos id del negocio
        self.negocio = "\(cell.id)"
        
        //Movemos vista detallada
        self.performSegue(withIdentifier: "segueSubcategoriaDetallada", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 144.0
    }
    
    //MARK: - Scroll
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        print("scrollViewWillBeginDragging")
        isLoading = false
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (maxOffset - offset) <= 0 {
            if !self.isLoading {
                self.isLoading = true
                //self.pageNumber += 1
                
                self.obtenSubcategorias(pageNumber: self.pageNumber)
            }
        }
        
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
        if segue.identifier == "segueSubcategoriaDetallada" {
            
            let vc = segue.destination as! DetalladaViewController
            vc.negocio = self.negocio
            
        }
    }

}
