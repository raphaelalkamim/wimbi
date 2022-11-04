//
//  ImagePickerButton.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 04/11/22.
//

import Foundation
import SnapKit
import UIKit

class ImagePickerButton: UIButton {
    var category: String = ""
    lazy var addImageIcon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "photo.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        img.tintColor = .backgroundCell
        return img
    }()
    
    init(category: String) {
        super.init(frame: .zero)
        self.category = category
        self.setBackgroundImage(UIImage(named: "button\(self.category)"), for: .normal)
        self.addSubview(addImageIcon)
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupConstraints() {
        addImageIcon.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
    func setupBackgroundImage(category: String) {
        self.setBackgroundImage(UIImage(named: "button\(category)"), for: .normal)
    }
    func setImageById(imageId: String) {
        let path = imageId
        let imageNew = UIImage(contentsOfFile: SaveImagecontroller.getFilePath(fileName: path))
        self.setBackgroundImage(imageNew, for: .normal)
    }
}
