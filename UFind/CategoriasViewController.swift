//
//  CategoriasViewController.swift
//  UFind
//
//  Created by ginppian on 06/03/17.
//  Copyright © 2017 ginppian. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
class CategoriasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Propertys
    var categoria = String()
    
    //MARK: - Arrays
    var arrRes = [[String:AnyObject]]()

    //MARK: - Constructor
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Obtenemos categorias
        self.obtenCategorias()
        
    }
    
    //MARK: - Servicios
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
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cellCategorias") as! CategoriasTableViewCell
        
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
            
            cell.id = id!
        
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Deseleccionamos la row
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Recuperamos la cell
        let cell = tableView.cellForRow(at: indexPath) as! CategoriasTableViewCell
        
        //Asignamos id de categoria
        self.categoria = "\(cell.id)"
        
        //Movemos
        performSegue(withIdentifier: "segueCategoriasSubcategorias", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueCategoriasSubcategorias" {
            
            let vc = segue.destination as! SubcategoriaViewController
            vc.categoria = self.categoria
        }
    }
 

}
