//
//  AnimateUIImageClick.swift
//  Movies
//
//  Created by Sulfah on 10/03/2022.
//

import Foundation
extension UIImageView{
    func animateClick() {

        UIView.animate(withDuration: 0.3,
            animations: {
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },
            completion: { _ in
                UIView.animate(withDuration: 0.6) {
                    self.transform = CGAffineTransform.identity
                }
            })
    }
}
