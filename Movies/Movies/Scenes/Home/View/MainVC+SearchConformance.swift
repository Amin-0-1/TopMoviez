//
//  MainVC+SearchConformance.swift
//  Movies
//
//  Created by Amin on 21/06/2022.
//
import Foundation
extension MainViewController:UISearchBarDelegate,UICollectionViewDataSource{
    
    var layout:UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: (view.frame.width / 2) - 15, height: 200)
        return layout
    }
    func configureSearchCollection(){
        
        collection = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        let nib = UINib(nibName: "UpcomingCell", bundle: nil)
        collection.register(nib, forCellWithReuseIdentifier: MovieCell.id)
        self.view.addSubview(collection)
        NSLayoutConstraint.activate([
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collection.topAnchor.constraint(equalTo: searchBar.bottomAnchor)
        ])
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getSearchCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.id, for: indexPath) as? MovieCell else {fatalError("unable to dequeu")}
        cell.configure(withData: presenter.getModel(forIndex: indexPath.item))
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searching(forText: searchText)
    }
}
