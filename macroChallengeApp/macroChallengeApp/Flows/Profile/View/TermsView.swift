//
//  TermsView.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 20/09/22.
//

import Foundation
import UIKit
import SnapKit

class TermsView: UIView {
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var textView: UITextView = {
        let text = UITextView()
        text.text = "Information Collection And Use \n\nWhile using our Service, we may ask you to provide us with certain personally identifiable information that can be used to contact or identify you. Personally identifiable information may include, but is not limited to only your name.\n\nLog Data\n\nWe collect information that your browser sends whenever you visit our Service (”Log Data”). This Log Data may include information such as your computer's Internet Protocol (”IP”) address, browser type, browser version, the pages of our Service that you visit, the time and date of your visit, the time spent on those pages and other statistics.\n\nService Providers\n\nWe may employ third party companies and individuals to facilitate our Service, to provide the Service on our behalf, to perform Service-related services or to assist us in analyzing how our Service is used. These third parties have access to your Personal Information only to perform these tasks on our behalf and are obligated not to disclose or use it for any other purpose.\n\nSecurity\n\nThe security of your Personal Information is important to us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your Personal Information, we cannot guarantee its absolute security.\n\nLinks To Other Sites\n\nOur Service may contain links to other sites that are not operated by us. If you click on a third party link, you will be directed to that third party's site. We strongly advise you to review the Privacy Policy of every site you visit.We have no control over, and assume no responsibility for the content, privacy policies or practices of any third party sites or services.\n\nChanges To This Privacy Policy\n\nWe may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page. You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.\n\nContact Us\n\nIf you have any questions about this Privacy Policy, please contact us."
        text.textColor = .titlePrimary
        text.font = designSystem.text.body.font
        text.backgroundColor = .backgroundPrimary
        text.layer.cornerRadius = 16
        text.isScrollEnabled = false
        return text
    }()
    
    func setup() {
        self.backgroundColor = designSystem.palette.backgroundPrimary
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(textView)
        setupConstraints()
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.left.right.equalTo(self)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.bottom.equalTo(textView.snp.bottom)
            make.left.right.equalTo(self)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.topMargin)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xLargePositive)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
            make.bottom.equalTo(scrollView.snp.bottom).inset(designSystem.spacing.largePositive)
            make.height.equalTo(1650)
        }
    }
}
