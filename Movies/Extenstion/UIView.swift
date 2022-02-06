//
//  UIView.swift
//  Movies
//
//  Created by Sulfah on 15/11/2021.
//

import Foundation
import UIKit


extension UIView{
    func disableInteractions(){
        self.isUserInteractionEnabled = false
    }
    
    func enableInteractions(){
        self.isUserInteractionEnabled = true
    }
}

