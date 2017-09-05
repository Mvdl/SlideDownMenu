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
    
    var slideDownViewShown: Bool = false
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
            print ("centerRatio = \(centerRatio)")
            
            //setViewAlphas(centerRatio: testCenterRatio)
            panGestureRecognizer.setTranslation(CGPoint.zero, in: self)
        case .ended:
            // check if user is sliding up or down
            if panGestureRecognizer.view != nil {
                let velocity = panGestureRecognizer.velocity(in: panGestureRecognizer.view)
                var verticalDirectionTreshold: CGFloat = 0.0
                
                if velocity.y > 0 {
                    // down
                    verticalDirectionTreshold = -2.0
                }
                else if velocity.y < 0 {
                    // up
                    verticalDirectionTreshold = 2.0//0.8
                }
                
                // set new center
                var newCenter = CGPoint(x: self.center.x, y: self.frame.height / 2 + slideDownViewEndPosition)
                
                if centerRatio < verticalDirectionTreshold  {
                    newCenter = CGPoint(x: self.center.x, y:  self.frame.height / 2 + slideDownViewStartPosition)
                } else if Int(self.frame.origin.y) != Int(slideDownViewStartPosition) {
                    newCenter = CGPoint(x: self.center.x, y: self.frame.height / 2 + slideDownViewEndPosition)
                }
                
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: UIViewAnimationOptions(), animations: {
                    //self.setViewAlphas(centerRatio: centerRatio > verticalDirectionTreshold ? 1.0 : 0.0)// < 0.5 ? 0.0 : 1.0)
                    print ("Animating: testCenterRatio = \(centerRatio)")
                    self.center = newCenter
                    self.layoutIfNeeded()
                }, completion: { finished in
                     print ("self.frame.origin.y is \(self.frame.origin.y)")
                })
            }
        default:
            break
        }
    }
}
