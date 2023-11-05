//
//  CityCell.swift
//  WeatherForecast
//
//  Created by Абдулла-Бек on 2/11/23.
//

import Foundation
import SnapKit

protocol CityCellDelegate: AnyObject {
    func cityCellDidTap(_ cell: CityCell)
}

class CityCell: UITableViewCell {
    
    weak var delegate: CityCellDelegate?
    
    let cityLabel = UILabel()
    let temperatureLabel = UILabel()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    private func commonInit() {
        
        addSubview(cityLabel)
        cityLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func cellTapped() {
        delegate?.cityCellDidTap(self)
    }
    
    
    func configure(with city: City, with main: Main) {
        cityLabel.text = city.name
        temperatureLabel.text = String(main.temp)
    }
}
