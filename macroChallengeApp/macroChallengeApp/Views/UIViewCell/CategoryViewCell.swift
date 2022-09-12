//
//  CategoryViewCell.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 12/09/22.
//

import Foundation
import UIKit
import SnapKit

class CategoryViewCell: UICollectionViewCell {
    static let identifier = "categoryCell"
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var title: UILabel = {
        let title = UILabel()
        title.backgroundColor = .orange
        return title
    }()
    
    private var subtitle: UILabel = {
        let subtitle = UILabel()
        subtitle.backgroundColor = .yellow
        return subtitle
    }()
    
    private var icon: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.backgroundColor = .purple
        return icon
    }()
}

extension CategoryViewCell {
    func setup() {
        self.addSubview(title)
        self.addSubview(subtitle)
        self.addSubview(icon)
        setupConstraints()
    }
    
    func setupConstraints() {
        title.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalTo(icon.snp.leading).inset(-10)
            make.top.equalToSuperview().inset(10)
            make.bottom.equalTo(subtitle.snp.top)
        }
        
        subtitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalTo(icon.snp.leading).inset(-10)
            make.top.equalTo(title.snp.bottom).inset(10)
            make.bottom.equalToSuperview().inset(-10)
        }
        
        icon.snp.makeConstraints { make in
            make.leading.equalTo(title.snp.trailing)
            make.trailing.equalToSuperview().inset(-10)
            make.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(-10)
        }
    }
    
    func setCell(title: String, subtitle: String, icon: String) {
        self.title.text = title
        self.subtitle.text = subtitle
        self.icon.image = UIImage(named: icon)
    }
}
