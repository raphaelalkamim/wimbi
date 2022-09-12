//
//  CategoryViewCell.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 12/09/22.
//

import Foundation
import UIKit

class CategoryViewCell: UICollectionViewCell {
    var title: UILabel = {
        let title = UILabel()
        
        return title
    }()
    
    var subtitle: UILabel = {
        let subtitle = UILabel()
        
        return subtitle
    }()
    
    var icon: UIImage = {
        let icon = UIImage()
        
        return icon
    }()
}
