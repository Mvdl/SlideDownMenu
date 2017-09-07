//
//  ViewController.swift
//  SlideDownMenu
//
//  Created by Matthijs on 01/09/2017.
//  Copyright © 2017 mvdlinden. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var slideDownView: SlideDownView!
    @IBOutlet weak var slideDownViewTopConstraint: NSLayoutConstraint!
    
    var menuContentViewController: MenuContentViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuContentViewController = MenuContentViewController()
        slideDownView.contentView.addSubview(menuContentViewController.view)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        menuContentViewController.view.frame = slideDownView.contentView.bounds
        slideDownView.slideDownViewEndPosition = slideDownViewTopConstraint.constant
        slideDownView.updateUI()
    }
}

