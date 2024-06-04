//
//  MovieContentSection.swift
//  Filmthusiast
//
//  Created by Hoang Linh Nguyen on 19/5/2024.
//

import UIKit

protocol MovieContentSectionOutput: AnyObject {
    func didSelectCell(type: MovieContentSection.SectionType,
                       content: MovieContentSectionModel)
}

class MovieContentSection: UIView {
    enum SectionType {
        case Cast
    }
    
    @IBOutlet weak var stvTitle: UIStackView!
    @IBOutlet weak var clvContent: UICollectionView!
    
    private var contents: [MovieContentSectionModel] = [] {
        didSet {
            clvContent.reloadData()
        }
    }
    
    weak var output: MovieContentSectionOutput?
    var type: SectionType?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    func configSection(sectionType: SectionType, headerTitle: String, contents: [MovieContentSectionModel], output: MovieContentSectionOutput) {
        self.type = sectionType
        self.output = output
        setupCollectionView()
        setupHeader(title: headerTitle)
        self.contents = contents
    }
    
    private func setupHeader(title: String) {
        let movieDetailHeader: MovieDetailHeader = MovieDetailHeader.fromNib()
        movieDetailHeader.configHeader(with: title)
        
        stvTitle.addArrangedSubview(movieDetailHeader)
    }
    
    private func setupCollectionView() {
        clvContent.register(cellType: MovieContentSectionCell.self)
        clvContent.delegate = self
        clvContent.dataSource = self
    }
}

extension MovieContentSection: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MovieContentSectionCell = collectionView.dequeueReusableCell(for: indexPath, cellType: MovieContentSectionCell.self)
        let content = contents[indexPath.row]
        cell.configCell(with: content)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let type else { return }
        let content = contents[indexPath.row]
        
        output?.didSelectCell(type: type,
                              content: content)
    }
}

extension MovieContentSection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: collectionView.frame.height)
    }
}
