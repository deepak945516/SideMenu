//
//  ContainerViewController.swift
//  SideMenu
//
//  Created by Deepak Kumar on 25/09/18.
//  Copyright © 2018 deepak. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

protocol ContainerViewDelegate: class {
    func sideMenuButtonTapped()
}

class ContainerViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var sideMenuContainerView: UIView!
    @IBOutlet weak var viewContainerView: UIView!
    @IBOutlet weak var containerViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideMenuTrailingConstraint: NSLayoutConstraint!
    private var sideMenuOffset: CGFloat = 0 // it will store width of side menu in initial Setup
    private var runningAnimators = [UIViewPropertyAnimator]()
    private var animationProgress = [CGFloat]()
    var animatorDuration = 0.5
    var router = Router() // cutome class to navigation viewControllers

    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.7
        return view
    }()

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSetup()
        layoutSetup()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isSideMenuActive {
            animateTransitionIfNeeded(isOpen: isSideMenuActive, duration: animatorDuration)
        }
    }

    override func viewWillAppear(_ animated: Bool) {

    }

    // MARK: - Private Methods
    private func initialSetup() {
        sideMenuTrailingConstraint.constant = sideMenuTrailingConstant
        sideMenuOffset = screenWidth - sideMenuTrailingConstant
        guard let homeViewController = router.getViewController(storyboardName: "Main", viewControllerID: "HomeViewController") as? HomeViewController else { return }
        homeViewController.delegate = self
        addChildToParentViewController(viewController: homeViewController)
        SideMenuViewController.delegate = self//check
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(sideViewPanned(recognizer:)))
        viewContainerView.addGestureRecognizer(panRecognizer)
    }

    private func layoutSetup() {
        // Add Overlay View To Side Menu
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        sideMenuContainerView.addSubview(overlayView)
        overlayView.leadingAnchor.constraint(equalTo: sideMenuContainerView.leadingAnchor).isActive = true
        overlayView.trailingAnchor.constraint(equalTo: sideMenuContainerView.trailingAnchor).isActive = true
        overlayView.topAnchor.constraint(equalTo: sideMenuContainerView.topAnchor).isActive = true
        overlayView.bottomAnchor.constraint(equalTo: sideMenuContainerView.bottomAnchor).isActive = true
    }

    private func addChildToParentViewController(viewController: UIViewController) {
        viewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        viewController.view.frame = viewContainerView.bounds
        addChild(viewController)
        viewContainerView.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }

    // Show hide container view
    private func showContainerView() {
        self.containerViewLeadingConstraint.constant = self.sideMenuOffset
        self.containerViewTrailingConstraint.constant = -self.containerViewLeadingConstraint.constant
        self.overlayView.alpha = 0
    }

    private func hideContainerView() {
        self.containerViewLeadingConstraint.constant = 0
        self.containerViewTrailingConstraint.constant = 0
        self.overlayView.alpha = 0.7
    }

    /// Animates the transition, if the animation is not already running.
    func animateTransitionIfNeeded(isOpen: Bool, duration: TimeInterval) {
        // ensure that the animators array is empty (which implies new animations need to be created)
        guard runningAnimators.isEmpty else { return }
        // an animator for the transition
        let transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            switch isOpen {
            case false:
                self.showContainerView()
            case true:
                self.hideContainerView()
            }
            self.view.layoutIfNeeded()
        })

        // the transition completion block
        transitionAnimator.addCompletion { position in
            // update the state
            switch position {
            case .start:
                isSideMenuActive = isOpen
            case .end:
                isSideMenuActive = !isOpen
            case .current:
                ()
            }

            //manually reset the constraint positions
            switch isSideMenuActive {
            case true:
                self.showContainerView()
            case false:
                self.hideContainerView()
            }
            // remove all running animators
            self.runningAnimators.removeAll()
        }
        // start all animators
        transitionAnimator.startAnimation()
        // keep track of all running animators
        runningAnimators.append(transitionAnimator)
    }

    // swipe right to show the side menu, and left to hide side menu with animation
    @objc private func sideViewPanned(recognizer: UIPanGestureRecognizer) {
        let velocity = recognizer.velocity(in: viewContainerView)
        if abs(velocity.x) > abs(velocity.y) {
            switch recognizer.state {
            case .began:
                animateTransitionIfNeeded(isOpen: isSideMenuActive, duration: animatorDuration)
                runningAnimators.forEach { $0.pauseAnimation() }
                animationProgress = runningAnimators.map { $0.fractionComplete }
            case .changed:
                let translation = recognizer.translation(in: viewContainerView)
                var fraction = translation.x / sideMenuOffset
                if isSideMenuActive == false { fraction *= 1 }
                if isSideMenuActive == true { fraction *= -1 }
                for (index, animator) in runningAnimators.enumerated() {
                    animator.fractionComplete = fraction + animationProgress[index]
                }
            case .ended:
                let xVelocity = recognizer.velocity(in: viewContainerView).x
                let shouldClose = xVelocity > 0
                if xVelocity == 0 {
                    runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
                    break
                }
                switch isSideMenuActive {
                case false:
                    if abs(velocity.x) > 0 {
                        if !shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                        if shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                    }
                case true:
                    if shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                    if !shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                }
                runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
            default:
                break
            }
        }
    }

    private func hideSideMenu() {
        animateTransitionIfNeeded(isOpen: true, duration: animatorDuration)
    }
}

// view will be navigate on the selection of side menu item
// MARK: - SideMenuDelegate
extension ContainerViewController: SideMenuDelegate {
    func menuItemSelected(at indexPath: IndexPath) {
        hideSideMenu()
        if indexPath == IndexPath(row: 0, section: 0) {
            //Home
            let homeViewController = router.getViewController(storyboardName: "Main", viewControllerID: "HomeViewController") as? HomeViewController
            homeViewController?.delegate = self
            addChildToParentViewController(viewController: homeViewController!)
        } else if indexPath == IndexPath(row: 1, section: 0) {
            //profile
            if let profileViewController = router.getViewController(storyboardName: "Main", viewControllerID: "ProfileViewController") as? ProfileViewController {
                profileViewController.delegate = self
                addChildToParentViewController(viewController: profileViewController)
            }
        } else if indexPath == IndexPath(row: 2, section: 0) {
            //about
            if let settingViewController = router.getViewController(storyboardName: "Main", viewControllerID: "SettingsViewController") as? SettingsViewController {
                settingViewController.delegate = self
                addChildToParentViewController(viewController: settingViewController)
            }
        }
    }
}

// Side menu will be become visible on the tap of side menu button
// MARK: - ContainerViewDelegate
extension ContainerViewController: ContainerViewDelegate {
    func sideMenuButtonTapped() {
        animateTransitionIfNeeded(isOpen: isSideMenuActive, duration: animatorDuration)
    }
}
