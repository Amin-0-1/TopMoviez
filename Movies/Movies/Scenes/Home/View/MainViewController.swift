//
//  ViewController.swift
//  Movies
//
//  Created by Sulfah on 08/11/2021.
//

import UIKit
import Moya
import Toast
import Lottie

class MainViewController: BaseVC {

//    var topView: UIView!
    
    var presenter: MainPresenterToView!
    var collection: UICollectionView!
    var snapshot:NSDiffableDataSourceSnapshot<Sections,Movie>!
    
    
    var segment: HMSegmentedControl!
    
    var footer: CollectionFooter!
    var isPaginating: Bool! = false
        
    private var favBtn :UIButton!
    private let animationView = AnimationView(name: "not-found")
    let searchBar = UISearchBar(frame: .zero)
    private let searchBtn = UIButton(frame: .zero)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        
        configureFavBtn()
        configureSearchBtn()
        self.configureCollection()
        self.configureDatasource()
        configureSearchBar()
        configureSegments()
        configureAnimation()
        startPoint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    func startPoint(){
        presenter.onStartPoint()
    }
    
    private func configureSearchBtn(){
        
        searchBtn.setImage(UIImage(systemName: "magnifyingglass.circle.fill"), for: .normal)
        searchBtn.setImage(UIImage(systemName: "xmark.circle.fill"), for: .selected)
        
        searchBtn.setPreferredSymbolConfiguration(.init(pointSize: 25), forImageIn: .normal)
        searchBtn.tintColor = .cornGreen
        topView.addSubview(searchBtn)
        searchBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBtn.trailingAnchor.constraint(equalTo: favBtn.leadingAnchor, constant: 0),
            searchBtn.centerYAnchor.constraint(equalTo: topView.centerYAnchor)
        ])
        searchBtn.addTarget(self, action: #selector(searchBtnSelector), for: .touchUpInside)
    }
    @objc func searchBtnSelector(){
        presenter.onSearch()
    }
    private func configureSearchBar(){
        searchBar.isTranslucent = true
        searchBar.barTintColor = .background
        searchBar.tintColor = .cornGreen
        searchBar.searchTextField.textColor = .white
        searchBar.placeholder = "Search for a movie..."
        searchBar.delegate = self
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.isHidden = true
        view.addSubview(searchBar)
        searchBar.searchTextField.text = ""
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collection.topAnchor.constraint(equalTo: searchBar.bottomAnchor)
        ])
        
    }
    private func configureMenuBtn(){
        
        let menuBtn = UIButton(frame: .zero)
        menuBtn.setImage(UIImage(systemName: "line.3.horizontal.circle.fill"), for: .normal)
        menuBtn.setPreferredSymbolConfiguration(.init(pointSize: 25), forImageIn: .normal)
        searchBtn.tintColor = .clear
        menuBtn.addTarget(self, action: #selector(menuBtnSelector), for: .touchUpInside)
        topView.addSubview(menuBtn)
        menuBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuBtn.leadingAnchor.constraint(equalTo: topView.trailingAnchor,constant: 20),
            menuBtn.centerYAnchor.constraint(equalTo: topView.centerYAnchor)
        ])
    }
    
    @objc private func menuBtnSelector(){
        presenter.menuButtonPressed()
    }
    
    private func configureFavBtn(){
        favBtn = UIButton()
        favBtn.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
        favBtn.tintColor = .systemRed
        favBtn.setPreferredSymbolConfiguration(.init(pointSize: 25), forImageIn: .normal)
        topView.addSubview(favBtn)
        favBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            favBtn.trailingAnchor.constraint(equalTo: topView.trailingAnchor,constant: -8),
            favBtn.bottomAnchor.constraint(equalTo: topView.bottomAnchor,constant: 8),
            favBtn.centerYAnchor.constraint(equalTo: topView.centerYAnchor)
        ])
        favBtn.addTarget(self, action: #selector(favBtnSelector), for: .touchUpInside)
    }
    

    
    @objc private func favBtnSelector(){
        presenter.favButtonPressed()
    }
    
    func configureSegments(){
     
        segment = HMSegmentedControl(sectionTitles: presenter.mainTitles)
        
        segment.addTarget(self, action: #selector(segmentedControlChangedValue), for: .valueChanged)
        segment.backgroundColor = .clear
        segment.type = .text
        segment.selectionIndicatorColor = .cornGreen
        segment.segmentWidthStyle = .dynamic
        segment.selectionIndicatorLocation = .bottom
        guard let selected = UIFont(name: "Poppins-Bold", size: 14) else {fatalError("font doesn't exist")}
        guard let non = UIFont(name: "Poppins-Regular", size: 14) else {fatalError("font doesn't exist")}
        
        segment.selectedTitleTextAttributes = [NSAttributedString.Key.font: selected,NSAttributedString.Key.foregroundColor:UIColor.white]
        segment.titleTextAttributes = [NSAttributedString.Key.font: non,NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        segment.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segment)
        
        NSLayoutConstraint.activate([
            segment.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            segment.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            segment.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 8),
            segment.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func segmentedControlChangedValue(segmentedcontrol:HMSegmentedControl){
        presenter.fetch(withSelectedIndex: Int(segmentedcontrol.selectedSegmentIndex), paging: false)
    }
    
    private func configureAnimation(){
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 2
    }
    private func stopAnimating(){
        self.animationView.stop()
        self.animationView.removeFromSuperview()
    }
    
    private func animate(){
        self.view.addSubview(animationView)
        let height = searchBar.frame.size.height + 12
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            animationView.topAnchor.constraint(equalTo: topView.bottomAnchor,constant: height)
        ])
        animationView.play()
    }
}

extension MainViewController: MainViewToPresenter{
    func onEmptySearch() {
        animate()
    }
    
    func onFinishSearching() {
        stopAnimating()
        collection.reloadData()
    }
    
    func onSearching() {
//        showSearchBar()
        searchBar.isHidden = false
        searchBtn.isSelected = true
        self.segment.isHidden = true
        animate()
        collection.transform = CGAffineTransform(scaleX: 1, y: 1)
        UIView.transition(with: self.view, duration: 0.25, options: [.curveLinear], animations: {
            self.collection.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        }, completion: {_ in
            self.collection.removeFromSuperview()
            self.configureSearchCollection()
        })
        
        searchBar.transform = CGAffineTransform(scaleX: 1, y: 0.1)
        
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseIn) {
            self.searchBar.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.searchBar.isHidden = false
        }
    }
    
    func dismissSearching() {
        searchBtn.isSelected = false
        searchBar.isHidden = true
        searchBar.searchTextField.text = ""
        stopAnimating()
        collection.transform = CGAffineTransform(scaleX: 1, y: 1)
        UIView.transition(with: self.view, duration: 0.25, options: [.curveLinear]) {
            self.collection.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            
        } completion: { _ in
            self.collection.removeFromSuperview()
            self.configureCollection()
            self.configureDatasource()
            self.startPoint()
        }

        
        segment.transform = CGAffineTransform(scaleX: 0.1, y: 1)
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseIn) {
            self.segment.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.segment.isHidden = false
        } completion: { _ in
            self.segment.transform = .identity
        }
    }
    
    
    func onFinishFetchingUpcoming(withData: [Movie]) {
        snapshot.sectionIdentifiers.forEach {
            if $0 == .upcoming {
                snapshot.deleteSections([$0])
            }
            
        }
        snapshot.appendSections([.upcoming])
        snapshot.appendItems(withData,toSection: .upcoming)
//        presenter.datasource.applySnapshotUsingReloadData(snapshot, completion: nil)
        presenter.datasource.apply(snapshot,animatingDifferences: true)

        collection.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
    }
    func onFinishFetching(withData: [Movie]) {
        stopAnimating()
        guard let selected = Sections(rawValue: Int(segment.selectedSegmentIndex) + 1) else {fatalError("unable to get section with index \(segment.selectedSegmentIndex)")}
        
        snapshot.sectionIdentifiers.forEach { section in
            if section != .upcoming {
                snapshot.deleteSections([section])
            }
        }
        snapshot.appendSections([selected])
        snapshot.appendItems(withData,toSection: selected)
        presenter.datasource.applySnapshotUsingReloadData(snapshot, completion: nil)
//        presenter.datasource.apply(snapshot,animatingDifferences: true)
        collection.refreshControl?.endRefreshing()
        collection.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
    }
    
    func onFinishFetchingPage(withData page: [Movie]) {
        guard let selected = Sections(rawValue: Int(segment.selectedSegmentIndex) + 1) else {fatalError("unable to get section with index \(segment.selectedSegmentIndex)")}
        
        snapshot.appendItems(page, toSection: selected)
        presenter.datasource.apply(snapshot,animatingDifferences: true)
    }
    
    func paginate(status: Bool) {
        isPaginating = status
    }
}
