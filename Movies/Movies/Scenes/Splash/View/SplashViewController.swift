//
//  SplashViewController.swift
//  Movies
//
//  Created by Sulfah on 07/12/2021.
//

import UIKit
import Lottie

class SplashViewController: UIViewController,SplashViewProtocol {
    var presenter: SplashPresenterToView!
    
    @IBOutlet weak var animationView: AnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 2
        animationView.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.3) { [weak self] in
            guard let self = self else {return}
            self.presenter.onFinishedAnimation()
            self.animationView.stop()
        }
    }
}
