//
//  ProfileViewController.swift
//  CinemaTix
//
//  Created by Eky on 21/12/23.
//
import UIKit

class ProfileViewController: BaseViewController {
    
    let table: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let viewModel = ProfileViewModel()
    
    private var profileItems: [[ProfileOption]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        table.register(ProfileTableCell.self)
        
        profileItems = [
            [
                ProfileOption(label: "Name", trailing: viewModel.user?.displayName ?? "-"),
                ProfileOption(label: "Username", trailing: viewModel.user?.username ?? "-"),
                ProfileOption(label: "Email", trailing: viewModel.user?.email ?? "-"),
                ProfileOption(label: "Gender", trailing: viewModel.user?.gender?.toStr() ?? "-"),
            ],
            [
                ProfileOption(label: "Dark Mode") {
                    DarkMode.activated.toggle()
                },
                ProfileOption(label: "Activate FaceID") {
                    self.navigationController?.pushViewController(FaceRecogViewController(), animated: true)
                },
                ProfileOption(label: "Change Language") {
                    self.showLanguagesActionSheet()
                },
                ProfileOption(label: "Log Out") {
                    self.showAlertOKCancel(title: "Log Out", message: "Are you sure want to log out ?", onTapOK:  {
                        let authVM = AuthViewModel()
                        authVM.signOut {
                            self.navigationController?.popToRootViewController(animated: false)
                            self.navigationController?.setViewControllers([WelcomeViewController()], animated: false)
                        }
                    })
                }
            ]
        ]
    }
    
    override func setupConstraints() {
        view.addSubview(table)
        
        table.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(self.view)
        }
    }
    
    override func setupNavBar() {
        navigationItem.title = LanguageStrings.profile.localized
    }
    
    func showLanguagesActionSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let option1Action = UIAlertAction(title: "Indonesia", style: .default) { _ in
            
        }
        alertController.addAction(option1Action)
        
        let option2Action = UIAlertAction(title: "English", style: .default) { _ in
            
        }
        alertController.addAction(option2Action)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return profileItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ProfileTableCell
        
        cell.label.text = profileItems[indexPath.section][indexPath.row].label
        
        if indexPath.section == 0 {
            cell.accessoryType = .none
            cell.trailing.text = profileItems[indexPath.section][indexPath.row].trailing
        } else {
            cell.accessoryType = .disclosureIndicator
            cell.onTap = profileItems[indexPath.section][indexPath.row].onTap
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

class ProfileTableCell: BaseTableCell {
    
    private let base = UIView()
    public let label = UILabel()
    public let trailing = UILabel()
    
    override func setup() {
        contentView.addSubview(base)
        base.snp.makeConstraints { make in
//            make.top.left.right.bottom.equalTo(contentView)
            make.height.equalTo(48)
        }
        
        label.font = .medium(16)
        trailing.font = .medium(16)
        
        base.addSubviews(label, trailing)
        label.snp.makeConstraints { make in
            make.centerY.equalTo(base)
            make.left.equalTo(base).inset(16)
        }
        trailing.snp.makeConstraints { make in
            make.centerY.equalTo(base)
            make.left.equalTo(base).offset(200)
        }
    }
}

struct ProfileOption {
    var label: String
    var trailing: String?
    var onTap: (() -> Void)?
    
    init(label: String, trailing: String? = nil, onTap: (() -> Void)? = nil) {
        self.label = label
        self.trailing = trailing
        self.onTap = onTap
    }
}
