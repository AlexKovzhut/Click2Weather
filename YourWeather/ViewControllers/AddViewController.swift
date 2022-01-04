//
//  AddViewController.swift
//  YourWeather
//
//  Created by Alexander Kovzhut on 04.01.2022.
//

import UIKit

class AddViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let searchTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupNavigationBar()
        setupSearchController()
        setupStyle()
        setupLayout()
    }
}

extension AddViewController {
    private func setup() {
    }
    
    private func setupNavigationBar() {
    }
    
    private func setupSearchController() {
    }
    
    private func setupStyle() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        scrollView.alwaysBounceVertical = true
        scrollView.bounces = true
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        searchTextField.placeholder = "Enter city name"
        searchTextField.textAlignment = .left
        searchTextField.borderStyle = .roundedRect
        searchTextField.backgroundColor = .gray
        searchTextField.textColor = .white
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(searchTextField)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        ])
    }
}
