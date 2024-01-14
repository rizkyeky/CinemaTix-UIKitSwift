//
//  HomeViewController.swift
//  CinemaTix
//
//  Created by Eky on 13/12/23.
//

import UIKit
import SkeletonView

class HomeViewController: BaseViewController {
    
    private let mainTable = {
        let table = UITableView()
        table.allowsSelection = false
        table.separatorStyle = .none
        table.sectionHeaderTopPadding = 0.0
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    private let refreshControl = UIRefreshControl()
    
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addAction(UIAction() { _ in
            self.refreshControl.endRefreshing()
        }, for: .primaryActionTriggered)
                
        setupMainTable()
    }
    
    override func setupNavBar() {
        navigationItem.title = "CinemaTix"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIImageView(image: UIImage(named: "Icon")?.resize(CGSize(width: 36, height: 36))))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: IconButton(icon: AppIcon.search) {
            self.navigationController?.pushViewController(SearchViewController(), animated: true)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navBar = navigationController?.navigationBar {
            navBar.transform = CGAffineTransform(translationX: 0, y: -100)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let navBar = navigationController?.navigationBar {
            navBar.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let navBar = navigationController?.navigationBar {
            navBar.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    override func setupConstraints() {
        view.addSubview(mainTable)
        mainTable.addSubview(refreshControl)
        mainTable.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(view.snp.top).offset(-100)
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupMainTable() {
        
        mainTable.delegate = self
        mainTable.dataSource = self
        mainTable.register(HomeTableCell.self)
        mainTable.register(RecomendedTableCell.self)
        mainTable.register(UpComingTableCell.self)
        
        let homeCarousel =  HomeCarousel(viewModel: viewModel, size: CGSize(width: view.bounds.width, height: view.bounds.height*0.6))
        
        homeCarousel.onTapCell = { index in
            if let movie = self.viewModel.playingNowMovies?[index] {
                let vc = DetailMovieViewController(movie: movie)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        mainTable.tableHeaderView = homeCarousel
        
        viewModel.getPlayingNowMovies {
            homeCarousel.updateCarousel()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let base = UIView()
        let tile = UIStackView(frame: .init(x: 0, y: 0, width: view.bounds.width, height: 52))
        let label = UILabel()
        let forwardBtn = IconButton(icon: AppIcon.forward, size: CGSize(width:24, height: 24), iconSize: CGSize(width: 12, height: 12))
    
        tile.axis = .horizontal
        tile.distribution = .fillProportionally
        tile.alignment = .center
        tile.addArrangedSubview(label)
        tile.addArrangedSubview(forwardBtn)
        
        forwardBtn.snp.makeConstraints { make in
            make.height.width.equalTo(24)
        }
        
        base.addSubview(tile)
        tile.snp.makeConstraints { make in
            make.top.bottom.equalTo(base)
            make.left.equalTo(base).offset(16)
            make.right.equalTo(base).inset(16)
        }
        
        switch section {
        case 0:
            label.text = LanguageStrings.recommendedForYou.localized
            label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            forwardBtn.isHidden = true
        case 1:
            label.text = LanguageStrings.upcoming.localized
            label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            forwardBtn.addAction(UIAction { _ in
                self.navigationController?.pushViewController(ListMovieViewController(titlePage: label.text ?? "", type: .upcoming) , animated: true)
            }, for: .touchUpInside)
        case 2:
            label.text = LanguageStrings.topRated.localized
            label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            forwardBtn.addAction(UIAction { _ in
                self.navigationController?.pushViewController(ListMovieViewController(titlePage: label.text ?? "", type: .topRated), animated: true)
            }, for: .touchUpInside)
        default:
            break
        }
        
        return base
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as RecomendedTableCell
            cell.size = CGSize(width: view.bounds.width, height: 360)
            cell.isLoading = true
            viewModel.getPopularMovies {
                cell.isLoading = false
                if let movies = self.viewModel.popularMovies {
                    cell.updateMovies(movies)
                    cell.onTapCell = { index in
                        self.navigationController?.pushViewController(DetailMovieViewController(movie: movies[index]), animated: true)
                    }
                }
            }
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as UpComingTableCell
            cell.isLoading = true
            viewModel.getUpComingMovies {
                cell.isLoading = false
                if let movies = self.viewModel.upComingMovies {
                    cell.updateMovies(movies)
                    cell.onTapCell = { index in
                        self.navigationController?.pushViewController(DetailMovieViewController(movie: movies[index]), animated: true)
                    }
                }
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as UpComingTableCell
            cell.isLoading = true
            viewModel.getTopRatedMovies {
                cell.isLoading = false
                if let movies = self.viewModel.topRatedMovies {
                    cell.updateMovies(movies)
                    cell.onTapCell = { index in
                        self.navigationController?.pushViewController(DetailMovieViewController(movie: movies[index]), animated: true)
                    }
                }
            }
            return cell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = navBarSafeAreaHeight()
        let offset = (scrollView.contentOffset.y*0.2 - defaultOffset)
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, offset))
    }
}



