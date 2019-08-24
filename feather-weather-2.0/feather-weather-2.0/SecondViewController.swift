//
//  SecondViewController.swift
//  feather-weather-2.0
//
//  Created by IO on 24/08/2019.
//  Copyright © 2019 Mukh LTD. All rights reserved.
//

import UIKit
import SwiftyJSON
import NVActivityIndicatorView
import Alamofire
import Foundation
import CoreLocation

class SecondViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searchInput: UITextField!
    @IBOutlet weak var findALocationLabel: UILabel!
    
    var owmApiKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchInput.delegate = self
    }

    @IBAction func searchButton(_ sender: Any) {
//      findALocationLabel.text = searchInput.text
        let query = searchInput.text
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?q=\(query)&appid=\(owmApiKey)").responseJSON {
            response in
            if let responseStr = response.result.value {
                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0]
                let jsonLocation = jsonResponse["name"]
                let jsonTemp = jsonResponse["main"]
                let temp = "\(Int(round(jsonTemp["temp"].doubleValue)))"
                let desc = jsonWeather["description"]
                
                
                
            }
        }
        
    }
    
}
