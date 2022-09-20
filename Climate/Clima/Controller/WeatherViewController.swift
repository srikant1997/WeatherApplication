//
//  ViewController.swift
//  Clima
//
//  Created by Srikant Das on 01/03/2022
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController{

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var seaarchTextField: UITextField!
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.seaarchTextField.delegate = self
        self.weatherManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        self.locationManager.requestLocation()
        
    }

    @IBAction func searchAction(_ sender: UIButton) {
        self.seaarchTextField.endEditing(true)
    }

    @IBAction func currentLoactionWeather(_ sender: Any) {
        self.locationManager.requestLocation()
    }
}

extension WeatherViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        self.seaarchTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = self.seaarchTextField.text{
            self.weatherManager.fetchWeather(city: city)
        }
        self.seaarchTextField.text = ""
    }
}


extension WeatherViewController:WeatherManagerDelegate{
    func didFail(error: Error) {
        print(error)
    }
    
    func didUpdateWeather(weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
       
    }
}

extension WeatherViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let lattitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            self.weatherManager.fetchWeather(lattitude, longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

