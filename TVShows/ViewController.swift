//
//  ViewController.swift
//  TVShows
//
//  Created by Esteban Chavarria on 26/6/22.
//

import UIKit
import Resolver

class ViewController: UIViewController {
    
    @Injected var service: TVShowsServicing

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }


}

