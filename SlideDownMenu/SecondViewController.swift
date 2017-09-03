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
    var originalPanelStartPosition: CGFloat = 0
    var endPanelPosition: CGFloat = 0

    var lastPoint: CGPoint = CGPoint.zero
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pullLabel.text = "pull up"
        
        _ = panGestureRecognizer // lazily init
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateUI()
    }
    
    func updateUI() {
        slidingViewTopConstraint.constant = -slidingView.frame.size.height + 104
        originalPanelPosition = slidingViewTopConstraint.constant
        originalPanelStartPosition = slidingViewTopConstraint.constant//slidingView.frame.origin.y
        originalPanelAlpha = slidingView.alpha
        endPanelPosition = 64//slidingView.bounds.height
        print ("slidingView height is \(slidingView.frame.size.height)")
        print ("originalPanelStartPosition is \(originalPanelStartPosition)")
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
                self.slidingViewTopConstraint.constant = self.endPanelPosition//slidingView.frame.size.height
                self.view.layoutIfNeeded()
                self.panelShown = true
                self.pullLabel.text = "pull up"
            })
        }
        else {
            UIView.animate(withDuration: 0.5, animations: {
                self.slidingViewTopConstraint.constant = self.originalPanelPosition//slidingView.frame.size.height
                self.view.layoutIfNeeded()
                self.panelShown = false
                self.pullLabel.text = "pull down"
            })
        }
        print ("button tapped: slidingView.frame.origin.y is \(slidingView.frame.origin.y) en originalPanelStartPosition is \(originalPanelStartPosition)")
    }
    
    @IBAction func didPanView(_ sender: UIPanGestureRecognizer) {
        //print ("view is panned")
        
        let point = panGestureRecognizer.location(in: self.slidingView)
        let centerRatio = (slidingViewTopConstraint.constant + originalPanelPosition) / (endPanelPosition + originalPanelPosition)
        
        switch panGestureRecognizer.state {
        case .changed:
            
            let velocity = panGestureRecognizer.velocity(in: panGestureRecognizer.view)
            let translation = panGestureRecognizer.translation(in: self.slidingView)
            if let view = panGestureRecognizer.view {
                if velocity.y > 0 {
                    // down
                    view.center = CGPoint(x: view.center.x, y: min(view.center.y + translation.y, slidingView.frame.height / 2 + endPanelPosition))
                    print("down")
                }
                else if velocity.y < 0 {
                    // up
                    view.center = CGPoint(x: view.center.x, y: max(view.center.y + translation.y, slidingView.frame.height / 2 + originalPanelPosition))
                    print("up")
                }
            }

            panGestureRecognizer.setTranslation(CGPoint.zero, in: self.slidingView)
        case .ended:
            print ("centerRatio = \(centerRatio)")
            
            // check if user is sliding up or down
            if let view = panGestureRecognizer.view {
                let velocity = panGestureRecognizer.velocity(in: panGestureRecognizer.view)
                var verticalDirectionTreshold: CGFloat = 0.0
                
                if velocity.y > 0 {
                    // down
                    verticalDirectionTreshold = -2.0
                    print("down")
                }
                else if velocity.y < 0 {
                    // up
                    verticalDirectionTreshold = 2.0//0.8
                    print("up")
                }
                
                print ("slidingView.frame.origin.y is \(slidingView.frame.origin.y) en originalPanelStartPosition is \(originalPanelStartPosition)")
                if centerRatio < verticalDirectionTreshold  {
                    slidingViewTopConstraint.constant = originalPanelStartPosition
                } else if Int(slidingView.frame.origin.y) != Int(originalPanelStartPosition) {
                    slidingViewTopConstraint.constant = endPanelPosition//originalPanelPosition
                }

                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: UIViewAnimationOptions(), animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        default:
            break
        }
        lastPoint = point

    }

    

}
