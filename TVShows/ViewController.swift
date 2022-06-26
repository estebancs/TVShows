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
        Task(priority: .background) {
            let result = await service.show()
            switch result {
            case .success(let movieResponse):
                print("movieResponse: \(movieResponse)")
            case .failure(let error):
                print("error: \(error.errorMessage)")
            }
        }
    }


}

