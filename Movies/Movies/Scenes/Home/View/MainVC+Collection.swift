//
//  MainVC+Collection.swift
//  Movies
//
//  Created by Sulfah on 16/11/2021.
//

import Foundation
import UIKit

extension MainViewController{
    private var headerSupplementaryKind:String{
        return "header"
    }
    private var footerSupplementaryKind:String{
        return "footer"
    }
    private var supplementaryBadgeKind:String{
        return "badge"
    }
    func configureCollection(){
        
        collection = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
        collection.delegate = self
        collection.scrollsToTop = true
        collection.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collection)
        
        NSLayoutConstraint.activate([
            collection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collection.topAnchor.constraint(equalTo: topView.bottomAnchor,constant: 60),
            collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        collection.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        collection.backgroundColor = .clear
        let nib = UINib(nibName: "UpcomingCell", bundle: nil)
        collection.register(nib, forCellWithReuseIdentifier: MovieCell.id)
        collection.register(CollectionHeader.self, forSupplementaryViewOfKind: self.headerSupplementaryKind, withReuseIdentifier: CollectionHeader.id)
        collection.register(CollectionFooter.self, forSupplementaryViewOfKind: self.footerSupplementaryKind, withReuseIdentifier: CollectionFooter.id)
        collection.register(BadgeSuplmentary.self, forSupplementaryViewOfKind: self.supplementaryBadgeKind, withReuseIdentifier: BadgeSuplmentary.id)
        
        let refresh = UIRefreshControl()
        refresh.tintColor = .lightGray
        refresh.addTarget(self, action: #selector(refreshSelector), for: .valueChanged)
        collection.refreshControl = refresh
        
    }
    @objc func refreshSelector(){
        startPoint()
    }
    
    func createSnipperFooter()->UIRefreshControl{
        
        let indicator = UIRefreshControl()
        
        indicator.tintColor = .white
        return indicator
        
    }
    func configureDatasource(){
        presenter.datasource = UICollectionViewDiffableDataSource<Sections,Movie>(collectionView: collection, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.id, for: indexPath) as? MovieCell else {fatalError("unable to deque cell")}
            cell.configure(withData: itemIdentifier)
            
            if indexPath.section == 1{
                //                cell.contentView.alpha = 0
                cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }else{
                cell.transform = CGAffineTransform(translationX: self.view.bounds.maxX, y: 0)
            }
            
            return cell
        })
        presenter.datasource.supplementaryViewProvider = {collection,elementKind,indexpath in
            let section = self.snapshot.sectionIdentifiers[indexpath.section]
            
            switch elementKind{
            case self.supplementaryBadgeKind:
                guard let badge = collection.dequeueReusableSupplementaryView(ofKind: self.supplementaryBadgeKind, withReuseIdentifier: BadgeSuplmentary.id, for: indexpath) as? BadgeSuplmentary else {fatalError("unabel to dequeue collection suplementary")}
                badge.date = self.snapshot.itemIdentifiers(inSection: section)[indexpath.item].releaseDate
                return badge
            case self.headerSupplementaryKind:
                guard let header = collection.dequeueReusableSupplementaryView(ofKind: self.headerSupplementaryKind, withReuseIdentifier: CollectionHeader.id, for: indexpath) as? CollectionHeader else {fatalError("unable to deque collection header")}
                header.title = section.header
                return header
                
            case self.footerSupplementaryKind:
                guard let footer = collection.dequeueReusableSupplementaryView(ofKind: self.footerSupplementaryKind, withReuseIdentifier: CollectionFooter.id, for: indexpath) as? CollectionFooter else {fatalError("unable to deque")}
                self.footer = footer
                return footer
            default:
                return collection.dequeueReusableCell(withReuseIdentifier: "", for: indexpath)
            }
            
        }
        snapshot = NSDiffableDataSourceSnapshot<Sections,Movie>()
    }
    func generateLayout()->UICollectionViewLayout{
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, env in
            
            guard let currentSection = Sections(rawValue: sectionIndex) else {fatalError("unable to get section with index \(sectionIndex)")}
            
            let badgeAnchor = NSCollectionLayoutAnchor(edges: [.top,.leading], absoluteOffset: CGPoint(x: 5, y: 5))
            let dateBadge = NSCollectionLayoutSupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(50)),elementKind: self.supplementaryBadgeKind,containerAnchor: badgeAnchor)
            
            
            var item: NSCollectionLayoutItem
            var group :NSCollectionLayoutGroup
            var section :NSCollectionLayoutSection
            switch currentSection {
            case .upcoming:
                item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)),supplementaryItems: [dateBadge])
                
                if env.container.contentSize.width > 500 {
                    group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(2/3)), subitem: item,count: 2)
                }else{
                    group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3)), subitems: [item])
                }
                
                group.interItemSpacing = NSCollectionLayoutSpacing.fixed(CGFloat(10))
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                
            default:
                
                item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                if env.container.contentSize.width > 500{
                    group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(2/3)), subitem: item,count: 4)
                }else{
                    group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3)), subitem: item,count: 2)
                }
                group.interItemSpacing = NSCollectionLayoutSpacing.fixed(CGFloat(10))
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .none
                
                let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(50)), elementKind: self.footerSupplementaryKind, alignment: .bottom)
                section.boundarySupplementaryItems = [footer]
            }
            
            
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .estimated(30)), elementKind: self.headerSupplementaryKind, alignment: .top)
            
            
            
            header.pinToVisibleBounds = true
            header.zIndex = 50
            section.boundarySupplementaryItems.append(header)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5)
            section.supplementariesFollowContentInsets = true
            section.interGroupSpacing = 10
            
            return section
            
        }
        return layout
    }
}

//MARK: Animations & pagination
extension MainViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.onTappedCell(withIndex: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        guard let footer = footer else {return}
        print("scrol")
        guard isPaginating == false else {
            return
        }
        
        if position > (collection.contentSize.height + 60) - (scrollView.frame.size.height) && position != 0.0 {
            footer.startAnimating()
            self.presenter.fetch(withSelectedIndex: Int(self.segment.selectedSegmentIndex), paging: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            cell.alpha = 0
            UIView.animate(withDuration: 0.6) {
                cell.alpha = 1
                cell.transform = .identity
            }
        }else{
            cell.alpha = 0
            UIView.animate(withDuration: 0.5,delay: 0.3,options: .curveEaseIn) {
                cell.transform = .identity
                cell.alpha = 1
            }
        }
    }
}
