//
//  AppDelegate+Injection.swift
//  TVShows
//
//  Created by Esteban Chavarria on 26/6/22.
//

import Foundation

import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register { TVShowsService() }
            .implements(TVShowsServicing.self)
    }
}
