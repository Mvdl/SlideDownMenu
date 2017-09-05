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
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var slideDownButtonView: UIView!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    @IBOutlet weak var slideDownViewBottomButton: UIButton!
    @IBOutlet weak var pullLabel: UILabel!
  
    enum swipeDirection {
        case down
        case up
    }
    
    var mySwipeDirection = swipeDirection.down
    var slideDownViewOut: Bool = false
    var originalSlideDownViewAlpha: CGFloat = 1.0
    var slideDownViewStartPosition: CGFloat!
    var slideDownViewEndPosition: CGFloat!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    private func nibSetup() {
        self.translatesAutoresizingMaskIntoConstraints = false

        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        view.backgroundColor = .purple
        addSubview(view)
        
        self.backgroundColor = .clear
        
        originalSlideDownViewAlpha = self.alpha
        slideDownViewStartPosition = -self.frame.height + 104// visible part of menu + navigationbar height
        slideDownViewEndPosition = 64// navigation bar height
        
        updateUI()
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return nibView
    }
    
    func updateUI() {
        self.center = CGPoint(x: self.center.x, y:  self.frame.height / 2 + slideDownViewStartPosition)

        print ("slidingView height is \(view.frame.size.height)")
        print ("slideDownViewStartPosition is \(slideDownViewStartPosition)")
        print ("self.center is \(self.center)")
        print ("self.frame.origin.y is \(self.frame.origin.y)")
        self.layoutIfNeeded()
    }

    @IBAction func didPanView(_ sender: UIPanGestureRecognizer) {
        let centerRatio = (self.frame.origin.y + -slideDownViewStartPosition) / (slideDownViewEndPosition + -slideDownViewStartPosition)
        let velocity = panGestureRecognizer.velocity(in: panGestureRecognizer.view)
        let translation = panGestureRecognizer.translation(in: self)
        
        // check if user is sliding up or down
        if velocity.y > 0 {
            mySwipeDirection = swipeDirection.down
        }
        else if velocity.y < 0 {
            mySwipeDirection = swipeDirection.up
        }
        
        switch panGestureRecognizer.state {
        case .changed:
            
            switch mySwipeDirection {
            case .down:
                self.center = CGPoint(x: self.center.x, y: min(self.center.y + translation.y, self.frame.height / 2 + slideDownViewEndPosition))
            case .up:
                self.center = CGPoint(x: self.center.x, y: max(self.center.y + translation.y, self.frame.height / 2 + slideDownViewStartPosition))
            }
            
            print ("centerRatio = \(centerRatio)")
            
            //setViewAlphas(centerRatio: centerRatio)
            panGestureRecognizer.setTranslation(CGPoint.zero, in: self)
        case .ended:
            if panGestureRecognizer.view != nil {
                var verticalDirectionTreshold: CGFloat = 0.0
                
                // set new center
                var newCenter = CGPoint(x: self.center.x, y: self.frame.height / 2 + slideDownViewEndPosition)
                
                switch mySwipeDirection {
                case .down:
                    verticalDirectionTreshold = -2.0
                case .up:
                    verticalDirectionTreshold = 2.0
                }
                
                if centerRatio < verticalDirectionTreshold  {
                    newCenter = CGPoint(x: self.center.x, y:  self.frame.height / 2 + slideDownViewStartPosition)
                    slideDownViewOut = false
                } else if Int(self.frame.origin.y) != Int(slideDownViewStartPosition) {
                    newCenter = CGPoint(x: self.center.x, y: self.frame.height / 2 + slideDownViewEndPosition)
                    slideDownViewOut = true
                }
                
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: UIViewAnimationOptions(), animations: {
                    //self.setViewAlphas(centerRatio: centerRatio > verticalDirectionTreshold ? 1.0 : 0.0)// < 0.5 ? 0.0 : 1.0)
                    print ("Animating: testCenterRatio = \(centerRatio)")
                    self.center = newCenter
                }, completion: { finished in
                     print ("self.frame.origin.y is \(self.frame.origin.y)")
                })
            }
        default:
            break
        }
    }
}
