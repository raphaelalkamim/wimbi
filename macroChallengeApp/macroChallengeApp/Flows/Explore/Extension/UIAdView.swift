//
//  RoadmapExploreCollectionViewCell.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 23/09/22.
//

import Foundation
import UIKit
import GoogleMobileAds

class UIAdViewCell: UICollectionViewCell {
    static let identifier = "adviewcell"
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var adView: GADNativeAdView = {
        let adView = GADNativeAdView()
        return adView
    }()
    
    lazy var headline: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var body: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var advertiser: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var icon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
}

extension UIAdViewCell {
    func setup() {
        self.backgroundColor = .backgroundCell
        self.layer.cornerRadius = 16
        contentView.addSubview(adView)
        adView.addSubview(headline)
        adView.addSubview(body)
        adView.addSubview(advertiser)
        adView.addSubview(icon)

        setupConstraints()
    }
    
    func setupConstraints() {
        adView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        headline.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        body.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(headline.snp.top).inset(20)
        }
        
        advertiser.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(headline.snp.top).offset(20)
        }
        
        icon.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(headline.snp.top).offset(50)
            make.width.height.equalTo(50)
        }
    }
}
