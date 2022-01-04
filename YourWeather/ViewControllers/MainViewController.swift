//
//  MainViewController.swift
//  YourWeather
//
//  Created by Alexander Kovzhut on 02.01.2022.
//

import UIKit
import CoreLocation
import Kingfisher

class MainViewController: UIViewController {
    
    private var photoManager = PhotoNetworkLayer.shared
    private var weatherManager = WeatherNetworkLayer.shared
    private let locationManager = CLLocationManager()
    
    private var backgroundImage = UIImageView()
    private let activityIndicator = UIActivityIndicatorView()

    private let conditionImageView = UIImageView()
    private let temperaturelabel = UILabel()
    private let tempMaxMinlabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private var images = [PhotoData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupNavigationBar()
        setupStyle()
        setupLayout()
        fetchPhotoData()
    }
    
    @objc func userPagePressedButton() {
        print(#function)
    }
    
    @objc func addLocationPressedButton() {
        print(#function)
        let addViewController = AddViewController()
        navigationController?.pushViewController(addViewController, animated: true)
    }
    
    @objc func currentLocationPressedButton() {
        print(#function)
    }
}

extension MainViewController {
    private func setup() {
        weatherManager.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        let userPageButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(userPagePressedButton))
        
        let currentLocationButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(currentLocationPressedButton))
        
        let addLocationButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLocationPressedButton))
                
        titleLabel.text = "London, UK"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = UIColor.white
                
        userPageButtonItem.tintColor = .white
        currentLocationButtonItem.tintColor = .white
        addLocationButtonItem.tintColor = .white
                
        navigationItem.leftBarButtonItem = userPageButtonItem
        navigationItem.rightBarButtonItems = [addLocationButtonItem, currentLocationButtonItem]
        navigationItem.titleView = titleLabel
    }
    
    private func setupStyle() {
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.backgroundColor = .black
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        
        conditionImageView.translatesAutoresizingMaskIntoConstraints = false
        conditionImageView.clipsToBounds = false
        conditionImageView.tintColor = .white
        conditionImageView.layer.shadowColor = UIColor.black.cgColor
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textColor = .white
        descriptionLabel.shadowColor = .black
        tempMaxMinlabel.shadowOffset = CGSize(width: 2, height: 2)
        descriptionLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        
        tempMaxMinlabel.translatesAutoresizingMaskIntoConstraints = false
        tempMaxMinlabel.textColor = .white
        tempMaxMinlabel.shadowColor = .black
        tempMaxMinlabel.shadowOffset = CGSize(width: 2, height: 2)
        tempMaxMinlabel.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        
        
        temperaturelabel.translatesAutoresizingMaskIntoConstraints = false
        temperaturelabel.textColor = .white
        temperaturelabel.shadowColor = .black
        temperaturelabel.shadowOffset = CGSize(width: 2, height: 2)
        temperaturelabel.font = UIFont.systemFont(ofSize: 120, weight: .bold)
    }
    
    private func setupLayout() {
        view.addSubview(backgroundImage)
        backgroundImage.addSubview(activityIndicator)
        backgroundImage.addSubview(conditionImageView)
        backgroundImage.addSubview(descriptionLabel)
        backgroundImage.addSubview(tempMaxMinlabel)
        backgroundImage.addSubview(temperaturelabel)
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: backgroundImage.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: backgroundImage.centerYAnchor),
            
            conditionImageView.bottomAnchor.constraint(equalTo: tempMaxMinlabel.topAnchor, constant: -10),
            conditionImageView.leadingAnchor.constraint(equalTo: backgroundImage.leadingAnchor, constant: 50),
            conditionImageView.heightAnchor.constraint(equalToConstant: 40),
            conditionImageView.widthAnchor.constraint(equalToConstant: 40),
            
            descriptionLabel.bottomAnchor.constraint(equalTo: tempMaxMinlabel.topAnchor, constant: -10),
            descriptionLabel.leadingAnchor.constraint(equalTo: conditionImageView.trailingAnchor, constant: 10),
            
            tempMaxMinlabel.bottomAnchor.constraint(equalTo: temperaturelabel.topAnchor, constant: 15),
            tempMaxMinlabel.leadingAnchor.constraint(equalTo: backgroundImage.leadingAnchor, constant: 50),
            
            temperaturelabel.bottomAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: -100),
            temperaturelabel.leadingAnchor.constraint(equalTo: backgroundImage.leadingAnchor, constant: 50)
            
        ])
    }
    
    private func fetchPhotoData() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        photoManager.fetchData { (result) in
            switch result {
            case .success(let photo):
                self.backgroundImage.kf.setImage(with: URL(string: photo.first?.urls.regular ?? "")) { _ in
                    self.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension MainViewController: WeatherServiceDelegate {
    // Update UI elements
        func didFetchWeather(_ weatherService: WeatherNetworkLayer, _ weather: WeatherModel) {
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.descriptionLabel.text = "\(weather.mainDescription)"
            self.tempMaxMinlabel.text = "↑\(weather.tempMaxString)  ↓\(weather.tempMinString)"
            self.temperaturelabel.text = "\(weather.tempString)º"
        }

        func didFailWithError(_ weatherService: WeatherNetworkLayer, _ error: WeatherServiceError) {
            let message: String

            switch error {
            case .network(statusCode: let statusCode):
                message = "Networking error. Status code: \(statusCode)"
            case .parsing:
                message = "JSON weather data could not be parsed"
            case .general(reason: let reason):
                message = reason
            }
            showErrorAlert(with: message)
        }

        func showErrorAlert(with message: String) {
            let alert = UIAlertController(title: "Error fetching weather", message: message, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            self.present(alert, animated: true, completion: nil)
        }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: latitude, longitude: longitude)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
