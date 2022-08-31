//
//  FavouriteVC.swift
//  Movies
//
//  Created by Sulfah on 29/12/2021.
//

import UIKit
import Lottie
class FavouriteVC: UIViewController,BaseView{
    
    enum CollectionViewMode{
        case View
        case Selection
    }
    @IBOutlet weak var uiTopView: UIView!
    @IBOutlet weak var uiBackBtn: UIButton!
    @IBOutlet weak var uiCollectionView: UICollectionView!
    @IBOutlet weak private var uiTitle: UILabel!
    @IBOutlet weak var animationView: AnimationView!
    private var uiStarBtn: UIButton!
    private var uiDeleteBtn: UIButton!
    private var mode:CollectionViewMode! {
        
        didSet{
            switch mode {
            case .View:
                uiCollectionView.allowsMultipleSelection = false
            case .Selection:
                uiCollectionView.allowsMultipleSelection = true
            case .none:
                break
            }
        }
    }
    
    var presenter:FavouritePresenterToViewProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mode = .View
        uiTitle.textColor = .cornGreen
        view.backgroundColor = .background
        configureBackBtn()
        configureTableView()
        configureAnimation()
        configureStarBtn()
        configureDeleteBtn()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        presenter.onScreenAppeared()
    }
    
    private func configureStarBtn(){
        uiStarBtn = UIButton()
        uiStarBtn.tintColor = .cornGreen
        uiStarBtn.setImage(UIImage(systemName: "star.circle.fill"), for: .normal)
        uiStarBtn.setImage(UIImage(systemName: "xmark.circle.fill"), for: .selected)
        uiStarBtn.setPreferredSymbolConfiguration(.init(pointSize: 25), forImageIn: .normal)
        uiStarBtn.translatesAutoresizingMaskIntoConstraints = false
        uiTopView.addSubview(uiStarBtn)
        NSLayoutConstraint.activate([
            uiStarBtn.trailingAnchor.constraint(equalTo: uiTopView.trailingAnchor,constant: -8),
            uiStarBtn.bottomAnchor.constraint(equalTo: uiTopView.bottomAnchor,constant: 8),
            uiStarBtn.centerYAnchor.constraint(equalTo: uiBackBtn.centerYAnchor)
        ])
        uiStarBtn.addTarget(self, action: #selector(uiStarBtnPressed), for: .touchUpInside)
    }
    @objc func uiStarBtnPressed() {
        uiStarBtn.isSelected = !uiStarBtn.isSelected
        if uiStarBtn.isSelected{
            mode = .Selection
            showDeleteBtn()
        }else{
            mode = .View
            hideDeleteBtn()
            presenter.deselectAll()
        }
    }
    private func configureDeleteBtn(){
        uiDeleteBtn = UIButton()
        uiDeleteBtn.tintColor = .red
        uiDeleteBtn.setImage(UIImage(systemName: "trash.circle"), for: .normal)
        uiDeleteBtn.setPreferredSymbolConfiguration(.init(pointSize: 25), forImageIn: .normal)
        uiDeleteBtn.translatesAutoresizingMaskIntoConstraints = false
        self.uiTopView.addSubview(self.uiDeleteBtn)
        NSLayoutConstraint.activate([
            uiDeleteBtn.trailingAnchor.constraint(equalTo: uiStarBtn.leadingAnchor,constant: 0),
            uiDeleteBtn.bottomAnchor.constraint(equalTo: uiTopView.bottomAnchor),
            uiDeleteBtn.centerYAnchor.constraint(equalTo: uiStarBtn.centerYAnchor)
        ])
        uiDeleteBtn.addTarget(self, action: #selector(deleteSelector(_:)), for: .touchUpInside)
        uiDeleteBtn.isEnabled = false
        uiDeleteBtn.isHidden = true
        
    }
    @objc private func deleteSelector(_ sender:UIButton){

        self.presenter.onUserWantDelete()
    }
    private func showDeleteBtn(){
        uiDeleteBtn.isHidden = false
        uiDeleteBtn.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: []) {
            
            self.uiDeleteBtn.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    private func hideDeleteBtn(){
        
        uiDeleteBtn.transform = CGAffineTransform(scaleX: 1, y: 1)
        UIView.transition(with: view, duration: 0.5, options: []) {
            self.uiDeleteBtn.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        } completion: { _ in
            self.uiDeleteBtn.isHidden = true
        }
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: []) {
            
            
        }
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
        switch mode{
        case .View:
            collectionView.deselectItem(at: indexPath, animated: true)
            presenter.onUserSelectItem(atIndex:indexPath.item)
        case .Selection:
            presenter.onUserSelectMultible(withIndex: indexPath.item)
            return
        case .none:
            break
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        presenter.onUserDeselect(index: indexPath.item)
    }
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        switch mode{
        case .View:
            return configureContextMenu(index:indexPath)
        case .Selection:
            return nil
        case .none:
            break
        }
        return nil
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let animationDuration: Double = 1.0
        cell.alpha = 0.1
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: animationDuration, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: [], animations: {
            cell.alpha = 1
            cell.transform = .identity
        })
        
        
        
        
    }
    private func configureContextMenu(index:IndexPath)->UIContextMenuConfiguration{
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let deleteAction = UIAction(title: "Unlike", image: UIImage(systemName: "star"), attributes: .destructive) { _ in
                self.presenter.onUserWantDelete(index:index.item)
                self.uiCollectionView.performBatchUpdates {
                    self.uiCollectionView.deleteItems(at: [index])
                } completion: {  _ in}
            }
            
            let open = UIAction(title: "Open", image: nil) { _ in
                self.presenter.onUserSelectItem(atIndex: index.item)
            }
            return UIMenu(title: "", image: nil, identifier: .view, children: [open,deleteAction])
        }
        return context
    }
}
extension FavouriteVC: FavouriteViewToPresenter{
    func deselectItemsFromView(withIndeces indeces: [Int]) {
        indeces.forEach { index in
            let path = IndexPath(item: index, section: 0)
            self.uiCollectionView.deselectItem(at: path, animated: true)
        }
    }
    
    func removeItemsFromView(withIndeces: [Int]) {
        let indexPathes = withIndeces.map{IndexPath(item: $0, section: 0)}
        self.uiCollectionView.deleteItems(at: indexPathes)
        
    }
    
    func onChangingIndecesCount(_ count: Int) {
        uiDeleteBtn.isEnabled = count > 0 ? true : false
    }
    
    func onEmptyFavourites() {
        uiCollectionView.isHidden = true
        animationView.isHidden = false
        animationView.play()
    }
    
    func onFinishFetching() {
        
        if presenter.getFavsCount() > 0{
            uiCollectionView.isHidden = false
            animationView.stop()
            animationView.isHidden = true
            uiCollectionView.reloadData()
        }else{
            uiCollectionView.isHidden = true
            animationView.isHidden = false
        }
    }
}
