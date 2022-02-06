//
//  CollectionFooter.swift
//  Movies
//
//  Created by Sulfah on 21/11/2021.
//

import UIKit

class CollectionFooter: UICollectionReusableView {
    static let id = "CollectionFooter_reusable_Identifier"
    
    private var footerView: UIView!
    private let indicator = UIActivityIndicatorView()
    
    override var bounds: CGRect{
        didSet{
            indicator.layoutIfNeeded()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        footerView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 50))
        addSubview(footerView)
        addSubview(indicator)
        
        indicator.color = .white
        
        footerView.addSubview(indicator)
        
    }
    required init?(coder: NSCoder) {
        fatalError("unable to create footer")
    }
    
    
    func startAnimating(){
        indicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else {return}
            self.indicator.stopAnimating()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        footerView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 50))
        indicator.center = footerView.center
    }
    
}
