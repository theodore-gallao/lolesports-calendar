//
//  MainSplitViewController.swift
//  lolesports-calendar
//
//  Created by Theodore Gallao on 4/2/19.
//  Copyright © 2019 Theodore Gallao. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

// MARK: Main View Controller - Declaration, Variables & Initializers
/// Presents the league schedule and league picker
class MainViewController: UIViewController {
    /********** Services **********/
    private let lolEsportsService: LolEsportsService
    private let userDefaults: UserDefaults
    
    /********** Data **********/
    private let leagueCollections: [LeagueCollection]
    private var selectedLeagues: [League]
    
    /********** Flags **********/
    private var isLeagueFilterHidden = true
    
    /********** View Controllers **********/
    let leagueFilterViewController: LeagueFilterViewController
    let scheduleViewController: ScheduleViewController
    
    private lazy var leagueFilterNavigationController: UINavigationController = {
        let navigationController = UINavigationController(rootViewController: self.leagueFilterViewController)
        navigationController.view.backgroundColor = UIColor.white
        navigationController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return navigationController
    }()
    
    private lazy var scheduleNavigationController: UINavigationController = {
        let navigationController = UINavigationController(rootViewController: self.scheduleViewController)
        navigationController.view.backgroundColor = UIColor.white
        navigationController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return navigationController
    }()
    
    /********** Views **********/
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Flat.White.silver
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let dimView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor.black
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    /********** Constraints **********/
    private var leagueFilterViewConstraints = [NSLayoutConstraint]()
    private var scheduleViewConstraints     = [NSLayoutConstraint]()
    private var separatorViewConstraints    = [NSLayoutConstraint]()
    private var dimViewConstraints          = [NSLayoutConstraint]()
    
    private var leftEdgePanAmount: CGFloat = 0
    private var leftEdgePanValue: CGFloat = 0
    
    private var leagueFilterPanAmount: CGFloat = 0
    private var leagueFilterPanValue: CGFloat = 0
    
    /********** Gestures **********/
    private lazy var panLeftEdge: UIScreenEdgePanGestureRecognizer = {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.handlePanLeftEdge(_:)))
        gesture.edges = [UIRectEdge.left]
        gesture.delegate = self
        
        return gesture
    }()
    
    private lazy var tapDimView: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTapDimView(_:)))
        gesture.delegate = self
        
        return gesture
    }()
    
    private lazy var panLeagueFilter: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanLeagueFilter(_:)))
        gesture.delegate = self
        
        return gesture
    }()
    
    private lazy var panDimView: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanLeagueFilter(_:)))
        gesture.delegate = self
        
        return gesture
    }()
    
    /********** Initializers **********/
    init(leagueCollections: [LeagueCollection],
         selectedLeagues:   [League],
         lolEsportsService: LolEsportsService,
         userDefaults:      UserDefaults = .standard)
    {
        self.leagueCollections  = leagueCollections
        self.selectedLeagues    = selectedLeagues
        self.lolEsportsService  = lolEsportsService
        self.userDefaults       = userDefaults
        
        self.leagueFilterViewController = LeagueFilterViewController()
        self.scheduleViewController     = ScheduleViewController(selectedLeagues:   selectedLeagues,
                                                                 lolEsportsService: lolEsportsService)
        
        super.init(nibName: nil, bundle: nil)
        
        self.leagueFilterViewController.delegate     = self
        self.leagueFilterViewController.dataSource   = self
        self.scheduleViewController.scheduleDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Main View Controller - View Controller States
extension MainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addChild(self.leagueFilterNavigationController)
        self.addChild(self.scheduleNavigationController)
        
        self.view.addSubview(self.scheduleNavigationController.view)
        self.view.addSubview(self.dimView)
        self.view.addSubview(self.leagueFilterNavigationController.view)
        self.view.addSubview(self.separatorView)
        
        self.view.addGestureRecognizer(self.panLeftEdge)
        self.dimView.addGestureRecognizer(self.tapDimView)
        self.dimView.addGestureRecognizer(self.panDimView)
        self.leagueFilterNavigationController.view.addGestureRecognizer(self.panLeagueFilter)
        
        self.configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationController = self.navigationController {
            navigationController.setNavigationBarHidden(true, animated: animated)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

// MARK: Main View Controller - Layout & Configurations
extension MainViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.configureLayout()
    }
    
    private func configureLayout() {
        self.configureGestures()
        self.configureLayers()
        self.configureButtons()
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.deactivate(self.leagueFilterViewConstraints)
        NSLayoutConstraint.deactivate(self.scheduleViewConstraints)
        NSLayoutConstraint.deactivate(self.separatorViewConstraints)
        NSLayoutConstraint.deactivate(self.dimViewConstraints)
        
        // If compact, show league picker xor schedule
        // Otherwise, show league picker and schedule
        if self.traitCollection.horizontalSizeClass == .compact {
            // If league picker is hidden, show only schedule
            // Otherwise, show only league picker
            if !self.isLeagueFilterHidden {
                self.leagueFilterViewConstraints = [
                    self.leagueFilterNavigationController.view.topAnchor
                        .constraint(equalTo: self.view.topAnchor, constant: 0),
                    self.leagueFilterNavigationController.view.leftAnchor
                        .constraint(equalTo: self.view.leftAnchor, constant: -self.leagueFilterPanAmount),
                    self.leagueFilterNavigationController.view.widthAnchor
                        .constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
                    self.leagueFilterNavigationController.view.bottomAnchor
                        .constraint(equalTo: self.view.bottomAnchor, constant: 0)
                ]
                
                self.scheduleViewConstraints = [
                    self.scheduleNavigationController.view.topAnchor
                        .constraint(equalTo: self.view.topAnchor, constant: 0),
                    self.scheduleNavigationController.view.leftAnchor
                        .constraint(equalTo: self.view.leftAnchor, constant: 0),
                    self.scheduleNavigationController.view.widthAnchor
                        .constraint(equalTo: self.view.widthAnchor, multiplier: 1),
                    self.scheduleNavigationController.view.bottomAnchor
                        .constraint(equalTo: self.view.bottomAnchor, constant: 0)
                ]
            } else {
                self.leagueFilterViewConstraints = [
                    self.leagueFilterNavigationController.view.topAnchor
                        .constraint(equalTo: self.view.topAnchor, constant: 0),
                    self.leagueFilterNavigationController.view.rightAnchor
                        .constraint(equalTo: self.view.leftAnchor, constant: self.leftEdgePanAmount),
                    self.leagueFilterNavigationController.view.widthAnchor
                        .constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
                    self.leagueFilterNavigationController.view.bottomAnchor
                        .constraint(equalTo: self.view.bottomAnchor, constant: 0)
                ]
                
                self.scheduleViewConstraints = [
                    self.scheduleNavigationController.view.topAnchor
                        .constraint(equalTo: self.view.topAnchor, constant: 0),
                    self.scheduleNavigationController.view.leftAnchor
                        .constraint(equalTo: self.view.leftAnchor, constant: 0),
                    self.scheduleNavigationController.view.rightAnchor
                        .constraint(equalTo: self.view.rightAnchor, constant: 0),
                    self.scheduleNavigationController.view.bottomAnchor
                        .constraint(equalTo: self.view.bottomAnchor, constant: 0)
                ]
            }
            
            self.separatorViewConstraints = [
                self.separatorView.topAnchor
                    .constraint(equalTo: self.leagueFilterNavigationController.navigationBar.bottomAnchor, constant: 0),
                self.separatorView.widthAnchor
                    .constraint(equalToConstant: 0),
                self.separatorView.centerXAnchor
                    .constraint(equalTo: self.leagueFilterNavigationController.view.rightAnchor, constant: 0),
                self.separatorView.bottomAnchor
                    .constraint(equalTo: self.leagueFilterNavigationController.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
            ]
        } else {
            self.leagueFilterViewConstraints = [
                self.leagueFilterNavigationController.view.topAnchor
                    .constraint(equalTo: self.view.topAnchor, constant: 0),
                self.leagueFilterNavigationController.view.leftAnchor
                    .constraint(equalTo: self.view.leftAnchor, constant: 0),
                self.leagueFilterNavigationController.view.widthAnchor
                    .constraint(equalTo: self.view.widthAnchor, multiplier: 0.4),
                self.leagueFilterNavigationController.view.bottomAnchor
                    .constraint(equalTo: self.view.bottomAnchor, constant: 0)
            ]
            
            self.scheduleViewConstraints = [
                self.scheduleNavigationController.view.topAnchor
                    .constraint(equalTo: self.view.topAnchor, constant: 0),
                self.scheduleNavigationController.view.leftAnchor
                    .constraint(equalTo: self.leagueFilterNavigationController.view.rightAnchor, constant: 0),
                self.scheduleNavigationController.view.rightAnchor
                    .constraint(equalTo: self.view.rightAnchor, constant: 0),
                self.scheduleNavigationController.view.bottomAnchor
                    .constraint(equalTo: self.view.bottomAnchor, constant: 0)
            ]
            
            self.separatorViewConstraints = [
                self.separatorView.topAnchor
                    .constraint(equalTo: self.leagueFilterNavigationController.navigationBar.bottomAnchor, constant: 0),
                self.separatorView.widthAnchor
                    .constraint(equalToConstant: 1),
                self.separatorView.centerXAnchor
                    .constraint(equalTo: self.leagueFilterNavigationController.view.rightAnchor, constant: 0),
                self.separatorView.bottomAnchor
                    .constraint(equalTo: self.leagueFilterNavigationController.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
            ]
        }
        
        self.dimViewConstraints = [
            self.dimView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            self.dimView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            self.dimView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            self.dimView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        ]
        
        NSLayoutConstraint.activate(self.leagueFilterViewConstraints)
        NSLayoutConstraint.activate(self.scheduleViewConstraints)
        NSLayoutConstraint.activate(self.separatorViewConstraints)
        NSLayoutConstraint.activate(self.dimViewConstraints)
    }
    
    private func configureButtons() {
        if self.traitCollection.horizontalSizeClass == .compact {
            self.leagueFilterViewController.setDoneButtonHidden(false)
            self.scheduleViewController.setLeagueButtonHidden(false)
        } else {
            self.leagueFilterViewController.setDoneButtonHidden(true)
            self.scheduleViewController.setLeagueButtonHidden(true)
        }
    }
    
    private func configureGestures() {
        // Only enable left pan when compact
        // Otherwise, disable the gesture
        if self.traitCollection.horizontalSizeClass == .compact {
            self.panLeftEdge.isEnabled = true
        } else {
            self.panLeftEdge.isEnabled = false
        }
    }
    
    private func configureLayers() {
        // Perform animations and layer manipulations when compact
        // Otherwise revert to base later for regular
        if self.traitCollection.horizontalSizeClass == .compact {
            
            // Perform left edge pan manipulations only when hidden
            // Otherwise perform league filter pan manipulations
            if self.isLeagueFilterHidden {
                self.leagueFilterNavigationController.view.layer.maskedCorners = [CACornerMask.layerMaxXMinYCorner,
                                                                                  CACornerMask.layerMaxXMaxYCorner]
                self.leagueFilterNavigationController.view.layer.cornerRadius = 16
                self.leagueFilterNavigationController.view.layer.masksToBounds = true
                
                let panValue = self.leftEdgePanValue
                let scaleValue = 1 - (panValue * 0.1)
                self.scheduleNavigationController.view.transform = CGAffineTransform(scaleX: scaleValue, y: scaleValue)
                
                let cornerValue = 16 * self.leftEdgePanValue
                self.leagueFilterNavigationController.view.layer.maskedCorners = [CACornerMask.layerMaxXMinYCorner,
                                                                                  CACornerMask.layerMaxXMaxYCorner]
                self.scheduleNavigationController.view.layer.cornerRadius = cornerValue
                self.scheduleNavigationController.view.layer.masksToBounds = true
                
                let alphaValue = panValue * 0.5
                self.dimView.alpha = alphaValue
            } else {
                self.leagueFilterNavigationController.view.layer.maskedCorners = [CACornerMask.layerMaxXMinYCorner,
                                                                                  CACornerMask.layerMaxXMaxYCorner]
                self.leagueFilterNavigationController.view.layer.cornerRadius = 16
                self.leagueFilterNavigationController.view.layer.masksToBounds = true
                
                let panValue = self.leagueFilterPanValue
                let scaleValue = 0.9 + (0.1 *  panValue)
                
                self.scheduleNavigationController.view.transform = CGAffineTransform(scaleX: scaleValue, y: scaleValue)
                
                let cornerValue = 16 - (16 * panValue)
                self.leagueFilterNavigationController.view.layer.maskedCorners = [CACornerMask.layerMaxXMinYCorner,
                                                                                  CACornerMask.layerMaxXMaxYCorner]
                self.scheduleNavigationController.view.layer.cornerRadius = cornerValue
                self.scheduleNavigationController.view.layer.masksToBounds = true
                
                let alphaValue = 0.5 - (0.5 * panValue)
                self.dimView.alpha = alphaValue
            }
        } else {
            self.leagueFilterNavigationController.view.layer.cornerRadius = 0
            self.scheduleNavigationController.view.layer.cornerRadius = 0
            self.scheduleNavigationController.view.transform = CGAffineTransform.identity
            self.dimView.alpha = 0
        }
    }
}

// MARK: Main View Controller - Setters
extension MainViewController {
    private func setLeagueFilterHidden(_ hidden: Bool) {
        self.isLeagueFilterHidden = hidden
        self.leftEdgePanValue = hidden ? 0 : 1
        self.leagueFilterPanValue = hidden ? 1 : 0
        
        UIView.animate(withDuration: 1/3, animations: {
            self.configureLayout()
            self.view.layoutSubviews()
        }) { (finished) in
            if finished {
                self.tapDimView.isEnabled      = !hidden
                self.panLeftEdge.isEnabled     = hidden
                self.panLeagueFilter.isEnabled = !hidden
                self.panDimView.isEnabled      = !hidden
            }
        }
    }
    
    private func set(_ selectedLeagues: [League]) {
        self.selectedLeagues = selectedLeagues
        self.scheduleViewController.set(selectedLeagues)
        self.saveSelectedLeagues()
    }
    
    private func saveSelectedLeagues() {
        DispatchQueue(label: "work", qos: DispatchQoS.utility).async {
            let leagueIds = self.selectedLeagues.map { $0.id }
            self.userDefaults.set(leagueIds, forKey: "selectedLeagues")
        }
    }
}

// MARK: Main View Controller - League Filter View Controller (Delegate & Data Source)
extension MainViewController: LeagueFilterViewControllerDataSource, LeagueFilterViewControllerDelegate {
    func leagueFilterViewControllerNumberOfLeagueCollections(_ leagueFilterViewController: LeagueFilterViewController) -> Int {
        return self.leagueCollections.count
    }
    
    func leagueFilterViewControllerSelectedLeagues(_ leagueFilterViewController: LeagueFilterViewController) -> [League] {
        return self.selectedLeagues
    }
    
    func leagueFilterViewController(_ leagueFilterViewController: LeagueFilterViewController, leagueCollection forSection: Int) -> LeagueCollection {
        return self.leagueCollections[forSection]
    }
    
    func leagueFilterViewController(_ leagueFilterViewController: LeagueFilterViewController, didSelect league: League) {
        self.selectedLeagues.append(league)
        
        self.set(self.selectedLeagues)
    }
    
    func leagueFilterViewController(_ leagueFilterViewController: LeagueFilterViewController, didDeselect league: League) {
        self.selectedLeagues.removeAll(where: { $0 == league })
        
        self.set(self.selectedLeagues)
    }
    
    func leagueFilterViewController(_ leagueFilterViewController: LeagueFilterViewController, didTapDone button: UIBarButtonItem) {
        self.setLeagueFilterHidden(true)
    }
}

// Main View Controller: Schedule View Controller (Delegate)
extension MainViewController: ScheduleViewControllerDelegate {
    func scheduleViewController(_ scheduleViewController: ScheduleViewController, didSelect serieId: Int) {
        
    }
    
    func scheduleViewController(_ scheduleViewController: ScheduleViewController, didSelect match: Match) {
        
    }
    
    func scheduleViewController(_ scheduleViewController: ScheduleViewController, didTap leaguesButton: UIBarButtonItem) {
        self.setLeagueFilterHidden(false)
    }
    
    func scheduleViewController(_ scheduleViewController: ScheduleViewController, didFavorite match: Match, shouldFavorite: @escaping (Bool) -> Void) {
        // If permissions are granted, add notificaation and complete true
        let successBlock = {
            // Add a notification only when date exists
            // Add a notification 30 minutes before a match and when a match starts
            if
                let beginAtStr = match.begin_at,
                let beginAt = Date.from(formattedDate: beginAtStr, timezone: TimeZone.current),
                beginAt > Date()
            {
                let content = UNMutableNotificationContent()
                content.title = "\(match.team0FullNameText) vs \(match.team1FullNameText)"
                content.body  = "\(match.leagueText) match is starting soon!"
                content.sound = UNNotificationSound.default
                
                let timeInterval = beginAt.timeIntervalSinceNow
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
                let request = UNNotificationRequest(identifier: "\(match.id)", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            } else {
                print(match.id, " - notification not added because it is in the past.")
            }
            
            shouldFavorite(true)
        }
        
        // Display alert and complete false
        let failBlock = {
            let alertController = UIAlertController(title: "Notifications Are Disabled", message: "Enable notifications in your settings.\nSettings > Schedule", preferredStyle: UIAlertController.Style.alert)
            
            let alertAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { (action) in
                alertController.dismiss(animated: true, completion: nil)
                shouldFavorite(false)
            })
            
            alertController.addAction(alertAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                if settings.alertSetting == .enabled && settings.soundSetting == .enabled {
                    // Alert and sound settings are granted
                    // Do success block
                    successBlock()
                } else {
                    // Alert and sound settings are not granted
                    // Display alert showing that permissions are not granted
                    // complete false
                    failBlock()
                }
            }
        }
    }
    
    func scheduleViewController(_ scheduleViewController: ScheduleViewController, didUnfavorite match: Match, shouldUnfavorite: @escaping (Bool) -> Void) {
        // Success, remove notification and complete true
        let successBlock = {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(match.id)"])
            shouldUnfavorite(true)
        }
        
        // Fail, display alert and complete false
        let failBlock = {
            let alertController = UIAlertController(title: "Notifications Are Disabled", message: "Enable notifications in your settings.\nSettings > Schedule", preferredStyle: UIAlertController.Style.alert)
            
            let alertAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { (action) in
                alertController.dismiss(animated: true, completion: nil)
                shouldUnfavorite(false)
            })
            
            alertController.addAction(alertAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                if settings.alertSetting == .enabled && settings.soundSetting == .enabled {
                    // Alert and sound settings are granted and remove notification
                    successBlock()
                } else {
                    // Alert and sound settings are not granted
                    // Display alert showing that permissions are not granted
                    failBlock()
                }
            }
        }
    }
}

// MARK: Main View Controller - Selectors & Gestures
extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.panDimView {
            return
                otherGestureRecognizer == self.panLeftEdge ||
                otherGestureRecognizer == self.panLeagueFilter ||
                otherGestureRecognizer == self.tapDimView
        } else if gestureRecognizer == self.panLeftEdge {
            return
                otherGestureRecognizer == self.panDimView ||
                otherGestureRecognizer == self.panLeagueFilter ||
                otherGestureRecognizer == self.tapDimView
        } else if gestureRecognizer == self.panLeagueFilter {
            return
                otherGestureRecognizer == self.panDimView ||
                otherGestureRecognizer == self.panLeftEdge ||
                otherGestureRecognizer == self.tapDimView
        } else if gestureRecognizer == self.tapDimView {
            return
                otherGestureRecognizer == self.panDimView ||
                otherGestureRecognizer == self.panLeftEdge ||
                otherGestureRecognizer == self.panLeagueFilter
        } else  {
             return false
        }
    }
    
    @objc private func handlePanLeftEdge(_ sender: UIScreenEdgePanGestureRecognizer) {
        let xTranslation = sender.translation(in: self.view).x
        let xVelocity    = sender.velocity(in: self.view).x
        let viewWidth    = self.leagueFilterNavigationController.view.frame.width
        let value        = xTranslation + (xVelocity / 4)
        let threshold    = viewWidth / 2
        let panValue     = min(1, max(0, xTranslation / viewWidth))
        
        // If league filter is hidden, left edge swipe allows it to show
        // Otherwise do nothing and ignore this
        if self.isLeagueFilterHidden {
            self.leftEdgePanAmount = min(xTranslation, viewWidth)
            self.leftEdgePanValue = panValue
            
            self.configureLayout()
            self.view.layoutIfNeeded()
            
            // If ended, check values to determin state
            if sender.state == .ended {
                // If pan value > threshold, show league filter and disable this gesture
                if value > threshold {
                    self.leftEdgePanAmount = 0
                    sender.isEnabled = false
                    self.setLeagueFilterHidden(false)
                } else {
                    self.leftEdgePanAmount = 0
                    sender.isEnabled = true
                    self.setLeagueFilterHidden(true)
                }
            }
        }
    }
    
    @objc private func handleTapDimView(_ sender: UITapGestureRecognizer) {
        self.setLeagueFilterHidden(true)
    }
    
    @objc private func handlePanLeagueFilter(_ sender: UIPanGestureRecognizer) {
        let xTranslation = sender.translation(in: self.leagueFilterNavigationController.view).x
        let xVelocity    = sender.velocity(in: self.leagueFilterNavigationController.view).x
        let viewWidth    = -self.leagueFilterNavigationController.view.frame.width
        let value        = xTranslation + (xVelocity / 4)
        let threshold    = viewWidth / 2
        let panValue     = max(0, min(1, xTranslation / viewWidth))
        
        // If league filter is not hidden, pan gesture allows it to start hiding
        // Otherwise do nothing and ignore this
        if !self.isLeagueFilterHidden {
            self.leagueFilterPanAmount = abs(max(viewWidth, min(0, xTranslation)))
            self.leagueFilterPanValue = panValue
            
            self.configureLayout()
            self.view.layoutIfNeeded()
            
            // If ended, check values to determin state
            if sender.state == .ended {
                // If pan value < threshold, hide league filter and disable this gesture
                if value < threshold {
                    self.leagueFilterPanAmount = 0
                    sender.isEnabled = false
                    self.setLeagueFilterHidden(true)
                } else {
                    self.leagueFilterPanAmount = 0
                    sender.isEnabled = true
                    self.setLeagueFilterHidden(false)
                }
            }
        }
    }
}
