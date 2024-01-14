//
//  SearchViewController.swift
//  CinemaTix
//
//  Created by Eky on 15/12/23.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: BaseViewController {
    
    private let table = UITableView()
    
    private let searchController = UISearchController()
    
    private let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(table)
        table.snp.makeConstraints { make in
            make.edges.equalTo(self.view.snp.edges)
        }
        
        table.delegate = self
        table.dataSource = self
        table.register(SearchTableCell.self)
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.barTintColor = UIColor.white
        searchController.searchBar.tintColor = .accent
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        table.separatorStyle = .singleLine
        
        searchController.searchBar.rx.text.orEmpty.bind(to: viewModel.searchQuerySubject).disposed(by: viewModel.disposeBag)
        viewModel.getMoviesByQuery() {
            self.table.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.becomeFirstResponder()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.searchQuerySubject.disposed(by: viewModel.disposeBag)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = viewModel.resultsSearchMovies?.count {
            return min(5, count)
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(forIndexPath: indexPath) as SearchTableCell
        if let movie = viewModel.resultsSearchMovies?[indexPath.row] {
            cell.label.text = movie.title ?? "-"
            cell.onTap = {
                let movieVC = DetailMovieViewController(movie: movie)
                self.navigationController?.pushViewController(movieVC, animated: true)
            }
        }
        return cell
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
//        print(searchController.searchBar.text)
    }
}
