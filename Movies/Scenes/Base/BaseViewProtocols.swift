//
//  AnyViewProtocols.swift
//  Movies
//
//  Created by Sulfah on 28/11/2021.
//

import Foundation
import UIKit

protocol BaseView {
    func loading(status:Bool) -> Void
    func showError(error: String) -> Void
}

extension BaseView where Self: UIViewController{
    func loading(status: Bool) {
        switch status{
        case true:
            self.view.makeToastActivity(.center)
            view.disableInteractions()
        case false:

            self.view.hideAllToasts(includeActivity: true, clearQueue: true)
            self.view.enableInteractions()
        }
    }
    
    func showError(error: String) {
        self.view.makeToast(error, duration: 5, position: .bottom, title: nil, image: nil) { didTap in
            print("tapped")
        }
    }
}
