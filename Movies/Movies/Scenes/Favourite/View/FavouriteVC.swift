//
//  FavouriteVC.swift
//  Movies
//
//  Created by Sulfah on 29/12/2021.
//

import UIKit

class FavouriteVC: UIViewController,BaseView{
        
    @IBOutlet weak var uiCollectionView: UICollectionView!
    @IBOutlet weak private var uiTitle: UILabel!
    
    
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
        uiCollectionView.register(UINib(nibName: "FavouriteCell", bundle: nil), forCellWithReuseIdentifier: FavouriteCell.reusableID)
        uiCollectionView.delegate = self
        uiCollectionView.dataSource = self
    }
    @IBAction func backBtnPressed(_ sender: UIButton) {
        presenter.onBackButtonPressed()
     }
}

//extension FavouriteVC: UITableViewDelegate,UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return presenter.getFavsCount()
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteCell.reusableId, for: indexPath) as? FavouriteCell else{fatalError("unable to dequeue")}
//                cell.configureCell(withModel: presenter.getModel(forIndex: indexPath.row))
//        return cell
//    }
//}
extension FavouriteVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getFavsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavouriteCell.reusableID, for: indexPath) as? FavouriteCell else {fatalError("unable to dequeu")}
        cell.configureCell(withModel: presenter.getModel(forIndex: indexPath.item))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2) - 15, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.onUserSelectItem(atIndex:indexPath.item)
    }
}
extension FavouriteVC: FavouriteViewToPresenter{
    func onFinishFetching() {
        uiCollectionView.reloadData()
    }
}
