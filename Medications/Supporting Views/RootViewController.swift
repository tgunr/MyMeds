//
//  RootViewController.swift
//  MyMeds
//
//  Created by Dave Carlton on 9/21/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

extension UIViewController {

func topMostViewController() -> UIViewController {
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        return self
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController?.topMostViewController()
    }
}

class RootViewController: UIViewController, NavigationDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.moveTo(view: .welcome) //Which can always be changed
    }

    //The Moving Function
    func moveTo(view: RootViews, presentation: UIModalPresentationStyle = .fullScreen, transition: UIModalTransitionStyle = .crossDissolve) {
        let newScene = self.returnSwiftUIView(type: view)
        newScene.modalPresentationStyle = presentation
        newScene.modalTransitionStyle = transition

        //Top View Controller
        let top = self.topMostViewController()

        top.present(newScene, animated: true)
    }
}

protocol NavigationDelegate {
    func moveTo(view: RootViews, presentation: UIModalPresentationStyle, transition: UIModalTransitionStyle)
}

extension NavigationDelegate {
    func moveTo(view: RootViews) {
        self.moveTo(view: view, presentation: .fullScreen, transition: .crossDissolve)
    }

    func moveTo(view: RootViews, presentation: UIModalPresentationStyle) {
        self.moveTo(view: view, presentation: presentation, transition: .crossDissolve)
    }

    func moveTo(view: RootViews, transition: UIModalTransitionStyle) {
        self.moveTo(view: view, presentation: .fullScreen, transition: transition)
    }
}



