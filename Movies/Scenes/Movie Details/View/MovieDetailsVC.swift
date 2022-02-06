//
//  MovieDetailsVC.swift
//  Movies
//
//  Created by Sulfah on 28/11/2021.
//

import UIKit
import SDWebImage
import Cosmos


class MovieDetailsVC: UIViewController , DetailsViewProtocol{
    var presenter: DetailsPresenterToView!
    //    private var backBtn: UIButton!
    @IBOutlet weak private var uiTopView: UIView!
    @IBOutlet weak private var uiBackBtn: UIButton!
    @IBOutlet weak private var uiPosterImage: UIImageView!
    @IBOutlet weak private var uiTitle: UILabel!
    @IBOutlet weak private var uiDescription: UILabel!
    @IBOutlet weak private var uiStackView: UIStackView!
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var uiRatingView: CosmosView!
    @IBOutlet weak var uiLike: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        configureNavigationView()
        configureCollection()
        showPoster()
        
        uiRatingView.settings.fillMode = .precise
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.onScreenAppeared()
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        
    }
    
    private func showPoster(){
        guard let posterPath = presenter.posterPath , let url = URL(string: posterPath) else { return }
        uiPosterImage.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        uiPosterImage.sd_imageIndicator?.startAnimatingIndicator()
        uiPosterImage.sd_setImage(with: url) { [weak self] image, error, cache, url in
            guard let self = self else {return}
            self.uiPosterImage.sd_imageIndicator?.stopAnimatingIndicator()
        }
    }
    private func configureNavigationView(){
        
        uiTopView.backgroundColor = .background
        
        guard let navigationArea = navigationController?.navigationBar else {return}
        uiTopView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            uiTopView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            uiTopView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            uiTopView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            uiTopView.heightAnchor.constraint(equalToConstant: navigationArea.frame.height)
        ])
    }
    
    private func configureCollection(){
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        
        
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = CGSize(width: 93, height: 50)
        
        let nib = UINib(nibName: "GenreCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: GenreCell.id)
    }
    
    @IBAction func uiPlayBtn(_ sender: Any) {
        presenter.onPlayingVideo()
//        let vc = VideoVC()
//        present(vc, animated: true)
    }
    @IBAction func uiLikeBtn(_ sender: UIButton) {
        uiLike.transform = CGAffineTransform(scaleX: 2, y: 2)
        

        UIView.animate(withDuration: 1,delay: 0,options: [.curveEaseOut]) {
            self.uiLike.transform = .identity
        }
        self.presenter.toggleLike()
    }
    
}

extension MovieDetailsVC: DetailsViewToPresenter{
    
    func onFinishCheckFavourite() {
        var image:UIImage
        image = self.presenter.isLiked ? UIImage(systemName: "heart.fill")! : UIImage(systemName: "heart")!
        self.uiLike.setImage(image, for: .normal)
    }
    
    
    func playVideo(withObj obj: Video) {
        
        // deep linking opent youtube link
//        guard let deepUrl = obj.deepLinkURL else {return}
//        if UIApplication.shared.canOpenURL(deepUrl){
//            UIApplication.shared.open(deepUrl, options: [:], completionHandler: nil)
//        }else{
//            guard let url = obj.browserURL else {return}
//            UIApplication.shared.open(url)
//        }
        
    }
    
    
    func onFinishFetching(movieDetails details: MovieDetailsAPI) {
        uiTitle.text = details.originalTitle
        uiDescription.text = details.overview
        uiRatingView.rating = details.voteAverage * 5 / 10
        uiRatingView.text = "\(details.voteAverage)"
        uiRatingView.disableInteractions()
        collectionView.reloadData()
    }
}

extension MovieDetailsVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.genresCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCell.id, for: indexPath) as? GenreCell else {fatalError("unable to deques")}
        cell.configureCell(withText: presenter.getGener(withIndex: indexPath.item))
        return cell
    }
    
    
}
