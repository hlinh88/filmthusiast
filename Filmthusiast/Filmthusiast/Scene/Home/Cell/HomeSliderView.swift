//
//  HomeSliderView.swift
//  Filmthusiast
//
//  Created by Hoang Linh Nguyen on 31/3/2024.
//

import UIKit
import Reusable

protocol HomeSliderViewOutput: AnyObject {
    func goToMovieDetail(_ id: Int)
}

class HomeSliderView: BaseCVCell {
    @IBOutlet weak var collectionView: UICollectionView!

    weak var output: HomeSliderViewOutput?

    var movies: [Movie] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }

    private func setupCell() {
        collectionView.register(cellType: HomeMovieCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self

    }

    func configCell(with movies: [Movie]) {
        self.movies = movies
    }

}

extension HomeSliderView: UICollectionViewDataSource, 
                            UICollectionViewDelegate,
                            UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 200)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeMovieCell = collectionView.dequeueReusableCell(for: indexPath, cellType: HomeMovieCell.self)
        cell.configCell(with: movies[indexPath.row])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        output?.goToMovieDetail(movie.id)
    }

}
