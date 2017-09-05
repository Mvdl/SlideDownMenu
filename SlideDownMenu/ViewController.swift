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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        slideDownView.backgroundColor = .blue
        slideDownView.updateUI()
    }
    @IBAction func didTapButton(_ sender: Any) {
        slideDownView.contentView.backgroundColor = .yellow
        slideDownView.updateUI()
    }
}

