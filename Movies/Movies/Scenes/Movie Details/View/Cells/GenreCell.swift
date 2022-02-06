//
//  GenreCell.swift
//  Movies
//
//  Created by Sulfah on 29/11/2021.
//

import UIKit

class GenreCell: UICollectionViewCell {

    static let id = "GenreCell_ReusableID"
    @IBOutlet private weak var uiLabel: UILabel!
    
    override var bounds: CGRect{
        didSet{
            layoutIfNeeded()
        }
    }
    
    func configureCell(withText text:String){
        self.uiLabel.text = "\(text)    "
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        uiLabel.textColor = .white
        uiLabel.layer.borderColor = UIColor.black.cgColor
        uiLabel.layer.masksToBounds = true
        uiLabel.layer.borderWidth = 0.5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        uiLabel.sizeToFit()
        uiLabel.textColor = .black
        uiLabel.backgroundColor = .cornGreen
        uiLabel.layer.cornerRadius = uiLabel.bounds.height / 2
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame
        frame.size.width = ceil(size.width)
        layoutAttributes.frame = frame
        return layoutAttributes
    }
}
