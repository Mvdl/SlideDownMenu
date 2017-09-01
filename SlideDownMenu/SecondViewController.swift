//
//  SecondViewController.swift
//  SlideDownMenu
//
//  Created by Matthijs on 01/09/2017.
//  Copyright © 2017 mvdlinden. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var slidingView: UIView!
    
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    @IBOutlet weak var slidingViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var pullLabel: UILabel!
    
    var panelShown: Bool = false
    
    var originalPanelAlpha: CGFloat = 0
    var originalPanelPosition: CGFloat = 0
    var lastPoint: CGPoint = CGPoint.zero
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pullLabel.text = "pull up"
        //slidingViewTopConstraint.constant = -150.0
        
        _ = panGestureRecognizer // lazily init
        originalPanelPosition = slidingViewTopConstraint.constant
        originalPanelAlpha = slidingView.alpha
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setViewAlphas(centerRatio: CGFloat) {
        slidingView.alpha = originalPanelAlpha + (centerRatio * (1.0 - originalPanelAlpha))
        //let howFarFromCenterRatio = 0.5 - centerRatio
        //summaryLabel.alpha = howFarFromCenterRatio * 2
        //longTextLabel.alpha = -howFarFromCenterRatio * 2
    }

    @IBAction func showPanel(_ sender: Any) {
        // panelShown is an iVar to track the panel state...
        if (!panelShown) {
            UIView.animate(withDuration: 0.5, animations: {
                self.slidingViewTopConstraint.constant += 100//slidingView.frame.size.height
                self.view.layoutIfNeeded()
                self.panelShown = true
                self.pullLabel.text = "pull up"
            })
        }
        else {
            UIView.animate(withDuration: 0.5, animations: {
                self.slidingViewTopConstraint.constant -= 100//slidingView.frame.size.height
                self.view.layoutIfNeeded()
                self.panelShown = false
                self.pullLabel.text = "pull down"
            })
        }
    }
    
    @IBAction func didPanView(_ sender: UIPanGestureRecognizer) {
        //print ("view is panned")
        
        let point = panGestureRecognizer.location(in: self.view)
        let screenHeight = slidingView.bounds.height
        
        let centerRatio = (slidingViewTopConstraint.constant + originalPanelPosition) / (screenHeight + originalPanelPosition)
        switch panGestureRecognizer.state {
        case .changed:
            let yDelta = lastPoint.y - point.y
            var newConstant = slidingViewTopConstraint.constant - yDelta
            newConstant = newConstant > originalPanelPosition ? newConstant : originalPanelPosition
            //newConstant = newConstant < -screenHeight ? -screenHeight : newConstant
            newConstant = newConstant > screenHeight ? screenHeight : newConstant
//            if newConstant > screenHeight  {
//                newConstant = screenHeight
//            }
            
            slidingViewTopConstraint.constant = newConstant
            print ("slide: slidingViewTopConstraint.constant = \(slidingViewTopConstraint.constant)")
        case .ended:
            print ("centerRatio = \(centerRatio)")
            
            // check if user is sliding up or down
            
            let velocity = panGestureRecognizer.velocity(in: panGestureRecognizer.view)
            var verticalDirectionTreshold: CGFloat = 0.0
            
            if velocity.y > 0 {
                // user dragged down
                verticalDirectionTreshold = -2.0
                print("down")
            }
            else if velocity.y < 0{
                // user dragged towards up
                verticalDirectionTreshold = 0.2
                print("up")
            }
            
            if centerRatio < verticalDirectionTreshold  {
                slidingViewTopConstraint.constant = originalPanelPosition//screenHeight + 150
            } else  {
                slidingViewTopConstraint.constant =  screenHeight//originalPanelPosition
            }

            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: UIViewAnimationOptions(), animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        default:
            break
        }
        lastPoint = point

    }

    

}
