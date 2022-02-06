//
//  UpcomingCell.swift
//  Movies
//
//  Created by Sulfah on 16/11/2021.
//

import UIKit
import SDWebImage

class MovieCell: UICollectionViewCell {
    static var id = "Upcoming_cell_identifier"
    @IBOutlet private weak var uiImage: UIImageView!
    @IBOutlet private weak var uiLabel: UILabel!
    
    func configure(withData movie :Movie){
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 8
        uiLabel.numberOfLines = 2
        self.layer.borderWidth = 0.5
        uiLabel.text = movie.title
        guard let font = UIFont(name: "Poppins-Regular", size: 15) else {fatalError("unable to get font")}
        uiLabel.font = UIFontMetrics.default.scaledFont(for: font)
        uiLabel.textColor = .white
        uiImage.contentMode = .scaleAspectFill
        
        guard let posterPath = movie.posterPath , let url = URL(string: posterPath) else { return }
        
        uiImage.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        uiImage.sd_imageIndicator?.startAnimatingIndicator()
        uiImage.sd_setImage(with: url) { [weak self] image, error, cache, url in
            guard let self = self else {return}
            self.uiImage.sd_imageIndicator?.stopAnimatingIndicator()
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
