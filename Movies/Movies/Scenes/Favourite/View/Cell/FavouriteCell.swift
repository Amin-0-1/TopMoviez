//
//  FavouriteCell.swift
//  Movies
//
//  Created by Sulfah on 15/03/2022.
//

import UIKit
import SDWebImage

class FavouriteCell: UICollectionViewCell {
    static let reusableID = "FavouriteCellID"
    @IBOutlet weak private var uiImage: UIImageView!
    @IBOutlet weak private var uiSelection: UIButton!
    
    
    override var isSelected: Bool{
        willSet{
            if newValue == true{
                uiSelection.isHidden = false
                self.isHighlighted = true
                uiImage.alpha = 0.5
            }else{
                uiSelection.isHidden = true
                self.isHighlighted = false
                uiImage.alpha = 1
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear

    }
    func configureCell(withModel model:Movie){
        guard let posterPath = model.posterPath , let url = URL(string: posterPath) else { return }
        uiImage.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        uiImage.sd_imageIndicator?.startAnimatingIndicator()
        uiImage.sd_setImage(with: url) { [weak self] image, error, cache, url in
            guard let self = self else {return}
            self.uiImage.sd_imageIndicator?.stopAnimatingIndicator()
        }
        uiImage.layer.cornerRadius = 12
        uiImage.layer.borderColor = UIColor.black.cgColor
        uiImage.layer.borderWidth = 0.6

    }


}
