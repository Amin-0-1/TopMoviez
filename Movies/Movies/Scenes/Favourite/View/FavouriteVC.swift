//
//  FavouriteVC.swift
//  Movies
//
//  Created by Sulfah on 29/12/2021.
//

import UIKit
import Lottie
class FavouriteVC: UIViewController,BaseView{
        
    @IBOutlet weak var uiCollectionView: UICollectionView!
    @IBOutlet weak private var uiTitle: UILabel!
    @IBOutlet weak var animationView: AnimationView!
    
    
    var presenter:FavouritePresenterToViewProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiTitle.textColor = .cornGreen
        view.backgroundColor = .background
        configureBackBtn()
        configureTableView()
        configureAnimation()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        presenter.onScreenAppeared()
    }
    
    private func configureAnimation(){
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 2
        animationView.play()
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
        
        if presenter.getFavsCount() > 0{
            uiCollectionView.isHidden = false
            animationView.isHidden = true
        }else{
            uiCollectionView.isHidden = true
            animationView.isHidden = false
        }
        
        uiCollectionView.reloadData()
    }
}
