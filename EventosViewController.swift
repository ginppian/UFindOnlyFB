//
//  EventosViewController.swift
//  UFind
//
//  Created by ginppian on 07/03/17.
//  Copyright © 2017 ginppian. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class EventosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var fondo: UIImageView!
    
    //MARK: - Propertys
    //Scroll
    var pageNumberCon = 1
    var pageNumberDep = 1
    var pageNumberExp = 1
    var pageNumberOtr = 1
    var isLoading = false
    
    //MARK: - Arrays
    var arrRes = [[String:AnyObject]]()
    var arrayObj = [[String:AnyObject]]()
    
    //MARK: - Constructor
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.segmentedAction(self.segmented)

        //TableView
        //Transparencia table
        tableView.backgroundColor = UIColor.clear

    }
    
    func obtenEventos(categoriaId: String, numeroPagina: String) {
        
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
                Alamofire.request(Servicio.sharedInstance.obtenEventoPaginadoXCategoriaId(categoriaId: categoriaId, numeroPagina: numeroPagina)).responseJSON { response in
                    
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
                            
                            self.isLoading = false
                            print("categoriaId: \(categoriaId)")
                            
                            switch categoriaId {
                            case "1":
                                self.pageNumberCon += 1
                            case "2":
                                self.pageNumberDep += 1
                            case "3":
                                self.pageNumberExp += 1
                            case "4":
                                self.pageNumberOtr += 1
                            default:
                                print("Error")
                                return
                            }
                            
                            
                            //Ocultamos activity
                            progressHUD.hide(animated: true)
                            
                            //Recargamos la tabla
                            //self.tableView.reloadData()
                            
                            //Si no trae datos
                        } else {
                            
                            //Ocultamos activity
                            progressHUD.hide(animated: true)
                            
                        }
                        
                        
                        
                        //                    if((response.result.value) != nil) {
                        //
                        //                        //Deserealizacion
                        //                        let swiftyJsonVar = JSON(response.result.value!)
                        //                        print("swiftyJsonVar: \(swiftyJsonVar)")
                        //
                        //                        //Obtenemos el array de objetos
                        //                        if let resData = swiftyJsonVar["objetoResultado"].arrayObject {
                        //                            self.arrRes = resData as! [[String:AnyObject]]
                        //
                        //                            //Stop activity
                        //                            progressHUD.hide(animated: true)
                        //
                        //                        }
                        //
                        //                        //Si el array de objetos tiene algo
                        //                        //if self.arrRes.count > 0 {
                        //                            
                        //                            //Recargamos la tabla
                        //                            self.tableView.reloadData()
                        //                            
                        //                        //}
                        
                    } else {
                        print("Response value nil - Ya no trajo nada")
                        //Ocultamos activity
                        progressHUD.hide(animated: true)
                        
                        //Servidores fallando
                        //self.customAlert(title: Alerta.sharedInstance.servidoresFallando(), message: Alerta.sharedInstance.errorServicios())
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
    
    //MARK: - Segmented Controll
    
    @IBAction func segmentedAction(_ sender: UISegmentedControl) {

        let categoriaId = segmented.selectedSegmentIndex + 1
        
        switch categoriaId {
            
        case 1:
            print("conciertos")
            self.fondo.image = UIImage(named: "fondo_1")
            self.arrayObj.removeAll()
            self.tableView.reloadData()
            self.pageNumberCon = 1
            self.obtenEventos(categoriaId: "\(categoriaId)", numeroPagina: "\(self.pageNumberCon)")
            
        case 2:
            print("deportes")
            self.fondo.image = UIImage(named: "fondo_3")
            self.arrayObj.removeAll()
            self.tableView.reloadData()
            self.pageNumberDep = 1
            self.obtenEventos(categoriaId: "\(categoriaId)", numeroPagina: "\(self.pageNumberDep)")
            
        case 3:
            print("exposiciones")
            self.fondo.image = UIImage(named: "fondo_2")
            self.arrayObj.removeAll()
            self.tableView.reloadData()
            self.pageNumberExp = 1
            self.obtenEventos(categoriaId: "\(categoriaId)", numeroPagina: "\(self.pageNumberExp)")
            
        case 4:
            print("otros...")
            self.fondo.image = UIImage(named: "fondo_4")
            self.arrayObj.removeAll()
            self.tableView.reloadData()
            self.pageNumberOtr = 1
            self.obtenEventos(categoriaId: "\(categoriaId)", numeroPagina: "\(self.pageNumberOtr)")
            
        default:
            
            print("Primera vez - musica")
            self.obtenEventos(categoriaId: "\(categoriaId)", numeroPagina: "\(self.pageNumberCon)")
            
        }
        
    }
    
    //MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayObj.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Celda
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "eventosCell") as! eventosTableViewCell
        
        //Objeto
        var objeto = self.arrayObj[indexPath.row]
        
        //Campos
        let titul = objeto["titulo"] as? String
        let subti = objeto["subTitulo"] as? String
        let lugar = objeto["lugar"] as? String
        //Dividir la fecha ya que viene en este formato: 2017-03-10T00:00:00
        let fecha = objeto["fecha"] as? String
        let hora = objeto["hora"] as? String
        //Arrays
        let puntosV = objeto["puntosVenta"] as? [String]
        let precios = objeto["precios"] as? [AnyObject
        ]
        //Imgn
        let imge = objeto["rutaImagenPrincipal"] as? String
        //Id
        let id = objeto["categoriaId"] as? Int

        //Titulo
        if titul != nil {
            
            cell.labelTitulo.text = titul
            
        } else {
            
            cell.labelTitulo.text = ""
            
        }
        
        //Subtitulo
        if subti != nil {
            
            cell.labelSubtitulo.text = subti
            
        } else {
            
            cell.labelSubtitulo.text = ""
            
        }
        
        //Lugar
        if lugar != nil {
            
            cell.labelLugar.text = lugar
            
        } else {
            
            cell.labelLugar.text = ""
            
        }
        
        //Fecha
        if fecha != nil {
            
            let split = fecha?.components(separatedBy: "T")
            if (split?.count)! > 1 {
                
                let cadena = (split?[0])!
                cell.labelFecha.text = cadena
                
            } else {
                
                cell.labelFecha.text = ""

            }
            
        } else {
            
            cell.labelFecha.text = ""
            
        }
        
        //Hora
        if hora != nil {
            
            cell.labelHora.text = hora
            
        } else {
            
            cell.labelHora.text = ""
            
        }
        
        //Puntos de venta - Array
        if puntosV != nil {
            
            if puntosV != nil && (puntosV?.count)! > 0{
                
                var cadena = String()
                for pv in puntosV! {
                    
                    cadena += " \(pv)"
                    
                }
                
                cell.labelPuntosVenta.text = cadena
            
            } else {
            
                cell.labelPuntosVenta.text = ""
                
            }
            
        } else {
            
            cell.labelPuntosVenta.text = ""
            
        }
        
        //Precios - Array
        if precios != nil {
            
            let detalle = precios?[0] as? [String: AnyObject]
            
            if detalle != nil && (detalle?.count)! > 0{
                
                let cantidad = detalle?["cantidad"] as? Float
                let concepto = detalle?["concepto"] as? String
                
                if cantidad != nil && concepto != nil {
                    
                    cell.labelPrecios.text = "\(cantidad!) \(concepto!)"
                    
                } else {
                
                    cell.labelPrecios.text = ""
                }
                
            } else {
                
                cell.labelPrecios.text = ""
            }
            
        } else {
            
            cell.labelPrecios.text = ""
        }

        //Imagen
        if imge != nil {
            
            cell.imagen.downloadedFrom(link: imge!)
            
        }
        
        //Id
        if id != nil {
            
            cell.eventoId = "\(id)"
            
        }
        
        cell.backgroundColor = UIColor.clear
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Deseleccionamos la row
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Recuperamos la cell
        //let cell = tableView.cellForRow(at: indexPath) as! eventosTableViewCell
        
        //Asignamos id de categoria
        //self.categoria = "\(cell.id)"
        
        //Movemos
        //performSegue(withIdentifier: "segueCategoriasSubcategorias", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 254.0
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
                
                
                let categoriaId = segmented.selectedSegmentIndex + 1
                
                switch categoriaId {
                    
                case 1:
                self.obtenEventos(categoriaId: "\(categoriaId)", numeroPagina: "\(self.pageNumberCon)")
                    
                case 2:
                self.obtenEventos(categoriaId: "\(categoriaId)", numeroPagina: "\(self.pageNumberDep)")
                    
                case 3:
                self.obtenEventos(categoriaId: "\(categoriaId)", numeroPagina: "\(self.pageNumberExp)")
                    
                case 4:
                self.obtenEventos(categoriaId: "\(categoriaId)", numeroPagina: "\(self.pageNumberOtr)")
                    
                default:
                    
                    print("Primera vez - musica")
                    self.obtenEventos(categoriaId: "\(categoriaId)", numeroPagina: "\(self.pageNumberCon)")
                    
                }
                

            }
        }
        
    }
    
    //Hidden navigation bar
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "segueEventosDetallada" {
//            let vc = segue.destination as! DetalladaViewController
//            vc.descripcion = self.descripcion
//            vc.imagen = self.imagen
//        }
    }
 

}
