//
//  ViewController2.swift
//  CollectionViewDemo
//
//  Created by Jolas L on 01/08/20.
//  Copyright © 2020 Jolas L. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let numberOfSections = 10
    private let numberOfItemsInEachSection = 4
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        //MARK: ISSUE -> Uncommenting following line will make the UI to struck
//        layout.sectionHeadersPinToVisibleBounds = true
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints  = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        view.backgroundColor = .yellow
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        collectionView.backgroundColor = .green
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.cellId)
        collectionView.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCell.cellId)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //MARK: ISSUE -> scrollToItem not scrolling to 4th item of 10th section. If I remove headers it's working fine.
        collectionView.scrollToItem(at: IndexPath(row: numberOfItemsInEachSection - 1, section: numberOfSections - 1), at: .bottom, animated: true)
        print("CONTENTSIZE: \(collectionView.contentSize)")
    }
}

extension ViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numberOfItemsInEachSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.cellId, for: indexPath) as! ItemCell
        itemCell.maxWidth = collectionView.frame.width
        itemCell.text = "Item -> Section:\(indexPath.section) Row:\(indexPath.row)"
        return itemCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCell.cellId, for: indexPath) as! HeaderCell
        headerCell.maxWidth = collectionView.frame.width
        headerCell.text = "Header -> Section:\(indexPath.section) Row:\(indexPath.row)"
        return headerCell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 30)
    }
}

//MARK: ITEM CELL
class ItemCell: UICollectionViewCell {
    static let cellId = "ItemCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = .cyan
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var text: String = "" {
        didSet{
            label.text = text
        }
    }
    
    var maxWidth: CGFloat = 0 {
        didSet{
            if labelWidthConstraint.constant != maxWidth{
                labelWidthConstraint.constant = maxWidth
            }
        }
    }
    
    private var labelWidthConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews(){
        contentView.addSubview(label)
        labelWidthConstraint = label.widthAnchor.constraint(equalToConstant: 0)
        let constraints : [NSLayoutConstraint] = [
            labelWidthConstraint,
            label.heightAnchor.constraint(equalToConstant: 30),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

//MARK: HeaderCell
class HeaderCell: UICollectionViewCell{
    static let cellId = "HeaderCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var text: String = "" {
        didSet{
            label.text = text
        }
    }
    
    var maxWidth: CGFloat = 0 {
        didSet{
            if labelWidthConstraint.constant != maxWidth{
                labelWidthConstraint.constant = maxWidth
            }
        }
    }
    
    private var labelWidthConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews(){
        contentView.addSubview(label)
        labelWidthConstraint = label.widthAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            labelWidthConstraint,
            label.heightAnchor.constraint(equalToConstant: 30),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        print("preferredLayoutAttributesFitting \(attributes)")
        return attributes
    }
}
