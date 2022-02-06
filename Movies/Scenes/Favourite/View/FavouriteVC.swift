//
//  FavouriteVC.swift
//  Movies
//
//  Created by Sulfah on 29/12/2021.
//

import UIKit

class FavouriteVC: UIViewController{
        
    @IBOutlet weak private var uiTitle: UILabel!
    @IBOutlet weak var uiTable: UITableView!
    
    var presenter:FavouritePresenterToViewProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiTitle.textColor = .cornGreen
        view.backgroundColor = .background
        configureBackBtn()
        presenter.onScreenAppeared()
        configureTableView()
        
    }
    private func configureBackBtn(){
        let back = UIButton(frame: .zero)
        back.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
    }
    private func configureTableView(){
        uiTable.delegate = self
        uiTable.dataSource = self
        uiTable.backgroundColor = .clear
    
        uiTable.register(UINib(nibName: "FavouriteCell", bundle: nil), forCellReuseIdentifier: FavouriteCell.reusableId)
    }
    @IBAction func backBtnPressed(_ sender: UIButton) {
        presenter.onBackButtonPressed()
     }
}

extension FavouriteVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getFavsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteCell.reusableId, for: indexPath) as? FavouriteCell else{fatalError("unable to dequeue")}
                cell.configureCell(withModel: presenter.getModel(forIndex: indexPath.row))
        return cell
    }
}
extension FavouriteVC: FavouriteViewToPresenter{
    func onFinishFetching() {
        uiTable.reloadData()
    }
}
