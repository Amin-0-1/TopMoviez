//
//  SideMenu.swift
//  Movies
//
//  Created by Amin on 16/06/2022.
//

import UIKit

class SideMenuVC: UIViewController {
    var presenter:SideMenuPresenter!
    @IBOutlet weak var uiView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
        
    }
}

