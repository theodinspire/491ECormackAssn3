//
//  BallView.swift
//  491ECormackAssn3
//
//  Created by Eric Cormack on 5/12/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit
import CoreMotion

@IBDesignable
class BallView: UIView {
    var ball: UIView!
    
    //  Initialize in .viewDidLoad()
    var location: CGPoint!
    
    //  Can be made in storyboard
    @IBInspectable var ballRadius: CGFloat = 20
    @IBInspectable var ballColor: UIColor = .darkGray
    @IBInspectable var friction: CGFloat = 0.1 {
        didSet {
            if friction > 1 { friction = 1 }
            else if friction < 0 { friction = 0 }
        }
    }
    @IBInspectable var elasticity: CGFloat = 0.99 {
        didSet {
            if elasticity > 1 { elasticity = 1 }
            else if elasticity < 0 { elasticity = 0 }
        }
    }
    
    //  Motion!
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    
    //  Gesture
    var finger: UIView!
    
    //  Animation!
    var animator: UIDynamicAnimator!
    let ballBehavior = UIDynamicItemBehavior()
    let gravity = UIGravityBehavior()
    let collider = UICollisionBehavior()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    //  Call in viewWillAppear
    func initialize() {
        //  Ball
        instantiateBall()
        
        //  Motion
        instantiateMotion()
        
        //  Animation
        instantiateAnimation()
    }
    
    private func instantiateBall() {
        ball = UIView(frame: CGRect(x: location.x - ballRadius, y: location.y - ballRadius, width: ballRadius * 2, height: ballRadius * 2))
        ball.backgroundColor = ballColor
        ball.layer.cornerRadius = ballRadius
        
        self.insertSubview(ball, at: 0)
    }
    
    private func instantiateMotion() {
        motionManager.startDeviceMotionUpdates(to: queue) { given, error in
            if let error = error { print(error.localizedDescription) }
            guard let data = given else { return }
            
            self.gravity.gravityDirection = CGVector(dx: data.gravity.x, dy: -data.gravity.y)
        }
    }
    
    private func instantiateAnimation() {
        ballBehavior.resistance = friction
        ballBehavior.elasticity = elasticity
        ballBehavior.friction = 0
        ballBehavior.density = 1
        ballBehavior.addItem(ball)
        
        gravity.addItem(ball)
        
        collider.addItem(ball)
        collider.translatesReferenceBoundsIntoBoundary = true
        
        animator = UIDynamicAnimator(referenceView: self)
        animator.addBehavior(ballBehavior)
        animator.addBehavior(gravity)
        animator.addBehavior(collider)
    }
}
