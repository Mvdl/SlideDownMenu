//
//  SecondViewController.swift
//  SlideDownMenu
//
//  Created by Matthijs on 01/09/2017.
//  Copyright © 2017 mvdlinden. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    let slideDownViewBottomButtonDownImage = UIImage(named: "downChevronSmall")?.withRenderingMode(.alwaysTemplate)
    let slideDownViewBottomButtonUpImage = UIImage(named: "upChevronSmall")?.withRenderingMode(.alwaysTemplate)
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var slidingView: UIView!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    @IBOutlet weak var slidingViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var slideDownButtonView: UIView!
    @IBOutlet weak var slideDownViewBottomButton: UIButton!
    @IBOutlet weak var pullLabel: UILabel!
    
    var slideDownViewShown: Bool = false
    var originalSlideDownViewAlpha: CGFloat = 1.0
    var slideDownViewStartPosition: CGFloat = 0
    var slideDownViewEndPosition: CGFloat = 0
    var lastPoint: CGPoint = CGPoint.zero
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pullLabel.text = "Legenda"
        
        slideDownViewBottomButton.setImage(slideDownViewBottomButtonDownImage, for: UIControlState.normal)
        slideDownViewBottomButton.tintColor = .black
        
        _ = panGestureRecognizer // lazily init
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateUI()
    }
    
    func updateUI() {
        slidingViewTopConstraint.constant = -slidingView.frame.size.height + 104
        slideDownViewStartPosition = slidingViewTopConstraint.constant//slidingView.frame.origin.y
        originalSlideDownViewAlpha = slidingView.alpha
        slideDownViewEndPosition = 64//slidingView.bounds.height
        print ("slidingView height is \(slidingView.frame.size.height)")
        print ("slideDownViewStartPosition is \(slideDownViewStartPosition)")
    }

    func setViewAlphas(centerRatio: CGFloat) {
        let howFarFromEndRatio = 1.0 - centerRatio
        slideDownButtonView.alpha = howFarFromEndRatio * 2
        print ("howFarFromEndRatio: \(howFarFromEndRatio)")
    }

    @IBAction func didTapSlideDownViewBottomButton(_ sender: UIButton) {
        //let testCenterRatio = (slidingView.frame.origin.y + -slideDownViewStartPosition) / (slideDownViewEndPosition + -slideDownViewStartPosition)
        
        if (!slideDownViewShown) {
            self.slidingViewTopConstraint.constant = self.slideDownViewEndPosition//slidingView.frame.size.height
            self.slideDownViewShown = true
            slideDownButtonView.alpha = 0.0
        }
        else {
            self.slidingViewTopConstraint.constant = self.slideDownViewStartPosition//slidingView.frame.size.height
            self.slideDownViewShown = false
            slideDownButtonView.alpha = 1.0
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
        
        print ("button tapped: slidingView.frame.origin.y is \(slidingView.frame.origin.y) en slideDownViewStartPosition is \(slideDownViewStartPosition)")
    }
    
    @IBAction func didPanView(_ sender: UIPanGestureRecognizer) {
        
        let point = panGestureRecognizer.location(in: self.slidingView)
        let centerRatio = (slidingViewTopConstraint.constant + slideDownViewStartPosition) / (slideDownViewEndPosition + slideDownViewStartPosition)
        let testCenterRatio = (slidingView.frame.origin.y + -slideDownViewStartPosition) / (slideDownViewEndPosition + -slideDownViewStartPosition)

        
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
                    view.center = CGPoint(x: view.center.x, y: max(view.center.y + translation.y, slidingView.frame.height / 2 + slideDownViewStartPosition))
                    print("up")
                }
            }
            print ("testCenterRatio = \(testCenterRatio)")

            setViewAlphas(centerRatio: testCenterRatio)
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
                    self.setViewAlphas(centerRatio: testCenterRatio > verticalDirectionTreshold ? 1.0 : 0.0)// < 0.5 ? 0.0 : 1.0)
                    print ("Animating: testCenterRatio = \(testCenterRatio)")
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        default:
            break
        }
        lastPoint = point
    }

}
