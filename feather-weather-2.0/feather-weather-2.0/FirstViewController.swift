//
//  FirstViewController.swift
//  feather-weather-2.0
//
//  Created by IO on 24/08/2019.
//  Copyright © 2019 Mukh LTD. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON
import NVActivityIndicatorView
import Alamofire
import Foundation
import CoreLocation


class FirstViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherTempLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    
    var owmApiKey = ""
    var activityIndicator: NVActivityIndicatorView!
    let locationManager = CLLocationManager()
    
    
    
    
    
    
    
    var player: AVPlayer?
    
    override func viewDidLoad() {
        backgroundRain()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let indicatorSize: CGFloat = 70;
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize/2), y: (view.frame.height-indicatorSize/2), width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
        activityIndicator.backgroundColor = UIColor.black
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        //        Pop up notification requesting privliages to use location services.
        locationManager.requestWhenInUseAuthorization()
        
        activityIndicator.startAnimating()
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func backgroundRain() {
        let path = Bundle.main.path(forResource: "rain.mp4", ofType: nil)
        player = AVPlayer(url: URL(fileURLWithPath: path!))
        player!.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.view.layer.insertSublayer(playerLayer, at: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player!.currentItem)
        player!.seek(to: CMTime.zero)
        player!.play()
        self.player?.isMuted = true
    }
    
    @objc func playerItemDidReachEnd() {
        player!.seek(to: CMTime.zero)
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(owmApiKey)&units=metric").responseJSON {
            response in
            self.activityIndicator.stopAnimating()
            if let responseStr = response.result.value {
                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0]
                let jsonTemp = jsonResponse["main"]
                let iconName = jsonWeather["icon"].stringValue
                
                let temp = "\(Int(round(jsonTemp["temp"].doubleValue)))"
                let condition = jsonWeather["main"].stringValue
                let weatherTemp = condition + ", " + temp
                self.weatherTempLabel.text = weatherTemp
                self.locationLabel.text = jsonResponse["name"].stringValue
                
                switch iconName {
                    
                case "n01":
                    print("n01")
                
                
                default:
                    print("default triggered")
                }
                
            }
        }
        self.locationManager.stopUpdatingLocation()
        
    }
}

