//
//  SlideDownView.swift
//  SlideDownMenu
//
//  Created by Matthijs on 04/09/2017.
//  Copyright © 2017 mvdlinden. All rights reserved.
//

import UIKit

class SlideDownView: UIView {
    
    
    @IBOutlet weak var view: UIView!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    @IBOutlet weak var slideDownButtonView: UIView!
    @IBOutlet weak var slideDownViewBottomButton: UIButton!
    @IBOutlet weak var pullLabel: UILabel!
    
    var slideDownViewShown: Bool = false
    var originalSlideDownViewAlpha: CGFloat = 1.0
    var slideDownViewStartPosition: CGFloat = 0
    var slideDownViewEndPosition: CGFloat = 200
    var lastPoint: CGPoint = CGPoint.zero
    var slidingViewTopConstraint: NSLayoutConstraint!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    private func nibSetup() {
        self.backgroundColor = .red
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        view.backgroundColor = .purple
        addSubview(view)

//        guard let superview = self.superview else {
//            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
//            return
//        }
        
        slidingViewTopConstraint = NSLayoutConstraint(
            item: self.view,
            attribute: NSLayoutAttribute.top,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.top,
            multiplier: 1,
            constant: 0)
        
        self.addConstraint(slidingViewTopConstraint)
        
        updateUI()
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return nibView
    }
    
    func updateUI() {
        slidingViewTopConstraint.constant = -view.frame.size.height + 104
        slideDownViewStartPosition = slidingViewTopConstraint.constant//slidingView.frame.origin.y
        originalSlideDownViewAlpha = view.alpha
        slideDownViewEndPosition = 64//slidingView.bounds.height
        print ("slidingView height is \(view.frame.size.height)")
        print ("slideDownViewStartPosition is \(slideDownViewStartPosition)")
    }

    @IBAction func didPanView(_ sender: UIPanGestureRecognizer) {
        let point = panGestureRecognizer.location(in: self)
        let centerRatio = (slidingViewTopConstraint.constant + slideDownViewStartPosition) / (slideDownViewEndPosition + slideDownViewStartPosition)
        let testCenterRatio = (self.frame.origin.y + -slideDownViewStartPosition) / (slideDownViewEndPosition + -slideDownViewStartPosition)
        
        
        switch panGestureRecognizer.state {
        case .changed:
            let velocity = panGestureRecognizer.velocity(in: panGestureRecognizer.view)
            let translation = panGestureRecognizer.translation(in: self)
            if velocity.y > 0 {
                // down
                self.center = CGPoint(x: self.center.x, y: min(self.center.y + translation.y, self.frame.height / 2 + slideDownViewEndPosition))
                print("down")
            }
            else if velocity.y < 0 {
                // up
                self.center = CGPoint(x: self.center.x, y: max(self.center.y + translation.y, self.frame.height / 2 + slideDownViewStartPosition))
                print("up")
            }
            print ("testCenterRatio = \(testCenterRatio)")
            
            //setViewAlphas(centerRatio: testCenterRatio)
            panGestureRecognizer.setTranslation(CGPoint.zero, in: self)
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
                /*
                //print ("slidingView.frame.origin.y is \(slidingView.frame.origin.y) en slideDownViewStartPosition is \(slideDownViewStartPosition)")
                if centerRatio < verticalDirectionTreshold  {
                    //slidingViewTopConstraint.constant = slideDownViewStartPosition
                    view.center = CGPoint(x: view.center.x, y:  view.frame.height / 2 + slideDownViewEndPosition)
                } else if Int(view.frame.origin.y) != Int(slideDownViewStartPosition) {
                    //slidingViewTopConstraint.constant = slideDownViewEndPosition//originalSlideDownViewPosition
                    view.center = CGPoint(x: view.center.x, y: view.frame.height / 2 + slideDownViewEndPosition)
                }
                
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: UIViewAnimationOptions(), animations: {
                    //self.setViewAlphas(centerRatio: testCenterRatio > verticalDirectionTreshold ? 1.0 : 0.0)// < 0.5 ? 0.0 : 1.0)
                    print ("Animating: testCenterRatio = \(testCenterRatio)")
                    self.layoutIfNeeded()
                }, completion: nil)
 */
            }
        default:
            break
        }
        lastPoint = point

    }
}
