//
//  AppCoordinator.swift
//  TVShows
//
//  Created by Esteban Chavarria on 26/6/22.
//

import UIKit

protocol ApplicationStarter: AnyObject {
    func startApp()
}

final class AppCoordinator {

    // This will allow us to route to an onboarding flow in the future in the app coordinator
    var navigationController = UINavigationController()

    private(set) var childCoordinators = [Coordinator]()

    func start() {
        self.route(to: .home)
    }
}

extension AppCoordinator: ApplicationStarter {
    func startApp() {
        route(to: .home)
    }
}

// MARK: - Routing

extension AppCoordinator {
    enum Route {
        case home
    }

    func route(to destination: Route) {
        switch destination {
        case .home:
            makeHome()
        }
    }
}

// MARK: - Screen Factories

private extension AppCoordinator {

    func makeHome() {
        let rootTabBarCoodinator = RootTabBarCoordinator(with: navigationController)
        rootTabBarCoodinator.start()

        childCoordinators.append(rootTabBarCoodinator)
    }
}

