//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel?)->WeatherModel {
        print("llego al delegate")
        print(weather!)
        return weather!
    }
    func didFailedWithError(error:Error){
        print(error)
    }

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    var weatherManager = WeatherManager()
    
 
    @IBOutlet weak var searchTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
//        con la linea de abajo le decimos a iOS que el control vuelva al controller, luego del keyboard, o sea que responda a este controller
//        el control en el textfield le dice heyy viewcontroller, por ej, el usuario empezo a teclear
        searchTextField.delegate = self
    }


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

