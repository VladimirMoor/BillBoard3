//
//  ViewController.swift
//  BillBoard3
//
//  Created by Vladimir on 15.05.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    enum Section: Int, CaseIterable {
        case top
        case main
    }
    
    struct Lot: Hashable {
        let category: Category
        let title: String?
        let price: Int?
        let img: String?
        init(category: Category, title: String? = nil, price: Int? = nil, img: String? = nil) {
            self.category = category
            self.title = title
            self.price = price
            self.img = img
        }
        private let identifier = UUID()
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Lot>!
    var posts = Post.getData()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        collectionView.collectionViewLayout = createLayout()
        configureDataSource()
        updateSnapshot()
        
    }
}

extension ViewController {
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionType = Section(rawValue: sectionIndex) else { return nil }
            
            switch sectionType {
            case .top:
                return self.createTopSection()
            case .main:
                return self.createMainSection()
            }
        }
        return layout
    }
    
    private func createTopSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalHeight(0.5), heightDimension: .fractionalHeight(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        return section
    }
    
    private func createMainSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        return section
    }
    
    private func configureTopCell() -> UICollectionView.CellRegistration<UICollectionViewCell, Lot> {
        
        let cell = UICollectionView.CellRegistration<UICollectionViewCell, Lot> { (cell, indexPath, lot) in
            
            // Default content configuration
            var content = UIListContentConfiguration.cell()
            content.text = lot.category.rawValue
            cell.contentConfiguration = content
            
            // background configuration
            var bgConfig = UIBackgroundConfiguration.listPlainCell()
            bgConfig.backgroundColor = .orange
            bgConfig.cornerRadius = 4
            bgConfig.strokeColor = .black
            bgConfig.strokeWidth = 2
            cell.backgroundConfiguration = bgConfig
            
        }
        
        return cell
    }
    
    private func configureMainCell() -> UICollectionView.CellRegistration<UICollectionViewCell, Lot> {
        
        let cell = UICollectionView.CellRegistration<UICollectionViewCell, Lot> { (cell, indexPath, lot) in
            
            // content conf
            var content = UIListContentConfiguration.cell()
            content.image = UIImage(named: lot.img ?? "empty")
            content.imageProperties.cornerRadius = 5
            content.imageProperties.maximumSize = CGSize(width: 200, height: 200)
            content.text = lot.title
            content.textProperties.alignment = .justified
            content.secondaryText = String(lot.price ?? 0) + "$"
            cell.contentConfiguration = content
            
            // background conf
            var bgConf = UIBackgroundConfiguration.listPlainCell()
            bgConf.backgroundColor = .green
            bgConf.cornerRadius = 4
            bgConf.strokeWidth = 1
            bgConf.strokeColor = .systemGray
            bgConf.strokeOutset = 5
            cell.backgroundConfiguration = bgConf
        }
        
        return cell
        
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Lot>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, lot) -> UICollectionViewCell? in
            
            var cell = UICollectionViewCell()
            
            if let section = Section(rawValue: indexPath.section) {
                
                switch section {
                case .top:
                    cell = collectionView.dequeueConfiguredReusableCell(using: self.configureTopCell(), for: indexPath, item: lot)
                case .main:
                    cell = collectionView.dequeueConfiguredReusableCell(using: self.configureMainCell(), for: indexPath, item: lot)
                }
            }
            
            return cell
        })
    }
    
    private func updateSnapshot() {
        
        var topSnapshot = NSDiffableDataSourceSectionSnapshot<Lot>()
        var topLots: [Lot] = []
        for post in posts {
            topLots.append(Lot(category: post.category))
        }
        topSnapshot.append(topLots)
        dataSource.apply(topSnapshot, to: .top, animatingDifferences: false)
        
        
        
        var mainSnapshot = NSDiffableDataSourceSectionSnapshot<Lot>()
        var mainLots: [Lot] = []
        for post in posts {
            mainLots.append(Lot(category: post.category, title: post.title, price: post.price, img: post.img))
        }
        mainSnapshot.append(mainLots)
        dataSource.apply(mainSnapshot, to: .main, animatingDifferences: false)
        
    }
}

