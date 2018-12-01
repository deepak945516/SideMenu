//
//  Router.swift
//  SideMenu
//
//  Created by Deepak Kumar on 29/11/18.
//  Copyright © 2018 deepak. All rights reserved.
//

import Foundation
import UIKit

class Router: NSObject {
    func getViewController(storyboardName: String, viewControllerID: String) -> UIViewController {
       let viewController = UIStoryboard.init(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: viewControllerID)
        return viewController
    }

    func makeRoot(storyboardname: String, viewControllerID: String) {
        if let window = UIApplication.shared.delegate?.window as? UIWindow {
            let viewController = getViewController(storyboardName: storyboardname, viewControllerID: viewControllerID)
            let navigationController = UINavigationController.init(rootViewController: viewController)
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }
}
