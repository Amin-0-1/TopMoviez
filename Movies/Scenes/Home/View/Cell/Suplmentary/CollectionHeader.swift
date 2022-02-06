//
//  CollectionHeader.swift
//  Movies
//
//  Created by Sulfah on 16/11/2021.
//

import UIKit

class CollectionHeader: UICollectionReusableView {
    static let id = "CollectionHeader_reusable_Identifier"
    
    private var label : UILabel!
    override var bounds: CGRect{
        didSet{
            self.layoutIfNeeded()
        }
    }
    var title:String!{
        didSet{
        
            label.text = "\(title!)     "
            
            label.textAlignment = .center
            label.textColor = .black
            label.backgroundColor = UIColor(white: 0.95, alpha: 1)
            label.clipsToBounds = true
            
            label.layer.cornerRadius = label.bounds.height / 2
            label.sizeToFit()

        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: frame.height))
        addSubview(label)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.sizeToFit()
        label.center = CGPoint(x: frame.midX - (label.intrinsicContentSize.width / 2), y: frame.height/2)
        label.layer.cornerRadius = label.bounds.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
