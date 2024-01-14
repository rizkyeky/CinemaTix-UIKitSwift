//
//  WalletViewController.swift
//  CinemaTix
//
//  Created by Eky on 15/12/23.
//

import UIKit

class WalletViewController: BaseViewController {
    
    private let mainTable = {
        let table = UITableView()
        table.allowsSelection = false
        table.separatorStyle = .none
        table.sectionHeaderTopPadding = 0.0
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    private let refreshControl = UIRefreshControl()
    private var mainCard: WalletHeader!
    
    private let viewModel = WalletViewModel()
    
    public var onRemoveItem: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addAction(UIAction() { _ in
            self.refreshControl.endRefreshing()
        }, for: .primaryActionTriggered)
    
        mainCard = WalletHeader(viewModel: viewModel, size: CGSize(width: view.bounds.width, height: 300))
        mainCard.amount.text = "Rp0"
        
        setupMainTable()
        
        viewModel.getWalletFB {
            self.updateAmount()
            self.mainTable.reloadData()
        } onError: { error in
            
        }
    }
    
    override func setupNavBar() {
        navigationItem.title = "Wallet"
    }

    override func setupConstraints() {
        view.addSubview(mainTable)
        mainTable.addSubview(refreshControl)
        mainTable.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view)
        }
    }
}

extension WalletViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupMainTable() {
        
        mainTable.delegate = self
        mainTable.dataSource = self
        mainTable.register(TransactionsTableCell.self)
        mainTable.register(TopUpTableCell.self)
        
        mainTable.tableHeaderView = mainCard
    }
    
    func updateAmount() {
        let total = viewModel.getTotalAmount()
        mainCard.amount.rx.text.onNext("Rp\(NSNumber(value:total).toDecimalString())")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            let len = viewModel.getLenTrans()
            return len
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 52
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let base = UIView()
        let label = UILabel()
        
        base.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.bottom.equalTo(base)
            make.left.equalTo(base).offset(16)
            make.right.equalTo(base).inset(16)
        }
        
        label.text = "Transactions"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        return base
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TopUpTableCell
            cell.onTapButton = {
                let vc = PayViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TransactionsTableCell
            
            let trans = viewModel.getTrans(indexPath.row)
            
            cell.subtitle.text = trans.label ?? ""
            cell.amount.text = "Rp\(NSNumber(value: trans.amount ?? 0).toDecimalString())"
            cell.selectionStyle = .none
            
            if let type = trans.type {
                switch type {
                case .income:
                    cell.icon.image = AppIcon.up
                case .outcome:
                    cell.icon.image = AppIcon.down
                }
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            mainTable.beginUpdates()
            let id = viewModel.getTrans(indexPath.row).id
            viewModel.deleteTransBy(id: id ?? "")
            mainTable.deleteRows(at: [indexPath], with: .left)
            mainTable.endUpdates()
            onRemoveItem?(indexPath.row)
        }
    }
}

class WalletHeader: UIView {
    
    private let card = {
        let card = UIView()
        card.makeCornerRadius(16)
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        card.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(card)
        }
        return card
    }()
    
    public let amount = UILabel()
    
    init(viewModel: WalletViewModel, size: CGSize) {
        super.init(frame: .init(x: 0, y: 0, width: size.width, height: size.height))
        
        addSubview(card)
        card.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.width.equalTo(300)
            make.height.equalTo(200)
        }
        
        amount.font = .bold(32)
        
        card.addSubview(amount)
        amount.snp.makeConstraints { make in
            make.centerY.equalTo(card)
            make.centerX.equalTo(card).offset(32)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
