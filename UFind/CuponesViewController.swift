//
//  CuponesViewController.swift
//  
//
//  Created by ginppian on 07/03/17.
//
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class CuponesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Propertys
    var categoria = String()
    
    //MARK: - Arrays
    var arrRes = [[String:AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Obtenemos categorias
        self.obtenCategorias()
    }

    func obtenCategorias () {
        
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
                Alamofire.request(Servicio.sharedInstance.negocioObtenCategorias()).responseJSON { response in
                    
                    debugPrint("response: \(response)")
                    
                    
                    if((response.result.value) != nil) {
                        
                        //Deserealizacion
                        let swiftyJsonVar = JSON(response.result.value!)
                        print("swiftyJsonVar: \(swiftyJsonVar)")
                        
                        //Obtenemos el array de objetos
                        if let resData = swiftyJsonVar["objetoResultado"].arrayObject {
                            self.arrRes = resData as! [[String:AnyObject]]
                            
                            //Stop activity
                            progressHUD.hide(animated: true)
                            
                        }
                        
                        //Si el array de objetos tiene algo
                        if self.arrRes.count > 0 {
                            
                            //Recargamos la tabla
                            self.tableView.reloadData()
                            
                        }
                        
                    } else {
                        
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
    
    //MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrRes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cellPromociones") as! PromocionesTableViewCell
        
        var objeto = self.arrRes[indexPath.row]
        
        let desc = objeto["descripcion"] as? String
        let icon = objeto["icono"] as? String
        let id = objeto["identificador"] as? Int
        
        if desc != nil {
            
            cell.label.text = desc
            
        } else {
            
            cell.label.text = ""
            
        }
        
        if icon != nil {
            
            cell.imagen.downloadedFrom(link: icon!)
            
        }
        
        if id != nil {
            
            cell.id = "\(id!)"
            print("cell.id: \(cell.id)")
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Deseleccionamos la row
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Recuperamos la cell
        let cell = tableView.cellForRow(at: indexPath) as! PromocionesTableViewCell
        
        //Asignamos id de categoria
        self.categoria = "\(cell.id)"

        //Movemos
        performSegue(withIdentifier: "segueCuponesInfocupones", sender: self)
        
    }

    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueCuponesInfocupones" {
            let vc = segue.destination as! InfcuponesViewController
            vc.categoria = self.categoria

        }
    }

}
