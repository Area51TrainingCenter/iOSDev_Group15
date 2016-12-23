//
//  DetalleViewController.swift
//  Services
//
//  Created by Pablo on 22/12/16.
//  Copyright © 2016 Area51. All rights reserved.
//

import UIKit

class DetalleViewController: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCorreo: UILabel!
    
    var nombre = ""
    var correo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblName.text = nombre
        lblCorreo.text = correo
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
