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
    
    var slideDownViewShown: Bool = false
    
    var originalSlideDownViewAlpha: CGFloat = 0
    var slideDownViewStartPosition: CGFloat = 0
    var slideDownViewEndPosition: CGFloat = 0

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
        originalSlideDownViewPosition = slidingViewTopConstraint.constant
        slideDownViewStartPosition = slidingViewTopConstraint.constant//slidingView.frame.origin.y
        originalSlideDownViewAlpha = slidingView.alpha
        slideDownViewEndPosition = 64//slidingView.bounds.height
        print ("slidingView height is \(slidingView.frame.size.height)")
        print ("slideDownViewStartPosition is \(slideDownViewStartPosition)")
    }

    func setViewAlphas(centerRatio: CGFloat) {
        slidingView.alpha = originalSlideDownViewAlpha + (centerRatio * (1.0 - originalSlideDownViewAlpha))
        //let howFarFromCenterRatio = 0.5 - centerRatio
        //summaryLabel.alpha = howFarFromCenterRatio * 2
        //longTextLabel.alpha = -howFarFromCenterRatio * 2
    }

    @IBAction func showSlideDownView(_ sender: Any) {
        // SlideDownViewShown is an iVar to track the SlideDownView state...
        if (!slideDownViewShown) {
            UIView.animate(withDuration: 0.5, animations: {
                self.slidingViewTopConstraint.constant = self.slideDownViewEndPosition//slidingView.frame.size.height
                self.view.layoutIfNeeded()
                self.slideDownViewShown = true
                self.pullLabel.text = "pull up"
            })
        }
        else {
            UIView.animate(withDuration: 0.5, animations: {
                self.slidingViewTopConstraint.constant = self.originalSlideDownViewPosition//slidingView.frame.size.height
                self.view.layoutIfNeeded()
                self.slideDownViewShown = false
                self.pullLabel.text = "pull down"
            })
        }
        print ("button tapped: slidingView.frame.origin.y is \(slidingView.frame.origin.y) en slideDownViewStartPosition is \(slideDownViewStartPosition)")
    }
    
    @IBAction func didPanView(_ sender: UIPanGestureRecognizer) {
        
        let point = panGestureRecognizer.location(in: self.slidingView)
        let centerRatio = (slidingViewTopConstraint.constant + originalSlideDownViewPosition) / (slideDownViewEndPosition + originalSlideDownViewPosition)
        
        switch panGestureRecognizer.state {
        case .changed:
            let velocity = panGestureRecognizer.velocity(in: panGestureRecognizer.view)
            let translation = panGestureRecognizer.translation(in: self.slidingView)
            if let view = panGestureRecognizer.view {
                if velocity.y > 0 {
                    // down
                    view.center = CGPoint(x: view.center.x, y: min(view.center.y + translation.y, slidingView.frame.height / 2 + slideDownViewEndPosition))
                    print("down")
                }
                else if velocity.y < 0 {
                    // up
                    view.center = CGPoint(x: view.center.x, y: max(view.center.y + translation.y, slidingView.frame.height / 2 + originalSlideDownViewPosition))
                    print("up")
                }
            }

            panGestureRecognizer.setTranslation(CGPoint.zero, in: self.slidingView)
        case .ended:
            print ("centerRatio = \(centerRatio)")
            
            // check if user is sliding up or down
            if panGestureRecognizer.view != nil {
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
                
                //print ("slidingView.frame.origin.y is \(slidingView.frame.origin.y) en slideDownViewStartPosition is \(slideDownViewStartPosition)")
                if centerRatio < verticalDirectionTreshold  {
                    slidingViewTopConstraint.constant = slideDownViewStartPosition
                } else if Int(slidingView.frame.origin.y) != Int(slideDownViewStartPosition) {
                    slidingViewTopConstraint.constant = slideDownViewEndPosition//originalSlideDownViewPosition
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
