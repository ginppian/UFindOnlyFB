//
//  DetalladaViewController.swift
//  UFind
//
//  Created by ginppian on 11/03/17.
//  Copyright © 2017 ginppian. All rights reserved.
//

import UIKit
import MXSegmentedPager

class DetalladaViewController: MXSegmentedPagerController {
    
    //MARK: Propertys
    //Recibimos de SubcategoriaViewController
    var negocio = String()

    //MARK: - Outlets
    @IBOutlet var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("DatalladaViewController")
        
        // Parallax Header
        self.segmentedPager.parallaxHeader.view = headerView
        self.segmentedPager.parallaxHeader.mode = MXParallaxHeaderMode.fill
        self.segmentedPager.parallaxHeader.height = 60
        self.segmentedPager.parallaxHeader.minimumHeight = 20
        
        
        // Segmented Control customization
        self.segmentedPager.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down
        self.segmentedPager.segmentedControl.backgroundColor = UIColor.black
        self.segmentedPager.segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.segmentedPager.segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.segmentedPager.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyle.fullWidthStripe
        self.segmentedPager.segmentedControl.selectionIndicatorColor = UIColor.orange
        
    }

    //MARK: - MXSegmentedPager
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        return ["DATOS GENERALES", "DESCRIPCION", "PRODUCTO / SERVICIO", "GALERÍA", "PROMOCIONES"][index]
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, didScrollWith parallaxHeader: MXParallaxHeader) {
        print("progress \(parallaxHeader.progress)")
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Generales
        if segue.identifier == "mx_page_0" {
            let vc = segue.destination as! GeneralesViewController
            vc.negocio = self.negocio
        }
        
        //Descripcion
        if segue.identifier == "mx_page_1" {
            let vc = segue.destination as! DescripcionViewController
            vc.negocio = self.negocio
        }
        
        //ProductoServicio
        if segue.identifier == "mx_page_2" {
            let vc = segue.destination as! ProductoViewController
            vc.negocio = self.negocio
        }
        
        //Galeria
        if segue.identifier == "mx_page_3" {
            let vc = segue.destination as! GaleriaViewController
            vc.negocio = self.negocio
        }
        
        //Promociones
        if segue.identifier == "mx_page_4" {
            let vc = segue.destination as! PromocionesViewController
            vc.negocio = self.negocio
        }
    }
 

}
