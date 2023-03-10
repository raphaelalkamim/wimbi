//
//  WeatherView.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 08/03/23.
//

import UIKit
import SnapKit

open class WeatherView: UIView {
    
    // MARK: - Variables
    var designSystem: DesignSystem = DefaultDesignSystem.shared
    
    var actualTemperature: String? {
        didSet {
            weatherTemperature.text = (actualTemperature ?? "--") + "º"
        }
    }
    
    var iconTemperature: UIImage? {
        didSet {
            weatherIcon.image =  iconTemperature
        }
    }
    
    var higherTemperature: String? {
        didSet {
            highTemperatureLabel.text = "↑" + (higherTemperature ?? "--")
        }
    }
    
    var lowerTemperature: String? {
        didSet {
            lowTemperatureLabel.text = "↓" + (lowerTemperature ?? "--")
        }
    }
    
    var rainfallLevel: String? {
        didSet {
            rainLevelLabel.text =  rainfallLevel
        }
    }
    
    // MARK: - Componets
    
    lazy var weatherTemperature: UILabel = {
        let label = UILabel()
        label.textColor = .textPrimary
        label.font = designSystem.text.largeTitle.font
        label.textAlignment = .left
        return label
    }()
    
    lazy var nowLabel: UILabel = {
        let label = UILabel()
        label.stylize(with: designSystem.text.smallCaption)
        label.text = "NOW".localized()
        label.textAlignment = .left
        return label
    }()
    
    lazy var weatherIcon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "WeatherSun")
        return image
    }()
    
    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.stylize(with: designSystem.text.smallCaption)
        label.text = "TEMPERATURE".localized()
        label.textAlignment = .left
        return label
    }()
    
    lazy var lowTemperatureLabel: UILabel = {
        let label = UILabel()
        label.stylize(with: designSystem.text.smallCaption)
        label.text = "10"
        label.textColor = .accent
        label.textAlignment = .left
        return label
    }()
    
    lazy var highTemperatureLabel: UILabel = {
        let label = UILabel()
        label.stylize(with: designSystem.text.smallCaption)
        label.text = "20"
        label.textColor = .yellowMontain
        label.textAlignment = .left
        return label
    }()
    
    lazy var rainfallLabel: UILabel = {
        let label = UILabel()
        label.stylize(with: designSystem.text.smallCaption)
        label.text = "RAINFALL".localized()
        label.textAlignment = .left
        return label
    }()
    
    lazy var rainLevelLabel: UILabel = {
        let label = UILabel()
        label.stylize(with: designSystem.text.smallCaption)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let weatherView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = .weatherBackground
        return view
    }()
    
    
    //MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.setupConstraints()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.addSubview(weatherView)
        
        weatherView.addSubview(weatherTemperature)
        weatherView.addSubview(nowLabel)
        weatherView.addSubview(weatherIcon)
        
        weatherView.addSubview(temperatureLabel)
        weatherView.addSubview(lowTemperatureLabel)
        weatherView.addSubview(highTemperatureLabel)
        
        weatherView.addSubview(rainfallLabel)
        weatherView.addSubview(rainLevelLabel)
    }
    
    func setupConstraints() {
        weatherView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        weatherTemperature.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(28)
            make.leading.equalToSuperview().inset(24)
        }
        
        nowLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherTemperature.snp.bottom)
            make.leading.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(28)
        }
        
        weatherIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(weatherTemperature.snp.trailing).offset(8)
            make.width.height.equalTo(35)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.leading.equalTo(weatherIcon.snp.trailing).offset(24)
        }
        
        highTemperatureLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.trailing.equalToSuperview().inset(28)
        }
        
        
        lowTemperatureLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.trailing.equalTo(highTemperatureLabel.snp.leading).offset(-8)
        }
        
      
        rainfallLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(32)
            make.leading.equalTo(weatherIcon.snp.trailing).offset(28)
        }
        
        rainLevelLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(32)
            make.trailing.equalToSuperview().inset(24)
        }
        
    
    }
}
