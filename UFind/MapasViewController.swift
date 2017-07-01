//
//  MapasViewController.swift
//  UFind
//
//  Created by ginppian on 14/03/17.
//  Copyright © 2017 ginppian. All rights reserved.
//

import UIKit
import MapKit

class MapasViewController: UIViewController, MKMapViewDelegate {
    
    //Outlets
    @IBOutlet weak var mapa: MKMapView!

    //Propertys
    var latitud = Double()
    var longitud = Double()
    var titulo = String()
    
    //MARK: - Contructor
    override func viewDidLoad() {
        super.viewDidLoad()

        //Custom anotation
        mapa.delegate = self
        
        //Mapa
        //let latitud = 19.052996
        //let longitud = -98.287899
        let location = CLLocationCoordinate2DMake(latitud, longitud)
        
        let region = MKCoordinateRegionMakeWithDistance(location, 5000.0, 7000.0)
        mapa.setRegion(region, animated: true)
        
        //Anotation
        let iqbc = CLLocationCoordinate2DMake(latitud, longitud)
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = iqbc
        dropPin.title = self.titulo
        mapa.addAnnotation(dropPin)
    
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        let annotationIdentifier = "Identifier"
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            //annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationView = annotationView {
            
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "customPin")
        }
        
        return annotationView
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
