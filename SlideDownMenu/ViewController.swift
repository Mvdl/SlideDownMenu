//
//  ViewController.swift
//  SlideDownMenu
//
//  Created by Matthijs on 01/09/2017.
//  Copyright © 2017 mvdlinden. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func didPanView(_ sender: UIPanGestureRecognizer) {
        //print ("view is panned")
        
        if panGestureRecognizer.state == .began || panGestureRecognizer.state == .changed {

            //move view in any direction
            /*
            let translation = panGestureRecognizer.translation(in: self.view)
            panGestureRecognizer.view!.center = CGPoint(x: panGestureRecognizer.view!.center.x + translation.x, y: panGestureRecognizer.view!.center.y + translation.y)
            panGestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
            */
            
            //only vertical panning
            let velocity = panGestureRecognizer.velocity(in: panGestureRecognizer.view)
            let translation = panGestureRecognizer.translation(in: self.view)
            
            
            if velocity.y > 0 {
                // user dragged down
                panGestureRecognizer.view!.center = CGPoint(x: panGestureRecognizer.view!.center.x, y: panGestureRecognizer.view!.center.y - translation.y)
                print("down")
            }
            else if velocity.y < 0{
                // user dragged towards up
                panGestureRecognizer.view!.center = CGPoint(x: panGestureRecognizer.view!.center.x, y: panGestureRecognizer.view!.center.y + translation.y)
                print("up")
            }
            panGestureRecognizer.setTranslation(CGPoint.zero, in: self.view)

            
        }
    }
    


}

