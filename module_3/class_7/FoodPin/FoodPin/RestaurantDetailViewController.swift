//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by David Velarde on 20/7/2016.
//  Copyright © 2017 Area51. All rights reserved.
//

import UIKit
import MapKit
import CoreData

import Alamofire
import SwiftyJSON
import SVProgressHUD

class RestaurantDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var restaurantImageView: UIImageView!
    @IBOutlet var tableView:UITableView!
    @IBOutlet var mapView: MKMapView!
    
    var restaurant:RestaurantMO!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let imageData = restaurant.image {
            if let image = UIImage(data:imageData as Data) {
                restaurantImageView.image = image
            }
        }
        
        
        
        tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.2)
        tableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
        
        title = restaurant.name
        
        navigationController?.hidesBarsOnSwipe = false
        
        // Enable self sizing cells
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Handle tap gesture for the map view
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showMap))
        mapView.addGestureRecognizer(tapGestureRecognizer)
        
        // Pin the restaurant location on map
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location!, completionHandler: { placemarks, error in
            if error != nil {
                print(error)
                return
            }
            
            if let placemarks = placemarks {
                // Get the first placemark
                let placemark = placemarks[0]
                
                // Add annotation
                let annotation = MKPointAnnotation()
                
                if let location = placemark.location {
                    // Display the annotation
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)

                    // Set the zoom level
                    let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 250, 250)
                    self.mapView.setRegion(region, animated: false)
                }
            }
            
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showMap() {
        performSegue(withIdentifier: "showMap", sender: self)
    }

    // MARK: - UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RestaurantDetailTableViewCell
        
        // Configure the cell...
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "Nombre"
            cell.valueLabel.text = restaurant.name
        case 1:
            cell.fieldLabel.text = "Tipo"
            cell.valueLabel.text = restaurant.type
        case 2:
            cell.fieldLabel.text = "Ubicacion"
            cell.valueLabel.text = restaurant.location
        case 3:
            cell.fieldLabel.text = "Telefono"
            cell.valueLabel.text = restaurant.phone
        case 4:
            
            cell.fieldLabel.text = "He estado aqui"
            
            var beenHere = (restaurant.isVisited) ? "Si, he estado aqui antes. " : "No"
            
            if let rating = restaurant.rating {
                beenHere += rating
            }
            
            cell.valueLabel.text = beenHere
            
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        
        cell.backgroundColor = UIColor.clear
        
        return cell
    } 

    @IBAction func close(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func ratingButtonTapped(segue: UIStoryboardSegue) {
        if let rating = segue.identifier {
            
            restaurant.isVisited = true
            
            switch rating {
            case "great": restaurant.rating = "Me encanto."
            case "good": restaurant.rating = "Estuvo bien."
            case "dislike": restaurant.rating = "😷"
            default: break
            }
            
            restaurant.name = restaurant.name! + " 👀"
        }
        
        let params = [
            "name":restaurant.name!,
            "location": restaurant.location!,
            "type":restaurant.type!,
            "isvisited":restaurant.isVisited,
            "rating":restaurant.rating!
        ] as [String : Any]
        
        
        SVProgressHUD.show(withStatus: "Actualizando Restaurante")
        Alamofire.request("https://vapor-area51.herokuapp.com/restaurants/\(restaurant.restaurantId)", method: .patch, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (dataResponse) in
            SVProgressHUD.dismiss()
            switch dataResponse.result {
                
            case .success:
                
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
                    appDelegate.saveContext()
                }
                
                //Save Context
                
                self.tableView.reloadData()
                
            case .failure(let error):
                print("Error")
            
            }
            
        }
        
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReview" {
            let destinationController = segue.destination as! ReviewViewController
            destinationController.restaurant = restaurant
        
        } else if segue.identifier == "showMap" {
            let destinationController = segue.destination as! MapViewController
            destinationController.restaurant = restaurant
        }
    }
    
}
