//
//  Coordinator.swift
//  TVShows
//
//  Created by Esteban Chavarria on 26/6/22.
//

import UIKit

// Base Coordinator, cannot be a parent or a child.
// Use when you definitevely know what will always be on the screen but you are created by a view model
// (ex: an embedded view controller)
public protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }

    func start()
}

public extension Coordinator {
    func release(coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
