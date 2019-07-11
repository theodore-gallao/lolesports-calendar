//
//  ViewController.swift
//  lolesports-today
//
//  Created by Theodore Gallao on 3/12/19.
//  Copyright © 2019 Theodore Gallao. All rights reserved.
//
//  When pull to refresh is used, only request for previous matches

import UIKit

// MARK: Schedule View Controller Delegate - Declaration
/// Objects that conform to this protocol receive events called by `ScheduleViewController`.
protocol ScheduleViewControllerDelegate {
    
    /// Called when `ScheduleViewController` selects a league `League` and serie `Serie`
    func scheduleViewController(_ scheduleViewController: ScheduleViewController, didSelect serieId: Int)
    
    /// Called when `ScheduleViewController` selects a match `Match`
    func scheduleViewController(_ scheduleViewController: ScheduleViewController, didSelect match: Match)
    
    /// Called when `ScheduleViewController` favorites a match `Match`
    func scheduleViewController(_ scheduleViewController: ScheduleViewController, didFavorite match: Match, shouldFavorite: @escaping(Bool) -> Void)
    
    /// Called when `ScheduleViewController` unfavorites a match `Match`
    func scheduleViewController(_ scheduleViewController: ScheduleViewController, didUnfavorite match: Match, shouldUnfavorite: @escaping(Bool) -> Void)
    
    /// Called when `ScheduleViewController` taps its league `UIBarButtonItem`
    func scheduleViewController(_ scheduleViewController: ScheduleViewController, didTap leaguesButton: UIBarButtonItem)
}

// MARK: Schedule View Controller - Declaration, Variables & Initializers
/// Presents the weekly schedule for leagues.
class ScheduleViewController: UIViewController {
    /********** Delegates **********/
    /// Assign a delegate to receive this `ScheduleViewController` instance's events.
    var scheduleDelegate: ScheduleViewControllerDelegate?
    
    /********** Services **********/
    private let lolEsportsService: LolEsportsService
    private let userDefaults: UserDefaults
    
    /********** Data **********/
    private(set) var selectedLeagues  = [League]()
    private(set) var allMatches       = MatchCollection()
    private(set) var favoriteMatches  = MatchCollection()
    private(set) var favoriteMatchIds = [Int]()
    private(set) var hiddenDates      = [DateModel?]()
    
    private var matches: MatchCollection {
        return self.shouldDisplayFavorites ? self.favoriteMatches : self.allMatches
    }
    
    private var indexPathForCurrentMatch: IndexPath? {
        guard // Optional check chain
            
            // Optional check match FIRST
            // Match is first match where match is not in past or match is running
            let match = self.matches.matches.first(where: { (match) -> Bool in
                if
                    let beginAtStr = match.begin_at,
                    let beginAt    = Date.from(formattedDate: beginAtStr, timezone: TimeZone(abbreviation: "UTC")!)
                {
                    return !beginAt.isInThePast || match.status == .running
                } else {
                    return false
                }
            }),
            
            let beginAtStr = match.begin_at,
            let beginAt    = Date.from(formattedDate: beginAtStr, timezone: TimeZone(abbreviation: "UTC")!),
            
            // Optional check section
            // Section is index of first date model where date is in same day as match
            let section = self.matches.dateModels.firstIndex(where: { (current) -> Bool in
                if let current = current {
                    return beginAt.isInSameDay(date: current.date, timeZone: TimeZone(abbreviation: "UTC")!)
                } else {
                    return false
                }
            }),
            
            let dateModel = self.matches.dateModels[optional: section],
            let matches   = self.matches.matchesByDate[dateModel],
            
            // Optional check row
            // Row is first index of match where match is not in past or match is running
            let row = matches.firstIndex(where: { (match) -> Bool in
                if
                    let beginAtStr = match.begin_at,
                    let beginAt    = Date.from(formattedDate: beginAtStr, timezone: TimeZone(abbreviation: "UTC")!),
                    let dateModel  = DateModel(beginAt)
                {
                    return !dateModel.date.isInThePast || match.status == .running
                } else {
                    return false
                }
            })
        else {
            return nil
        }
        
        return IndexPath(row: row, section: section)
    }
    
    /********** Flags **********/
    private(set) var shouldDisplayFavorites = false
    private(set) var shouldHidePresentLabeledImageView = true
    private(set) var isBusyLoading = false
    private(set) var isBusyScrolling = false
    
    /********** Views **********/
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode     = UIView.ContentMode.scaleToFill
        imageView.tintColor       = UIColor.Flat.Red.alizarin
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines   = 0
        label.backgroundColor = UIColor.clear
        label.font            = UIFont.Trebuchet.bold.withSize(12)
        label.textColor       = UIColor.Flat.Red.alizarin
        label.textAlignment   = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let alertLabeledImageView: LabeledImageView = {
        let labeledImageView = LabeledImageView()
        labeledImageView.backgroundColor          = UIColor.white
        labeledImageView.textColor                = UIColor.black
        labeledImageView.textAlignment            = .center
        labeledImageView.font                     = UIFont.Trebuchet.bold.withSize(12)
        labeledImageView.labelPosition            = .right
        labeledImageView.labelEdgeInsets          = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 12)
        labeledImageView.imageEdgeInsets          = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 6)
        labeledImageView.tintColor                = UIColor.Flat.Red.alizarin
        labeledImageView.layer.cornerRadius       = 4
        labeledImageView.layer.masksToBounds      = true
        labeledImageView.isUserInteractionEnabled = true
        labeledImageView.translatesAutoresizingMaskIntoConstraints = false
        labeledImageView.dropShadow(color: UIColor.black, opacity: 0.2, offSet: CGSize(width: 0, height: 2), radius: 1.5)
        
        return labeledImageView
    }()
    
    private let headerAnimator: NormalHeaderAnimator = {
        let normalHeaderAnimator = NormalHeaderAnimator()
        normalHeaderAnimator.loadingDescription   = "LOADING PAST MATCHES..."
        normalHeaderAnimator.titleLabel.font      = UIFont.Trebuchet.bold.withSize(12)
        normalHeaderAnimator.titleLabel.textColor = UIColor.Flat.Red.alizarin
        normalHeaderAnimator.imageView.image      = UIImage(named: "Down Arrow")
        normalHeaderAnimator.imageView.tintColor  = UIColor.Flat.Red.alizarin
        normalHeaderAnimator.indicatorView.color  = UIColor.Flat.Red.alizarin
        
        return normalHeaderAnimator
    }()
    
    private lazy var headerHandler: CRRefreshHandler = {
        return {
            self.getPastMatches()
        }
    }()
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.backgroundColor              = UIColor.clear
        tableView.separatorColor               = UIColor.clear
        tableView.estimatedRowHeight           = 80
        tableView.estimatedSectionFooterHeight = 4
        tableView.estimatedSectionHeaderHeight = 44
        tableView.delegate                     = self
        tableView.dataSource                   = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MatchTableViewCell.self, forCellReuseIdentifier: MatchTableViewCell().id)
        tableView.register(LiveMatchTableViewCell.self, forCellReuseIdentifier: LiveMatchTableViewCell().id)
        
        tableView.cr.addHeadRefresh(animator: self.headerAnimator, handler: self.headerHandler)
        tableView.cr.addFootRefresh(animator: self.footerAnimator, handler: self.getUpcomingMatches)
        
        return tableView
    }()
    
    private let footerAnimator: NormalFooterAnimator = {
        let normalFooterAnimator = NormalFooterAnimator()
        normalFooterAnimator.backgroundColor      = UIColor.clear
        normalFooterAnimator.titleLabel.font      = UIFont.Trebuchet.bold.withSize(12)
        normalFooterAnimator.titleLabel.textColor = UIColor.Flat.Red.alizarin
        normalFooterAnimator.indicatorView.color  = UIColor.Flat.Red.alizarin
        normalFooterAnimator.noMoreDataDescription = "NO MORE UPCOMING MATCHES."
        
        return normalFooterAnimator
    }()
    
    private lazy var footerHandler: CRRefreshHandler = {
        return {
            self.getUpcomingMatches()
        }
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        loadingIndicator.tintColor       = UIColor.Flat.Red.alizarin
        loadingIndicator.color           = UIColor.Flat.Red.alizarin
        loadingIndicator.layer.zPosition = -1
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        return loadingIndicator
    }()
    
    private lazy var leaguesBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "LoL Icon"),
                                            style: UIBarButtonItem.Style.plain,
                                            target: self,
                                            action: #selector(self.handleTapLeaguesBarButtonItem(_:)))
        barButtonItem.tintColor = UIColor.Flat.Red.alizarin
        
        return barButtonItem
    }()
    
    private lazy var refreshBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "Refresh"),
                                            style: UIBarButtonItem.Style.plain,
                                            target: self,
                                            action: #selector(self.handleTapReloadBarButtonItem(_:)))
        barButtonItem.tintColor = UIColor.Flat.Red.alizarin
        
        return barButtonItem
    }()
    
    private lazy var favoriteBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "Calendar Favorite"),
                                            style: UIBarButtonItem.Style.plain,
                                            target: self,
                                            action: #selector(self.handleTapFavoriteBarButtonItem(_:)))
        barButtonItem.tintColor = UIColor.Flat.Red.alizarin
        
        return barButtonItem
    }()
    
    private lazy var presentLabeledImageView: LabeledImageView = {
        let labeledImageView = LabeledImageView()
        labeledImageView.backgroundColor          = UIColor.Flat.Red.alizarin
        labeledImageView.text                     = "PRESENT"
        labeledImageView.textColor                = UIColor.white
        labeledImageView.textAlignment            = .center
        labeledImageView.font                     = UIFont.Trebuchet.bold.withSize(12)
        labeledImageView.labelPosition            = .right
        labeledImageView.labelEdgeInsets          = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 10)
        labeledImageView.imageEdgeInsets          = UIEdgeInsets(top: 6, left: 2, bottom: 6, right: 0)
        labeledImageView.tintColor                = UIColor.white
        labeledImageView.layer.cornerRadius       = 4
        labeledImageView.layer.masksToBounds      = true
        labeledImageView.isUserInteractionEnabled = true
        labeledImageView.translatesAutoresizingMaskIntoConstraints = false
        labeledImageView.dropShadow(color: UIColor.black, opacity: 0.2, offSet: CGSize(width: 0, height: 2), radius: 1.5)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapPresentLabeledImageView(_:)))
        
        labeledImageView.addGestureRecognizer(tapGestureRecognizer)
        
        return labeledImageView
    }()
    
    private let bottomBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Flat.White.silver
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 1
        
        return view
    }()
    
    /********** Constraints **********/
    private lazy var presentLabeledImageViewConstraints = [NSLayoutConstraint]()
    private lazy var alertLabeledImageViewConstraints = [NSLayoutConstraint]()
    
    /********** Initializers **********/
    init(selectedLeagues:   [League],
         lolEsportsService: LolEsportsService,
         userDefaults: UserDefaults = UserDefaults.standard)
    {
        self.selectedLeagues    = selectedLeagues
        self.lolEsportsService  = lolEsportsService
        self.userDefaults       = userDefaults
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Schedule View Controller - View Controller States
extension ScheduleViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "SCHEDULE"
        
        self.view.backgroundColor = UIColor.Flat.White.silver
        
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.messageLabel)
        self.view.addSubview(self.loadingIndicator)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.presentLabeledImageView)
        self.view.addSubview(self.bottomBorderView)
        self.view.addSubview(self.alertLabeledImageView)
    
        self.configureLayout()
        
        self.getMatches(shouldReload: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.setLeftBarButtonItems([self.leaguesBarButtonItem], animated: true)
        self.navigationItem.setRightBarButtonItems([self.refreshBarButtonItem, self.favoriteBarButtonItem], animated: true)
        
        if let navigationController = self.navigationController {
            navigationController.setNavigationBarHidden(false, animated: animated)
            
            navigationController.navigationBar.barStyle             = UIBarStyle.default
            navigationController.navigationBar.isTranslucent        = false
            navigationController.navigationBar.shadowImage          = UIImage()
            navigationController.navigationBar.barTintColor         = UIColor.white
            navigationController.navigationBar.tintColor            = UIColor.Flat.Red.alizarin
            navigationController.navigationBar.titleTextAttributes  = [
                NSAttributedString.Key.font: UIFont.Trebuchet.bold.withSize(14),
                NSAttributedString.Key.foregroundColor: UIColor.black
            ]
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
}

// MARK: Schedule View Controller - Layout & Configurations
extension ScheduleViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.configureLayout()
    }
    
    private func configureLayout() {
        self.imageView.heightAnchor
            .constraint(equalToConstant: 64)
            .isActive = true
        self.imageView.widthAnchor
            .constraint(equalToConstant: 64)
            .isActive = true
        self.imageView.centerXAnchor
            .constraint(equalTo: self.view.centerXAnchor, constant: 0)
            .isActive = true
        self.imageView.bottomAnchor
            .constraint(equalTo: self.view.centerYAnchor, constant: -4)
            .isActive = true
        
        self.messageLabel.topAnchor
            .constraint(equalTo: self.view.centerYAnchor, constant: 12)
            .isActive = true
        self.messageLabel.leftAnchor
            .constraint(equalTo: self.view.leftAnchor, constant: 20)
            .isActive = true
        self.messageLabel.rightAnchor
            .constraint(equalTo: self.view.rightAnchor, constant: -20)
            .isActive = true
        
        self.loadingIndicator.heightAnchor
            .constraint(equalToConstant: 36)
            .isActive = true
        self.loadingIndicator.widthAnchor
            .constraint(equalToConstant: 36)
            .isActive = true
        self.loadingIndicator.centerXAnchor
            .constraint(equalTo: self.view.centerXAnchor, constant: 0)
            .isActive = true
        self.loadingIndicator.centerYAnchor
            .constraint(equalTo: self.view.centerYAnchor, constant: 0)
            .isActive = true
        
        self.tableView.topAnchor
            .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0)
            .isActive = true
        self.tableView.leftAnchor
            .constraint(equalTo: self.view.leftAnchor, constant: 0)
            .isActive = true
        self.tableView.rightAnchor
            .constraint(equalTo: self.view.rightAnchor, constant: 0)
            .isActive = true
        self.tableView.bottomAnchor
            .constraint(equalTo: self.view.bottomAnchor, constant: 0)
            .isActive = true
        
        self.bottomBorderView.heightAnchor
            .constraint(equalToConstant: 1)
            .isActive = true
        self.bottomBorderView.topAnchor
            .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0)
            .isActive = true
        self.bottomBorderView.leftAnchor
            .constraint(equalTo: self.view.leftAnchor, constant: 0)
            .isActive = true
        self.bottomBorderView.rightAnchor
            .constraint(equalTo: self.view.rightAnchor, constant: 0)
            .isActive = true
        
        self.configurePresentLabeledImageViewConstraints()
        self.configureAlertLabeledImageViewConstraints(hidden: true)
    }
    
    private func configurePresentLabeledImageViewConstraints() {
        NSLayoutConstraint.deactivate(self.presentLabeledImageViewConstraints)
        
        var constraints = [
            self.presentLabeledImageView.heightAnchor.constraint(equalToConstant: 30),
            self.presentLabeledImageView.widthAnchor.constraint(equalToConstant: 90),
            self.presentLabeledImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0)
        ]
        
        if self.shouldHidePresentLabeledImageView {
            constraints.append(self.presentLabeledImageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: -10))
        } else {
            constraints.append(self.presentLabeledImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 7))
        }
        
        self.presentLabeledImageViewConstraints = constraints
        
        NSLayoutConstraint.activate(self.presentLabeledImageViewConstraints)
    }
    
    private func configureAlertLabeledImageViewConstraints(hidden: Bool) {
        NSLayoutConstraint.deactivate(self.alertLabeledImageViewConstraints)
        
        var constraints = [
            self.alertLabeledImageView.heightAnchor.constraint(equalToConstant: 44),
            self.alertLabeledImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0)
        ]
        
        if hidden {
            constraints.append(self.alertLabeledImageView.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10))
        } else {
            constraints.append(self.alertLabeledImageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20))
        }
        
        self.alertLabeledImageViewConstraints = constraints
        
        NSLayoutConstraint.activate(self.alertLabeledImageViewConstraints)
    }
}

// MARK: Schedule View Controller - Setters
extension ScheduleViewController {
    public func set(_ selectedLeagues: [League]) {
        self.selectedLeagues = selectedLeagues
        self.getMatches(shouldReload: false)
    }
    
    public func setLeagueButtonHidden(_ hidden: Bool) {
        self.leaguesBarButtonItem.isEnabled = !hidden
        self.leaguesBarButtonItem.image =
            hidden ? nil : UIImage(named: "LoL Icon")
    }
}

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.matches.dateModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dateModel = self.matches.dateModels[optional: section] else { return 0 }
        
        // If date is hidden, return 0
        // Else if should display favorites, return count of favorite matches of date
        // Else if not, return count of all matches in date
        // Else return 0
        if self.hiddenDates.contains(dateModel) {
            return 0
        } else if
            let date    = dateModel,
            let matches = self.matches.matchesByDate[date]
        {
            return matches.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if
            let date    = self.matches.dateModels[optional: indexPath.section],
            let matches = self.matches.matchesByDate[date],
            let match   = matches[optional: indexPath.row]
        {
            let cell: MatchTableViewCell = match.status == .running ?
                tableView.dequeueReusableCell(withIdentifier: LiveMatchTableViewCell().id, for: indexPath) as! LiveMatchTableViewCell :
                tableView.dequeueReusableCell(withIdentifier: MatchTableViewCell().id, for: indexPath) as! MatchTableViewCell
            cell.selectionStyle              = .none
            cell.backgroundColor             = UIColor.white
            cell.contentView.backgroundColor = UIColor.white
            
            let isDateRedundant: Bool
            if
                let previousMatch      = matches[optional: indexPath.row - 1],
                let previousBeginAtStr = previousMatch.begin_at,
                let currentBeginAtStr  = match.begin_at,
                let previousDate       = Date.from(formattedDate: previousBeginAtStr, timezone: TimeZone.current),
                let currentDate        = Date.from(formattedDate: currentBeginAtStr, timezone: TimeZone.current)
            {
                let previousHour = Calendar.current.component(Calendar.Component.hour, from: previousDate)
                let currentHour  = Calendar.current.component(Calendar.Component.hour, from: currentDate)
                
                isDateRedundant = previousHour == currentHour
            } else {
                isDateRedundant = false
            }
            
            let isFirstCell = indexPath.row == 0
            let isFavorite = self.favoriteMatches.matches.contains(match)
            
            cell.setDateRedundant(isDateRedundant)
            cell.setFirstCell(isFirstCell)
            cell.setFavorite(isFavorite, animated: false)
            cell.set(match)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let dateModel = self.matches.dateModels[optional: section] else { return nil }
        
        let headerView = DateHeaderView()
        headerView.tag      = section
        headerView.delegate = self
        headerView.set(dateModel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if
            let date    = self.matches.dateModels[optional: indexPath.section],
            let matches = self.matches.matchesByDate[date],
            let match   = matches[optional: indexPath.row]
        {
            self.scheduleDelegate?.scheduleViewController(self, didSelect: match)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let favorite = self.makeFavoriteContextualAction(tableView: tableView, indexPath: indexPath) else {
            return nil
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [favorite])
        
        return configuration
    }
    
    private func makeFavoriteContextualAction(tableView: UITableView, indexPath: IndexPath) -> UIContextualAction? {
        // Make sure the match exists
        // Otherwise return nil
        guard
            let dateModel = self.matches.dateModels[optional: indexPath.section],
            let match     = self.matches.matchesByDate[dateModel]?[optional: indexPath.row],
            let cell      = tableView.cellForRow(at: indexPath) as? MatchTableViewCell else
        {
            return nil
        }
        
        // Configure favorite action
        let favorite: UIContextualAction
        
        // If match is favorite, show remove favorite
        // Otherwise, show add favorite
        if self.favoriteMatches.matches.contains(match) {
            // Remove match from collections
            let handler: UIContextualAction.Handler = { (action, view, completion) in
                self.scheduleDelegate?.scheduleViewController(self, didUnfavorite: match, shouldUnfavorite: { (success) in
                    if success {
                        cell.setFavorite(false, animated: true)
                        self.favoriteMatches.remove(match: match)
                        self.favoriteMatchIds.removeAll(where: { $0 == match.id })
                        self.saveFavoriteMatches()
                        self.displayAlert(text: "REMOVED FROM FAVORITES", image: UIImage(named: "Favorite Remove")!)
                        completion(true)
                    } else {
                        self.displayAlert(text: "FAILED REMOVING FROM FAVORITES", image: UIImage(named: "Favorite Remove")!)
                        completion(true)
                    }
                    
                    // If should display favorites (matches == favoriteMatches), reload tableView
                    if self.shouldDisplayFavorites {
                        self.tableView.reloadData()
                        self.configureMessage()
                    }
                })
            }
            
            favorite                 = UIContextualAction(style: UIContextualAction.Style.normal, title: nil, handler: handler)
            favorite.backgroundColor = UIColor.Flat.Red.alizarin
            favorite.image           = UIImage(named: "Favorite Remove")
        } else {
            // Append match to collections
            let handler: UIContextualAction.Handler = { (action, view, completion) in
                
                self.scheduleDelegate?.scheduleViewController(self, didFavorite: match, shouldFavorite: { (success) in
                    if success {
                        cell.setFavorite(true, animated: true)
                        self.favoriteMatches.append(match)
                        self.favoriteMatchIds.append(match.id)
                        self.saveFavoriteMatches()
                        self.displayAlert(text: "ADDED TO FAVORITES", image: UIImage(named: "Favorite Add")!)
                        completion(true)
                    } else {
                        self.displayAlert(text: "FAILED ADDING TO FAVORITES", image: UIImage(named: "Favorite Add")!)
                        completion(true)
                    }
                })
            }
            
            favorite                 = UIContextualAction(style: UIContextualAction.Style.normal, title: nil, handler: handler)
            favorite.backgroundColor = UIColor.Flat.Red.alizarin
            favorite.image           = UIImage(named: "Favorite Add")
        }
        
        return favorite
    }
}

extension ScheduleViewController: HeaderViewDelegate {
    func headerView(_ headerView: HeaderView, didTap withTag: Int) {
        guard let dateModel = self.matches.dateModels[optional: withTag] else { return }
        
        self.tableView.beginUpdates()
        
        // If already hidden, unhide.
        // Otherwise hide
        if
            let index   = self.hiddenDates.firstIndex(of: dateModel),
            let date    = self.matches.dateModels[optional: withTag],
            let matches = self.matches.matchesByDate[date]
        {
            self.hiddenDates.remove(at: index)
            
            var indexPaths = [IndexPath]()
            for i in 0..<matches.count {
                indexPaths.append(IndexPath(row: i, section: withTag))
            }

            self.tableView.insertRows(at: indexPaths, with: UITableView.RowAnimation.fade)
        } else {
            self.hiddenDates.append(dateModel)
            
            let cellCount  = self.tableView.numberOfRows(inSection: withTag)
            var indexPaths = [IndexPath]()
            for i in 0..<cellCount {
                indexPaths.append(IndexPath(row: i, section: withTag))
            }
            
            self.tableView.deleteRows(at: indexPaths, with: UITableView.RowAnimation.fade)
        }
        
        self.tableView.endUpdates()
    }
}

// MARK: Schedule View Controller - Selectors
extension ScheduleViewController {
    private func displayAlert(text: String, image: UIImage) {
        self.configureAlertLabeledImageViewConstraints(hidden: true)
        self.alertLabeledImageView.layer.removeAllAnimations()
        self.alertLabeledImageView.text = text
        self.alertLabeledImageView.image = image
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 1/3) {
            self.configureAlertLabeledImageViewConstraints(hidden: false)
            self.view.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 1/3, delay: 2, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.configureAlertLabeledImageViewConstraints(hidden: true)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    open func setShouldDisplayFavorites(_ shouldDisplayFavorites: Bool) {
        self.shouldDisplayFavorites = shouldDisplayFavorites
        self.shouldDisplayFavorites = !self.shouldDisplayFavorites
        
        if self.shouldDisplayFavorites {
            self.title = "FAVORITES"
            self.favoriteBarButtonItem.image = UIImage(named: "Calendar Return")
        } else {
            self.title = "SCHEDULE"
            self.favoriteBarButtonItem.image = UIImage(named: "Calendar Favorite")
        }
        
        self.setPresentLabeledImageViewHidden(true)
        self.tableView.reloadData()
        self.scrollToCurrent(animated: false)
        self.configureMessage()
    }
    
    private func setPresentLabeledImageViewHidden(_ hidden: Bool) {
        self.view.layoutIfNeeded()
        self.shouldHidePresentLabeledImageView = hidden
        UIView.animate(withDuration: 1/3) {
            self.configurePresentLabeledImageViewConstraints()
            self.view.layoutIfNeeded()
        }
    }
    
    open func scrollToMatch(_ id: Int) {
        guard let match = self.matches.matches.first(where: { (current) -> Bool in
            return current.id == id
        }) else {
            return
        }
        
        guard
            let beginAtStr = match.begin_at,
            let beginAt    = Date.from(formattedDate: beginAtStr, timezone: TimeZone.current),
            let dateModel  = DateModel(beginAt) else
        {
            return
        }
        
        let section = self.matches.dateModels.firstIndex(where: { (current) -> Bool in
            current == dateModel
        })
        
        if
            let section   = section,
            let dateModel = self.matches.dateModels[optional: section],
            let matches   = self.matches.matchesByDate[dateModel],
            let row       = matches.firstIndex(where: { (match) -> Bool in
                if
                    let beginAtStr = match.begin_at,
                    let beginAt    = Date.from(formattedDate: beginAtStr, timezone: TimeZone.current),
                    let dateModel  = DateModel(beginAt)
                {
                    return !dateModel.date.isInThePast
                } else {
                    return false
                }
            })
        {
            self.tableView.scrollToRow(at: IndexPath(row: row, section: section),
                                       at: UITableView.ScrollPosition.top,
                                       animated: false)
            
            self.tableView.scrollToRow(at: IndexPath(row: row, section: section),
                                       at: UITableView.ScrollPosition.top,
                                       animated: false)
        } else if let section = section {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: section),
                                       at: UITableView.ScrollPosition.top,
                                       animated: false)
            
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: section),
                                       at: UITableView.ScrollPosition.top,
                                       animated: false)
        }
    }
    
    private func saveFavoriteMatches() {
        DispatchQueue(label: "work", qos: DispatchQoS.utility).async {
            self.userDefaults.set(self.favoriteMatchIds, forKey: "favoriteMatches")
        }
    }
    
    /// Call delegate when league button is tapped
    @objc private func handleTapLeaguesBarButtonItem(_ sender: UIBarButtonItem) {
        self.scheduleDelegate?.scheduleViewController(self, didTap: sender)
    }
    
    @objc private func handleTapFavoriteBarButtonItem(_ sender: UIBarButtonItem) {
        self.shouldDisplayFavorites = !self.shouldDisplayFavorites
        
        if self.shouldDisplayFavorites {
            self.setPresentLabeledImageViewHidden(true)
            self.title = "FAVORITES"
            self.favoriteBarButtonItem.image = UIImage(named: "Calendar Return")
        } else {
            self.title = "SCHEDULE"
            self.favoriteBarButtonItem.image = UIImage(named: "Calendar Favorite")
        }
        
        self.tableView.reloadData()
        self.scrollToCurrent(animated: false)
        self.configureMessage()
    }
    
    @objc private func handleTapReloadBarButtonItem(_ sender: UIBarButtonItem) {
        self.getMatches(shouldReload: true)
    }
    
    @objc private func handleTapPresentLabeledImageView(_ sender: UITapGestureRecognizer) {
        self.setPresentLabeledImageViewHidden(false)
        self.scrollToCurrent(animated: true)
    }
    
    private func getMatches(shouldReload: Bool) {
        if isBusyLoading {
            return
        }
        
        if shouldReload {
            self.tableView.bounces = true
        }
        
        self.isBusyLoading = true
        self.loadingIndicator.startAnimating()
        self.tableView.alpha    = 0
        self.imageView.alpha    = 0
        self.messageLabel.alpha = 0
        
        let complete = {
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
                self.tableView.reloadData()
                self.tableView.alpha = 1
                self.scrollToCurrent(animated: false)
                self.configureMessage()
                self.isBusyLoading = false
            }
        }
        
        DispatchQueue(label: "work", qos: DispatchQoS.utility).async {
            // Get favorite matches
            if let matchIds = self.userDefaults.array(forKey: "favoriteMatches") as? [Int] {
                self.favoriteMatchIds = matchIds
            }
            
            // Get matches for league
            self.lolEsportsService.getMatches(shouldReload: shouldReload) { (result) in
                self.handleResult(result)
                complete()
            }
        }
    }
    
    @objc private func getPastMatches() {
        if isBusyLoading {
            return
        }
        
        self.imageView.alpha    = 0
        self.messageLabel.alpha = 0
        self.isBusyLoading = true
        
        let complete = {
            DispatchQueue.main.async {
                self.tableView.cr.endHeaderRefresh()
                self.tableView.reloadData()
                self.configureMessage()
                self.isBusyLoading = false
            }
        }
        
        DispatchQueue(label: "work", qos: DispatchQoS.utility).async {
            // Get favorite matches
            if let matchIds = self.userDefaults.array(forKey: "favoriteMatches") as? [Int] {
                self.favoriteMatchIds = matchIds
            }
            
            self.lolEsportsService.getMorePastMatches { (result) in
                self.handleResult(result)
                complete()
            }
        }
    }
    
    @objc private func getUpcomingMatches() {
        if isBusyLoading {
            return
        }
        
        self.imageView.alpha    = 0
        self.messageLabel.alpha = 0
        self.isBusyLoading = true
        
        let complete = {
            DispatchQueue.main.async {
                self.tableView.cr.endLoadingMore()
                self.tableView.reloadData()
                self.configureMessage()
                self.isBusyLoading = false
            }
        }
        
        DispatchQueue(label: "work", qos: DispatchQoS.utility).async {
            // Get favorite matches
            if let matchIds = self.userDefaults.array(forKey: "favoriteMatches") as? [Int] {
                self.favoriteMatchIds = matchIds
            }
            
            self.lolEsportsService.getMoreUpcomingMatches { (result) in
                self.handleResult(result)
                complete()
            }
        }
    }
    
    private func handleResult(_ result: Result<MatchCollection, RequestError>) {
        switch result {
        case .success(let matchCollection):
            let leagueIds        = self.selectedLeagues.map { $0.id }
            self.allMatches      = matchCollection.makeMatchCollection(leagueIds: leagueIds)
            self.favoriteMatches = matchCollection.makeMatchCollection(matchIds: self.favoriteMatchIds)
        case .failure(let error):
            DispatchQueue.main.async {
                switch error {
                case .noUpcomingMatches:
                    self.tableView.cr.noticeNoMoreData()
                case .upcomingMatchesPageLimitReached:
                    self.tableView.cr.noticeNoMoreData()
                case .pastMatchesPageLimitReached:
                    self.tableView.bounces = false
                default:
                    print(error)
                }
                print(error)
            }
        }
    }
    
    private func configureMessage() {
        if self.matches.matches.isEmpty {
            self.imageView.alpha = 1
            self.messageLabel.alpha = 1
            
            if self.shouldDisplayFavorites {
                self.imageView.image = UIImage(named: "Calendar Favorite")
                self.messageLabel.text = "NO FAVORITE MATCHES SCHEDULED."
            } else {
                self.imageView.image = UIImage(named: "Calendar Empty")
                self.messageLabel.text = "NO MATCHES SCHEDULED FOR SELECTED LEAGUES."
            }
        } else {
            self.imageView.alpha = 0
            self.messageLabel.alpha = 0
        }
    }
    
    private func scrollToCurrent(animated: Bool) {
        if let indexPath = self.indexPathForCurrentMatch {
            self.tableView.scrollToRow(at: indexPath,
                                       at: UITableView.ScrollPosition.top,
                                       animated: animated)
        }
    }
    
    private func scrollToDate(dateModel: DateModel?) {
        let section = self.matches.dateModels.firstIndex(where: { (current) -> Bool in
            if let lhs = dateModel, let rhs = current {
                return lhs.date.isInSameDay(date: rhs.date, timeZone: TimeZone(abbreviation: "UTC")!)
            } else {
                return dateModel == nil && current == nil
            }
        })
        
        if let section = section {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: section),
                                       at: UITableView.ScrollPosition.top,
                                       animated: false)
            
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: section),
                                       at: UITableView.ScrollPosition.top,
                                       animated: false)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard
            let visibleIndexPaths = self.tableView.indexPathsForVisibleRows,
            let maxIndexPathForVisiblePaths = visibleIndexPaths.max(),
            let minIndexPathForVisiblePaths = visibleIndexPaths.min()
        else {
            return
        }

        DispatchQueue(label: "work", qos: DispatchQoS.userInitiated).async {
            // If current match exists, do something
            // Otherwise hide present label
            if
                let indexPathForCurrentMatch = self.indexPathForCurrentMatch
            {
                // If current match is visible, hide present label
                // Otherwise show present label
                if visibleIndexPaths.contains(indexPathForCurrentMatch) {
                    DispatchQueue.main.async {
                        if !self.shouldHidePresentLabeledImageView {
                            self.setPresentLabeledImageViewHidden(true)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        if self.shouldHidePresentLabeledImageView {
                            self.setPresentLabeledImageViewHidden(false)
                        }
                        
                        // If current match is before minimum visible index path, show up arrow
                        // Otherwise use down arrow
                        if indexPathForCurrentMatch < minIndexPathForVisiblePaths {
                            self.presentLabeledImageView.image = UIImage(named: "Up Arrow")
                        } else if indexPathForCurrentMatch > maxIndexPathForVisiblePaths {
                            self.presentLabeledImageView.image = UIImage(named: "Down Arrow")
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    if self.shouldHidePresentLabeledImageView {
                        self.setPresentLabeledImageViewHidden(true)
                    }
                }
            }
        }
    }
}
