//
//  BaseVC.swift
//  Movies
//
//  Created by Sulfah on 30/12/2021.
//

import Foundation

class BaseVC: UIViewController{
    var topView:UIView!
    var topTitle:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        topTitle = "HOLA"
        navigationController?.navigationBar.isHidden = true
        topView = UIView(frame: .zero)
        self.view.addSubview(topView)
        configureNavigation()
    }
    
    func configureNavigation(){
        let title = UILabel(frame: .zero)
        topView.addSubview(title)
        
        configureTopView()
        configureTopTitle(withLable: title)
    }
    private func configureTopTitle(withLable label:UILabel){
        
        label.text = topTitle
        label.textColor = .cornGreen
        label.textAlignment = .center
        guard let customFont = UIFont(name: "Poppins-Regular", size: 24) else {
            fatalError("""
                Failed to load the "Poppins-Regular" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        label.font = UIFontMetrics.default.scaledFont(for: customFont)
        label.adjustsFontForContentSizeCategory = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: 0),
            label.centerXAnchor.constraint(equalTo: topView.centerXAnchor, constant: 0),
            label.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    func configureTopView(){
        guard let navigationArea = navigationController?.navigationBar else {return}
        topView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            topView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            topView.heightAnchor.constraint(equalToConstant: navigationArea.frame.height)
        ])
    }
}
