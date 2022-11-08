//
//  DetailTableViewCell.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 26/10/22.
//

import Foundation
import UIKit
import SnapKit

class DetailTableViewCell: UITableViewCell {
    static let identifier = "detailTableCell"
    
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = designSystem.palette.backgroundCell
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    lazy var detailText: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .backgroundCell
        textView.layer.masksToBounds = true
        textView.keyboardType = .default
        textView.returnKeyType = UIReturnKeyType.done
        textView.isUserInteractionEnabled = true
        textView.delegate = self
        textView.font = UIFont(name: "Avenir-Roman", size: 17)
        textView.adjustsFontForContentSizeCategory = true
        return textView
    }()
    
}

extension DetailTableViewCell {
    func setup() {
        self.backgroundColor = .backgroundCell
        contentView.addSubview(detailText)
        setupConstraints()
    }
    
    func setupConstraints() {
        detailText.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.mediumPositive)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.mediumPositive)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
}
extension DetailTableViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= 300
    }
}
