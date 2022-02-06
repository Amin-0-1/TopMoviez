//
//  FavouriteCell.swift
//  Movies
//
//  Created by Sulfah on 03/01/2022.
//

import UIKit

class FavouriteCell: UITableViewCell {
    static let reusableId = "favouriteCell"
    @IBOutlet private weak var uiImage: UIImageView!
    @IBOutlet weak var uiLabel: UILabel!
    
    func configureCell(withModel model:FavouriteMovie){
        uiLabel.text = "\(model.id)"
        uiImage.image = UIImage(systemName: "square.and.arrow.up.fill")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
