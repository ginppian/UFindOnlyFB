//
//  InfcuponesViewController.swift
//  UFind
//
//  Created by ginppian on 15/03/17.
//  Copyright © 2017 ginppian. All rights reserved.
//

import Alamofire
import SwiftyJSON
import MBProgressHUD

class InfcuponesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //Propertys
    var categoria = String()
    var pageNumber = 1
    var isLoading = false

    //Arrays
    var arrayPromos = [objPromociones]()

    
    //MARK: - Constructor
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TableView
        tableView.separatorColor = UIColor.orange
        //tableView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0)

        print("categoria: \(self.categoria)")
        
        //self.obtenPromos(categoria: self.categoria)
    }
    
    //MARK: - TableView
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayPromos.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //DESELECT ROW COLOR
        //let backgroundView = UIView()
        //backgroundView.backgroundColor = UIColor.cyan
        //cell.selectedBackgroundView = backgroundView
        
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
        
        //Deselect row
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Servicios
    func obtenPromos(categoria: String) {
        
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
                let url = Servicio.sharedInstance.obtenPromocionesPaginadasXCategoriaId(categoriaId: categoria, numeroPagina: "\(self.pageNumber)")
                Alamofire.request(url).responseJSON { response in
                    
                    debugPrint("response: \(response)")
                    
                    
                    if((response.result.value) != nil) {
                        
                        //Deserealizacion
                        let swiftyJsonVar = JSON(response.result.value!)
                        print("swiftyJsonVar: \(swiftyJsonVar)")
                        
                        //Obtenemos el array de objetos
                        if let resData = swiftyJsonVar["objetoResultado"].arrayObject {
                            
                            let promos = resData as! [[String:AnyObject]]
                            
                            //Arreglo trae elementos
                            if promos.count > 0 {
                                
                                for p in promos {
                                    
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
                                
                                self.pageNumber += 1
                                self.isLoading = false
                                
                                //Recargamos la tabla
                                self.tableView.reloadData()
                                
                            } else {
                            
                                //Stop activity
                                progressHUD.hide(animated: true)
                            
                            }
                            
                        } else {
                            
                            //Stop activity
                            progressHUD.hide(animated: true)
                        
                        }
                        
                    } else {
                        
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
            
        } else {
            
            print("Internet Connection not Available!")
            self.customAlert(title: Alerta.sharedInstance.conexion(), message: Alerta.sharedInstance.verificarConexion())
        }
        
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
                
                self.obtenPromos(categoria: self.categoria)
            }
        }
        
    }
    

}
