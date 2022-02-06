//
//  MoviesViewUI.swift
//  Movies
//
//  Created Sulfah on 11/11/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: MoviesViewUI Delegate -
/// MoviesViewUI Delegate
protocol MoviesViewUIDelegate {
    // Send Events to Module View, that will send events to the Presenter; which will send events to the Receiver e.g. Protocol OR Component.
}

// MARK: MoviesViewUI Data Source -
/// MoviesViewUI Data Source
protocol MoviesViewUIDataSource {
    // This will be implemented in the Module View.
    /// Set Object for the UI Component
    func objectFor(ui: MoviesViewUI) -> MoviesEntity
}

class MoviesViewUI: UIView {
    
    var delegate: MoviesViewUIDelegate?
    var dataSource: MoviesViewUIDataSource?
    
    var object : MoviesEntity?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        setupConstraints()
    }
    
    fileprivate func setupUIElements() {
        // arrange subviews
    }
    
    fileprivate func setupConstraints() {
        // add constraints to subviews
    }
    
    /// Reloading the data and update the ui according to the new data
    func reloadData() {
        self.object = dataSource?.objectFor(ui: self)
        // Should update UI
    }
}
