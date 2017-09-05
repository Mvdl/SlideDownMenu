//
//  ViewController.swift
//  SlideDownMenu
//
//  Created by Matthijs on 01/09/2017.
//  Copyright © 2017 mvdlinden. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var slideDownView: SlideDownView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menuContentViewController = MenuContentViewController()
        slideDownView.contentView.addSubview(menuContentViewController.view)
        menuContentViewController.view.frame = slideDownView.contentView.bounds
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        slideDownView.updateUI()
    }
}

