//
//  RootTabBarCoordinator.swift
//  TVShows
//
//  Created by Esteban Chavarria on 26/6/22.
//

import UIKit
import Combine

final class RootTabBarCoordinator: NSObject, Coordinator {

    var navigationController: UINavigationController

    var childCoordinators: [Coordinator] = []
    private var cancellables = Set<AnyCancellable>()

    required init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let rootTabBarViewController = UITabBarController()
        
        let tvShowsViewController = ViewController()
        tvShowsViewController.tabBarItem.title = "TV Shows"
        
        let favoritesViewController = ViewController()
        favoritesViewController.tabBarItem.title = "Favorites"
        
        let settingsViewController = ViewController()
        settingsViewController.tabBarItem.title = "Settings"
        
        rootTabBarViewController.viewControllers = [tvShowsViewController,favoritesViewController,settingsViewController]
        navigationController.setViewControllers([rootTabBarViewController], animated: false)
    }
}

