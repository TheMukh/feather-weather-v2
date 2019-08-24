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
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    
    var owmApiKey = ""
    var activityIndicator: NVActivityIndicatorView!
    let locationManager = CLLocationManager()
    
    
    var player: AVPlayer?
    
    override func viewDidLoad() {
        backgroundRain(filename: "50d.mp4")
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let indicatorSize: CGFloat = 70;
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize/2), y: (view.frame.height-indicatorSize/2), width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
        activityIndicator.backgroundColor = UIColor.black
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        locationManager.requestWhenInUseAuthorization()
        activityIndicator.startAnimating()
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func backgroundRain(filename: String) {
        let path = Bundle.main.path(forResource: filename, ofType: nil)
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
                let weatherTemp = condition + ", " + temp + "℃"
                self.weatherTempLabel.text = weatherTemp
                let locationName = jsonResponse["name"].stringValue
                let country = jsonResponse["sys"]["country"].stringValue
                self.locationLabel.text = locationName + ", " + country
                
                let humidity = jsonTemp["humidity"].stringValue
                self.humidityLabel.text = "Humidity: " + humidity
                let pressure = jsonTemp["pressure"].stringValue
                self.pressureLabel.text = "Pressure: " + pressure
                
                let windSpeed = jsonResponse["wind"]["speed"].stringValue
                self.windSpeedLabel.text = "Wind Speed: " + windSpeed
                let windDeg = jsonResponse["wind"]["deg"].stringValue
                self.windDirectionLabel.text = "Wind Direction: " + windDeg
            
                switch iconName {
                    
                case "01d":
                    print("Clear Sky")
//                    var player: AVPlayer?
//                    let filename = "01d.mp4"
//                    let path = Bundle.main.path(forResource: filename, ofType: nil)
//                    player = AVPlayer(url: URL(fileURLWithPath: path!))
//                    player!.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
//                    let playerLayer = AVPlayerLayer(player: player)
//                    playerLayer.frame = self.view.frame
//                    playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//                    self.view.layer.insertSublayer(playerLayer, at: 0)
//                    NotificationCenter.default.addObserver(self, selector: #selector(self.playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player!.currentItem)
//                    player!.seek(to: CMTime.zero)
//                    player!.play()
//                    self.player?.isMuted = true
//                    player!.seek(to: CMTime.zero)
                    
                case "01n":
                    print("Clear Sky Night")
                    
                case "02d":
                    print("Few Clouds")
                    
                case "02n":
                    print("Few Clouds Night")
                    
                case "03d":
                    print("scattered clouds")
                    
                case "03n":
                    print("scattered clouds night")
                    
                case "04d":
                    print("broken clouds")
                    
                case "04n":
                    print("broken clouds night")
                    
                case "09d":
                    print("Showering Rainfall")
                    
                case "09n":
                    print("Showering Rainfall Night")
                    
                case "10d":
                    print("rain")
                    
                case "10n":
                    print("rain night")
                    
                case "11d":
                    print("thunderstorm")
                    
                case "11n":
                    print("thunderstorm")
                    
                case "13d":
                    print("snow")
                    
                case "13n":
                    print("snow night")
                    
                case "50d":
                    print("mist")
                    
                case "50n":
                    print("mist night")
                default:
                    print("Image doesnt match SWITCH case?")
                }

//                var player: AVPlayer?
//                var filename = "50d.mp4"
//                let path = Bundle.main.path(forResource: filename, ofType: nil)
//                player = AVPlayer(url: URL(fileURLWithPath: path!))
//                player!.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
//                let playerLayer = AVPlayerLayer(player: player)
//                playerLayer.frame = self.view.frame
//                playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//                self.view.layer.insertSublayer(playerLayer, at: 0)
//                NotificationCenter.default.addObserver(self, selector: #selector(self.playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player!.currentItem)
//                player!.seek(to: CMTime.zero)
//                player!.play()
//                self.player?.isMuted = true
//                player!.seek(to: CMTime.zero)
                
            }
        }
        
        self.locationManager.stopUpdatingLocation()
        
    }
}
