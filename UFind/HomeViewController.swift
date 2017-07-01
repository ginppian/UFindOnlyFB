//
//  ViewController.swift
//  UFind
//
//  Created by ginppian on 24/02/17.
//  Copyright © 2017 ginppian. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - Propertys
    var descripcion = String()
    //Enviamos negocio a DetalladaViewController
    var negocio = String()
    //Scroll
    var pageNumber = 1
    var isLoading = false

    //MARK: - Arrays
    var arrRes = [[String:AnyObject]]()
    var arrayObj = [[String:AnyObject]]()

    //MARK: - Navegacion
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Dismiss keyboard
        self.hideKeyboardWhenTappedAround()
        
        //Keyboard Buscar Button
        searchBar.delegate = self
        
        //TableView
        tableView.separatorColor = UIColor.orange
        //self.edgesForExtendedLayout = UIRectEdge.top

        //Obtenemos categorias
        self.obtenNegocios(descripcion: self.descripcion, pageNumber: self.pageNumber)
    }
    
    func obtenNegocios(descripcion: String, pageNumber: Int) {
        
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
                Alamofire.request(Servicio.sharedInstance.obtenerNegocioPor(descripcion: descripcion, numeroPagina: "\(self.pageNumber)", latitud: Coordenadas.sharedInstance.getLati(), longitud: Coordenadas.sharedInstance.getLongi())).responseJSON { response in
                    
                    debugPrint("response: \(response)")
                    
                    
                    if((response.result.value) != nil) {
                        
                        //Deserealizacion
                        let swiftyJsonVar = JSON(response.result.value!)
                        print("swiftyJsonVar: \(swiftyJsonVar)")
                        
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
                            print(self.pageNumber)
                            self.pageNumber += 1
                            self.isLoading = false

                            //Ocultamos activity
                            progressHUD.hide(animated: true)
                            
                            //Recargamos la tabla
                            //self.tableView.reloadData()
                           
                        //Si no trae datos
    

                            //Ocultamos activity
                            progressHUD.hide(animated: true)

                        } else {
                            
                            //Ocultamos activity
                            progressHUD.hide(animated: true)
                            
                            //Servidores fallando
                            //self.customAlert(title: Alerta.sharedInstance.buscar(), message: Alerta.sharedInstance.noResultados())
                        }

                    } else {
                        
                        //Ocultamos activity
                        progressHUD.hide(animated: true)
                        
                        //Servidores fallando
                        self.customAlert(title: Alerta.sharedInstance.buscar(), message: Alerta.sharedInstance.noResultados())
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
    
    //MARK: - Search Bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text!)
        searchBar.resignFirstResponder()
        
        //Limpiamos el paged index
        self.pageNumber = 1
        //Limpiamos el arreglo
        self.arrayObj.removeAll()
        self.tableView.reloadData()
        
        //Agregamos la descripcion de busqueda
        let textoConEspacios = searchBar.text!.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        self.descripcion = textoConEspacios
        
        self.obtenNegocios(descripcion: self.descripcion, pageNumber: self.pageNumber)
    }
    
    //MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayObj.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "negocioCell")! as! NegociosTableViewCell
        
        var objeto = arrayObj[indexPath.row]
        print(objeto)
        
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
        let cell = tableView.cellForRow(at: indexPath) as! NegociosTableViewCell
        
        //Asignamos id del negocio
        self.negocio = "\(cell.id)"
        
        //Movemos a vista detallada
        performSegue(withIdentifier: "segueHomeDetallada", sender: self)
        
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
                
                self.obtenNegocios(descripcion: self.descripcion, pageNumber: self.pageNumber)
            }
        }
        
    }
    
    //Hidden navigation bar
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
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
        if segue.identifier == "segueHomeDetallada" {
            
            let vc = segue.destination as! DetalladaViewController
            vc.negocio = self.negocio

        }
    }
    
}

