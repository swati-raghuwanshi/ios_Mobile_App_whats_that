//
//  MapViewController.swift
//  WatsDat
//
//  Created by Swati Raghuwanshi on 12/10/17.
//  Copyright © 2017 Swati Raghuwanshi. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    let reuseIdentifier = "myAnnotation"
    var titleHead = ""
    var filename: URL?
    var latitude = 0.0
    var longitude = 0.0
    
    
    var favorites = [Favorite]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        // performSegue(withIdentifier: mapToDetailSegue, sender: nil)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        favorites = PersistanceManager.sharedInstance.fetchFavorites()
        mapView.addAnnotations(favorites)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = false
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let favorite = view.annotation as! Favorite
        titleHead = favorite.favTitle
        filename = favorite.filename
        latitude = favorite.latitude ?? 0.0
        longitude = favorite.longitude ?? 0.0
        performSegue(withIdentifier: "mapToDetailSegue", sender: nil)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapToDetailSegue" {
            let myVC = segue.destination as! PhotoDetailsViewController
            
            
            myVC.titleHead = titleHead
            myVC.filename = filename
            myVC.latitude = latitude
            myVC.longitude = longitude
            
            
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
