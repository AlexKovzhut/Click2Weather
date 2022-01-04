//
//  TableViewCell.swift
//  YourWeather
//
//  Created by Alexander Kovzhut on 04.01.2022.
//

import UIKit

class TableViewCell: UITableViewCell {
    // MARK: - Public properties
    static let identifier = "identifier"
    
    // MARK: - UITableViewCell Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setStyle()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setStyle() {
    }
        
    private func setLayout() {
    }
}
