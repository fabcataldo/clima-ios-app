//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
 
    @IBOutlet weak var searchTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //le pido al usuario que se necesita autorizacion para utilizar el GPS
        locationManager.requestWhenInUseAuthorization()
     
        //(x)
        locationManager.delegate = self
        
        //locationManager llama a requestLocation, y luego responde al metodo didUpdateNotifications()
        locationManager.requestLocation()

        weatherManager.delegate = self
//        con la linea de abajo le decimos a iOS que el control vuelva al controller, luego del keyboard, o sea que responda a este controller
//        el control en el textfield le dice heyy viewcontroller, por ej, el usuario empezo a teclear
        searchTextField.delegate = self
    }
    
    @IBAction func currentLocationButtonPressed(_ sender: Any) {
        locationManager.requestLocation()
    }
    
}


//MARK: - CLLocationManagerDelegate
//hacemos una extension, que implementa el CLLocationManagerDelegate, y el que sea el delegate, va a recibir los datos de la localizacion obtenida... (x)
extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Got Location Data")
        print(locations)
        
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: long)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
//MARK: - UITextFieldDelegate
//Uso extensiones para separar y limpiar el codigo
extension WeatherViewController: UITextFieldDelegate{
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    //    la func de abajo habilita al delegate, o sea a esta clase, que reciba el evento de que pasa cuando el usuario apreta la tecla return en el cel, que en realidad aca en el proyecto le pusimos la tecla go, que esta en el mismo lugar que el return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
//    "hey, viewcontroller,ya termine de editar... que hago"?
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
    
//    "hey, viewcontroller, el usuario se fue del campo e hice tap en otro lado, que hago?"
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
    func didUpdateWeather(weather: WeatherModel) {
        //pongo el obj DispatchQueue para hacer que la ejecucion de la app atienda al main thread, que es en donde la UI esta "freezada" esperando la respuesta del weather de la API
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    func didFailedWithError(error:Error){
        print(error)
    }
}
