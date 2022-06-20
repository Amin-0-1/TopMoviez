//
//  ViewController.swift
//  Movies
//
//  Created by Sulfah on 08/11/2021.
//

import UIKit
import Moya
import Toast

class MainViewController: BaseVC {

//    var topView: UIView!
    
    var presenter: MainPresenterToView!
    var collection: UICollectionView!
    var snapshot:NSDiffableDataSourceSnapshot<Sections,Movie>!
    
    
    var segment: HMSegmentedControl!
    
    var footer: CollectionFooter!
    var isPaginating: Bool! = false
        
    private var favBtn :UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        
        configureFavBtn()
//        configureMenuBtn()
        
        configureCollection()
        configureDatasource()
        configureSegments()
        startPoint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    func startPoint(){
        presenter.onStartPoint()
    }
    
    private func configureMenuBtn(){
        let menuBtn = UIButton(frame: .zero)
        menuBtn.setImage(UIImage(systemName: "line.3.horizontal.circle.fill"), for: .normal)
        menuBtn.setPreferredSymbolConfiguration(.init(pointSize: 20), forImageIn: .normal)
        menuBtn.tintColor = .cornGreen
        menuBtn.addTarget(self, action: #selector(menuBtnSelector), for: .touchUpInside)
        topView.addSubview(menuBtn)
        menuBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            menuBtn.centerYAnchor.constraint(equalTo: topView.centerYAnchor)
        ])
    }
    
    @objc private func menuBtnSelector(){
        presenter.menuButtonPressed()
    }
    
    private func configureFavBtn(){
        favBtn = UIButton(frame: .zero)
        favBtn.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
        favBtn.tintColor = .systemRed
        favBtn.setPreferredSymbolConfiguration(.init(pointSize: 20), forImageIn: .normal)
        topView.addSubview(favBtn)
        favBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            favBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
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
        //        segment.selectionStyle = .box
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
    
    
    
}

extension MainViewController: MainViewToPresenter{
    
    func onFinishFetchingUpcoming(withData: [Movie]) {
        snapshot.sectionIdentifiers.forEach {
            if $0 == .upcoming {
                snapshot.deleteSections([$0])
            }
            
        }
        snapshot.appendSections([.upcoming])
        snapshot.appendItems(withData,toSection: .upcoming)
        presenter.datasource.applySnapshotUsingReloadData(snapshot, completion: nil)
//        presenter.datasource.apply(snapshot,animatingDifferences: true)

        collection.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
    }
    func onFinishFetching(withData: [Movie]) {
        
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
//        presenter.datasource.applySnapshotUsingReloadData(snapshot, completion: nil)
        presenter.datasource.apply(snapshot,animatingDifferences: true)
    }
    
    func paginate(status: Bool) {
        isPaginating = status
    }
}
