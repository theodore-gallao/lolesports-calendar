//
//  LeagueFilterViewController.swift
//  lolesports-calendar
//
//  Created by Theodore Gallao on 3/28/19.
//  Copyright © 2019 Theodore Gallao. All rights reserved.
//

import Foundation
import UIKit

protocol LeagueFilterViewControllerDataSource {
    func leagueFilterViewControllerNumberOfLeagueCollections(_ leagueFilterViewController: LeagueFilterViewController) -> Int
    
    func leagueFilterViewController(_ leagueFilterViewController: LeagueFilterViewController, leagueCollection forSection: Int) -> LeagueCollection
    
    func leagueFilterViewControllerSelectedLeagues(_ leagueFilterViewController: LeagueFilterViewController) -> [League]
}

// MARK: League Filter View Controller Delegate - Declaration
/// Objects that conform to this protocol receive events called by `LeagueFilterViewController`.
protocol LeagueFilterViewControllerDelegate {
    
    func leagueFilterViewController(_ leagueFilterViewController: LeagueFilterViewController, didSelect league: League)
    
    func leagueFilterViewController(_ leagueFilterViewController: LeagueFilterViewController, didDeselect league: League)
    
    func leagueFilterViewController(_ leagueFilterViewController: LeagueFilterViewController, didTapDone button: UIBarButtonItem)
}

// MARK: League Filter View Controller - Declaration, Variables & Initializers
/// Display to select and deselect leagues.
class LeagueFilterViewController: UIViewController {
    /********** Delegates **********/
    /// Assign a delegate to receive this `LeagueFilterViewController` instance's events.
    var delegate: LeagueFilterViewControllerDelegate?
    var dataSource: LeagueFilterViewControllerDataSource?
    
    /********** Views **********/
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.backgroundColor              = UIColor.clear
        tableView.separatorColor               = UIColor.clear
        tableView.allowsSelection              = true
        tableView.allowsMultipleSelection      = true
        tableView.estimatedSectionHeaderHeight = 44
        tableView.estimatedSectionFooterHeight = 4
        tableView.estimatedRowHeight           = 56
        tableView.delegate                     = self
        tableView.dataSource                   = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(LeagueTableViewCell.self, forCellReuseIdentifier: LeagueTableViewCell().id)
        
        return tableView
    }()
    
    private lazy var doneBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "Back Arrow"),
                                            style: UIBarButtonItem.Style.plain,
                                            target: self,
                                            action: #selector(self.handleTapDoneBarButtonItem(_:)))
        barButtonItem.tintColor = UIColor.Flat.Red.alizarin
        
        return barButtonItem
    }()
    
    private let bottomBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Flat.White.silver
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    /********** Constraints **********/
    private var tableViewConstraints        = [NSLayoutConstraint]()
    private var bottomBorderViewConstraints = [NSLayoutConstraint]()
}

// MARK: League Filter View Controller - View Controller States
extension LeagueFilterViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.Flat.White.silver
        
        self.title = "FILTER"
        
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.bottomBorderView)
        
        self.configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.setRightBarButtonItems([self.doneBarButtonItem], animated: animated)
        
        if let navigationController = self.navigationController {
            navigationController.navigationBar.barStyle = .black
            navigationController.navigationBar.isTranslucent = false
            navigationController.navigationBar.barTintColor = UIColor.white
            navigationController.navigationBar.tintColor = UIColor.Flat.Red.alizarin
            navigationController.navigationBar.shadowImage = UIImage()
            navigationController.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.Trebuchet.bold.withSize(14),
                NSAttributedString.Key.foregroundColor: UIColor.black
            ]
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: League Filter View Controller - Layout & Configurations
extension LeagueFilterViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.configureLayout()
    }
    
    private func configureLayout() {
        NSLayoutConstraint.deactivate(self.tableViewConstraints)
        NSLayoutConstraint.deactivate(self.bottomBorderViewConstraints)
        
        self.tableViewConstraints = [
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        ]
        
        self.bottomBorderViewConstraints = [
            self.bottomBorderView.heightAnchor.constraint(equalToConstant: 1),
            self.bottomBorderView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            self.bottomBorderView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            self.bottomBorderView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0)
        ]
        
        NSLayoutConstraint.activate(self.tableViewConstraints)
        NSLayoutConstraint.activate(self.bottomBorderViewConstraints)
    }
}

extension LeagueFilterViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource?.leagueFilterViewControllerNumberOfLeagueCollections(self) ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource?.leagueFilterViewController(self, leagueCollection: section).leagues.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = BasicHeaderView()
        headerView.backgroundColor = UIColor.white
        
        headerView.titleLabel.font      = UIFont.Trebuchet.bold.withSize(12)
        headerView.titleLabel.textColor = UIColor.LOLEsports.Black.black
        
        headerView.subtitleLabel.font      = UIFont.Trebuchet.bold.withSize(12)
        headerView.subtitleLabel.textColor = UIColor.LOLEsports.Gray.lightGray
        headerView.subtitleLabel.text      = "TAP TO SELECT/DESELECT"
        
        let leagueCollectionName = self.dataSource?.leagueFilterViewController(self, leagueCollection: section).name ?? ""
        headerView.titleLabel.text = leagueCollectionName.uppercased()
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LeagueTableViewCell().id, for: indexPath) as! LeagueTableViewCell
        cell.selectionStyle              = .none
        cell.backgroundColor             = UIColor.LOLEsports.White.white
        cell.contentView.backgroundColor = UIColor.LOLEsports.White.white
        cell.topSeparatorView.alpha      = 0
        cell.bottomSeparatorView.alpha   = 0
        
        if
            let leagueCollection = self.dataSource?.leagueFilterViewController(self, leagueCollection: indexPath.section),
            let league = leagueCollection.leagues[optional: indexPath.row],
            let selectedLeagues = self.dataSource?.leagueFilterViewControllerSelectedLeagues(self)
        {
            let selected = selectedLeagues.contains(league)
            cell.set(league, selected: selected, animated: false)
        }
       
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard
            let cell             = tableView.cellForRow(at: indexPath) as? LeagueTableViewCell,
            let leagueCollection = self.dataSource?.leagueFilterViewController(self, leagueCollection: indexPath.section),
            let league           = leagueCollection.leagues[optional: indexPath.row],
            let selectedLeagues  = self.dataSource?.leagueFilterViewControllerSelectedLeagues(self)  else
        {
            return
        }
        
        let selected  = selectedLeagues.contains(where: { $0.id == league.id })
        if selected {
            if selectedLeagues.count == 1 { return }
            
            self.delegate?.leagueFilterViewController(self, didDeselect: league)
            cell.set(league, selected: false, animated: true)
        } else {
            self.delegate?.leagueFilterViewController(self, didSelect: league)
            cell.set(league, selected: true, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Only able to move rows in first section, "SELECTED LEAGUES"
        return indexPath.section == 0
    }
    
    public func setDoneButtonHidden(_ hidden: Bool) {
        self.doneBarButtonItem.isEnabled = !hidden
        self.doneBarButtonItem.image =
            hidden ? nil : UIImage(named: "Back Arrow")
    }
    
    @objc private func handleTapDoneBarButtonItem(_ sender: UIBarButtonItem) {
        self.delegate?.leagueFilterViewController(self, didTapDone: sender)
    }
}
