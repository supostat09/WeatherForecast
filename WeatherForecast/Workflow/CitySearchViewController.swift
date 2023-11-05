//
//  CitySearchViewController.swift
//  WeatherForecast
//
//  Created by Абдулла-Бек on 29/10/23.
//

import Foundation
import UIKit

protocol CitySearchDelegate {
    func didSelectCity(_ weatherData: WeatherData)
}

class CitySearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CityCellDelegate {
    
    let apiKey = "5232df7c6b5387abf9b3c46b6b7bbd75"
    var cityLabel: UILabel
    var tempLabel: UILabel
    var cityTextField: UITextField!
    var tableView: UITableView!
    var cities: [String] = []
    var mainData: [Double] = []
    var cityWeatherData: [String: WeatherData] = [:]
    var searchText: String = ""
    var searchButton = UIButton(type: .system)
    var delegate: CitySearchDelegate?
    
    init(cityLabel: UILabel, tempLabel: UILabel, windSpeedLabel: UILabel, cloudAllLabel: UILabel, cityTextField: UITextField, tableView: UITableView, cities: [String], mainData: [Double], delegate: CitySearchDelegate? = nil) {
        self.cityLabel = cityLabel
        self.tempLabel = tempLabel
        self.cityTextField = cityTextField
        self.tableView = tableView
        self.cities = cities
        self.mainData = mainData
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        
    }
    
    func setupUI() {
        
        cityLabel = UILabel()
        view.addSubview(cityLabel)
        cityLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(200)
            make.centerX.equalToSuperview()
        }
        
        tempLabel = UILabel()
        view.addSubview(tempLabel)
        tempLabel.snp.makeConstraints { (make) in
            make.top.equalTo(cityLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        cityTextField = UITextField()
        cityTextField.placeholder = "Введите город"
        cityTextField.borderStyle = .roundedRect
        cityTextField.delegate = self
        view.addSubview(cityTextField)
        cityTextField.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).inset(20)
        }
        
        tableView = UITableView()
        tableView.backgroundColor = .systemGreen
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CityCell.self, forCellReuseIdentifier: "CityCell")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(cityTextField.snp.bottom).offset(10)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        searchButton = UIButton()
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        view.addSubview(searchButton)
        searchButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(cityTextField)
            make.centerX.equalTo(cityTextField.snp.trailing).inset(20)
        }
    }
    
    @objc func searchButtonTapped() {
        performWeatherSearch()
    }
    
    func performWeatherSearch() {
        // Проверьте, что searchText не пустой
        if !searchText.isEmpty {
            searchForWeatherData(forCity: searchText) { [weak self] weatherData in
                if let weatherData = weatherData {
                    self?.updateUI(withWeatherData: weatherData)
                }
            }
        }
    }
    
    func updateUI(withWeatherData weatherData: WeatherData) {
        DispatchQueue.main.async {
            self.cityLabel.text = "City: \(weatherData.name)"
            self.tempLabel.text = "Temperature: \(weatherData.main.temp)°C"
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityCell
        cell.backgroundColor = .systemBackground
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.systemGray.cgColor
        let cityName = cities[indexPath.row]
        let temp = mainData[indexPath.row]
        let city = City(name: cityName)
        let main = Main(temp: temp)
        cell.configure(with: city, with: main)
        cell.delegate = self
        return cell
    }
    
    func cityCellDidTap(_ cell: CityCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let selectedCity = cities[indexPath.row]
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = cities[indexPath.row]
        searchForWeatherData(forCity: selectedCity) { [weak self] weatherData in
            if let weatherData = weatherData {
                self?.delegate?.didSelectCity(weatherData)
                self?.dismiss(animated: true, completion: nil)
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        cityTextField.delegate = self
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        searchText = newText
        return true
    }
    
    func searchForWeatherData(forCity city: String, completion: @escaping (WeatherData?) -> Void) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                let _ = weatherData.name
                
                DispatchQueue.main.async {
                    self?.delegate?.didSelectCity(weatherData)
                    self?.dismiss(animated: true, completion: nil)
                    self?.cities.append(weatherData.name)
                    self?.mainData.append(weatherData.main.temp)
                    self?.tableView.reloadData()
                }
            } catch {
                print("Error decoding response: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}


