//
//  WeatherViewController.swift
//  WeatherForecast
//
//  Created by Абдулла-Бек on 17/10/23.
//

import UIKit
import SnapKit

class WeatherViewController: UIViewController, CitySearchDelegate {
    
    var countryLabel: UILabel!
    var cityLabel: UILabel!
    var tempLabel: UILabel!
    var windSpeedLabel: UILabel!
    var cloudAllLabel: UILabel!
    
    let weatherService = WeatherService()
    var selectedCity: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        getWeatherData()
        
    }
    
    func setupUI() {
        countryLabel = UILabel()
        view.addSubview(countryLabel)
        countryLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(200)
            make.centerX.equalToSuperview()
        }
        
        cityLabel = UILabel()
        view.addSubview(cityLabel)
        cityLabel.snp.makeConstraints { (make) in
            make.top.equalTo(countryLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        tempLabel = UILabel()
        view.addSubview(tempLabel)
        tempLabel.snp.makeConstraints { (make) in
            make.top.equalTo(cityLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        windSpeedLabel = UILabel()
        view.addSubview(windSpeedLabel)
        windSpeedLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tempLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        cloudAllLabel = UILabel()
        view.addSubview(cloudAllLabel)
        cloudAllLabel.snp.makeConstraints { (make) in
            make.top.equalTo(windSpeedLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        let searchButton = UIBarButtonItem(title: "Поиск", style: .plain, target: self, action: #selector(openCitySearch))
        navigationItem.rightBarButtonItem = searchButton
    }
    
    @objc func openCitySearch() {
        let cityLabel = UILabel()
        let tempLabel = UILabel()
        let windSpeedLabel = UILabel()
        let cloudAllLabel = UILabel()
        let cityTextField = UITextField()
        let tableView = UITableView()
        let cities: [String] = []
        let mainData: [Double] = []
        let citySearchViewController = CitySearchViewController(cityLabel: cityLabel, tempLabel: tempLabel, windSpeedLabel: windSpeedLabel, cloudAllLabel: cloudAllLabel, cityTextField: cityTextField, tableView: tableView, cities: cities, mainData: mainData, delegate: self)
        citySearchViewController.delegate = self
        navigationController?.pushViewController(citySearchViewController, animated: true)
    }
    
    func didSelectCity(_ weatherData: WeatherData) {
        DispatchQueue.main.async {
            self.countryLabel.text = "Country: \(weatherData.sys.country)"
            self.cityLabel.text = "City: \(weatherData.name)"
            self.tempLabel.text = "Temperature: \(weatherData.main.temp)°C"
            self.windSpeedLabel.text = "Wind Speed: \(weatherData.wind.speed) m/s"
            self.cloudAllLabel.text = "Cloudiness: \(weatherData.clouds.all)%"
        }
    }
    
    func getWeatherData() {
        if let selectedCity = selectedCity {
            weatherService.getWeatherData(forCity: selectedCity) { result in
                switch result {
                case .success(let weatherData):
                    DispatchQueue.main.async {
                        self.countryLabel.text = "Country: \(weatherData.sys.country)"
                        self.cityLabel.text = "City: \(weatherData.name)"
                        self.tempLabel.text = "Temperature: \(weatherData.main.temp)°C"
                        self.windSpeedLabel.text = "Wind Speed: \(weatherData.wind.speed) m/s"
                        self.cloudAllLabel.text = "Cloudiness: \(weatherData.clouds.all)%"
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
}

