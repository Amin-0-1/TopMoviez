//
//  BadgeSuplmentary.swift
//  Movies
//
//  Created by Sulfah on 17/11/2021.
//

import UIKit

class BadgeSuplmentary: UICollectionReusableView {
        
    static let id = "BadgeSuplmentary_reusable_Identifier"
    private let label = BadgeSwift()
    
    var date:String!{
        didSet{
            label.text = "\(self.date!)   "
            label.sizeToFit()
            
            
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.insets = CGSize(width: 0, height: 0)
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        label.textColor = .cornGreen
        label.badgeColor = .background
        
        label.shadowOpacityBadge = 1
        label.shadowOffsetBadge = CGSize(width: 0, height: 0)
        label.shadowRadiusBadge = 2
        label.shadowColorBadge = UIColor.white
        label.layer.masksToBounds = true
        label.clipsToBounds = false
        label.cornerRadius = 8
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("unabel to init reusable view")
    }
}
