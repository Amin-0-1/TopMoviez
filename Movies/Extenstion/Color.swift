//
//  Color Extensions.swift
//  Movies
//
//  Created by Sulfah on 15/11/2021.
//

import Foundation
import UIKit
import Toast

extension UIColor{
    static var cornGreen : UIColor{
        return UIColor(displayP3Red: 46/255.0, green: 204/255, blue: 113/255.0, alpha: 1)
    }
    static var cornflowerBlue: UIColor {
        return UIColor(displayP3Red: 100.0 / 255.0, green: 149.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0)
    }
    static var background: UIColor{
        return UIColor(displayP3Red: 44/255.0, green: 62/255.0, blue: 80/255.0, alpha: 1)
    }
    
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
}
