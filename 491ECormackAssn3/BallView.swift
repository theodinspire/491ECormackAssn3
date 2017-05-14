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
    //  The ball
    var ball: UIView?
    
    //  Initialize in .viewDidLoad()
    var location: CGPoint!
    
    //  Delegate
    var delegate: UICollisionBehaviorDelegate?
    
    //  Can be made in storyboard
    @IBInspectable var ballRadius: CGFloat = 30
    @IBInspectable var ballColor: UIColor = .darkGray
    
    @IBInspectable var obstSize: CGFloat = 30
    @IBInspectable var hazardColor: UIColor = .red
    @IBInspectable var goalColor: UIColor = .green
    
    @IBInspectable var winColor: UIColor = .blue
    @IBInspectable var loseColor: UIColor = .yellow
    @IBInspectable var neutralColor: UIColor = .white
    
    @IBInspectable var gameOverValue: CGFloat = 100
    
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
    
    //  Animation!
    var animator: UIDynamicAnimator!
    let ballBehavior = UIDynamicItemBehavior()
    let gravity = UIGravityBehavior()
    let collider = UICollisionBehavior()
    
    //  Other
    static let ballname = "Ball"
    static let hazardname = "Hazard"
    static let goalname = "Goal"
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func updateBackground(forScore value: Int) {
        let target = value > 0 ? winColor : loseColor
        let ratio: CGFloat = abs(CGFloat(value) / gameOverValue)
        
        backgroundColor = neutralColor.blend(with: target, ratio: ratio)
    }
    
    func addHazard() {
        let hazard = newHazard()
        
        let side = Direction.random()
        
        hazard.center = getSidePosition(at: side)
        insertSubview(hazard, at: 0)
        
        let behavior = getDefaultObstacleBehavior()
        let collision = getHazardCollider()
        let push = getRandomPush(from: side)
        
        behavior.addItem(hazard)
        collision.addItem(hazard)
        push.addItem(hazard)
        
        animator.addBehavior(behavior)
        animator.addBehavior(collision)
        animator.addBehavior(push)
    }
    
    func addGoal() {
        let goal = newGoal()
        
        let side = Direction.random()
        
        goal.center = getSidePosition(at: side)
        insertSubview(goal, at: 0)
        
        let behavior = getDefaultObstacleBehavior()
        let collision = getHazardCollider()
        let push = getRandomPush(from: side)
        
        behavior.addItem(goal)
        collision.addItem(goal)
        push.addItem(goal)
        
        animator.addBehavior(behavior)
        animator.addBehavior(collision)
        animator.addBehavior(push)
    }

    //  Instantiation
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
        ball?.backgroundColor = ballColor
        ball?.layer.cornerRadius = ballRadius
        
        ball?.accessibilityIdentifier = BallView.ballname
        
        self.insertSubview(ball!, at: 0)
    }
    
    private func instantiateMotion() {
        motionManager.startDeviceMotionUpdates(to: queue) { given, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = given else { return }
            
            self.gravity.gravityDirection = CGVector(dx: data.gravity.x, dy: -data.gravity.y)
        }
    }
    
    private func instantiateAnimation() {
        ballBehavior.resistance = friction
        ballBehavior.elasticity = elasticity
        ballBehavior.friction = 0
        ballBehavior.density = 1
        ballBehavior.addItem(ball!)
        
        gravity.addItem(ball!)
        
        collider.addItem(ball!)
        collider.translatesReferenceBoundsIntoBoundary = true
        
        animator = UIDynamicAnimator(referenceView: self)
        animator.addBehavior(ballBehavior)
        animator.addBehavior(gravity)
        animator.addBehavior(collider)
    }
    
    func getDefaultObstacleBehavior() -> UIDynamicItemBehavior {
        let behavior = UIDynamicItemBehavior()
        //behavior.resistance = CGFloat.greatestFiniteMagnitude
        behavior.allowsRotation = false
        behavior.density = 1_000_000
        
        return behavior
    }
    
    func getHazardCollider() -> UICollisionBehavior {
        let col = UICollisionBehavior()
        if let ball = ball { col.addItem(ball) }
        col.collisionDelegate = delegate
        
        return col
    }
    
    func getGoalCollider() -> UICollisionBehavior {
        let col = UICollisionBehavior()
        if let ball = ball { col.addItem(ball) }
        col.collisionDelegate = delegate
        
        return col
    }
    
    func getRandomPush(from direction: Direction) -> UIPushBehavior {
        let rand = ((CGFloat(arc4random()) / CGFloat(UINT32_MAX) * CGFloat.pi) - CGFloat.pi / 2) * 0.5
        
        let angle: CGFloat
        switch direction {
        case .Up:
            angle = rand + CGFloat.pi / 2
        case .Right:
            angle = rand + CGFloat.pi
        case .Down:
            angle = rand - CGFloat.pi / 2
        case .Left:
            angle = rand
        }
        
        let magnitude = CGFloat(arc4random_uniform(30) + 6) * 5_000
        
        let push = UIPushBehavior(items: [], mode: .instantaneous)
        push.setAngle(angle, magnitude: magnitude)
        
        return push
    }
    
    private func newHazard() -> UIView {
        let hazard = UIView(frame: CGRect(x: -obstSize * 2, y: -obstSize * 2, width: obstSize, height: obstSize))
        hazard.backgroundColor = hazardColor
        hazard.accessibilityIdentifier = BallView.hazardname
        
        return hazard
    }
    
    private func newGoal() -> UIView {
        let goal = UIView(frame: CGRect(x: -obstSize * 2, y: -obstSize * 2, width: obstSize, height: obstSize))
        goal.backgroundColor = goalColor
        goal.accessibilityIdentifier = BallView.goalname
        
        return goal
    }
    
    private func getSidePosition(at side: Direction) -> CGPoint {
        let rand = CGFloat(arc4random_uniform(UInt32(side.isUpDown ? bounds.width : bounds.height)))
        
        let point: CGPoint
        
        switch side {
        case .Up:
            point = CGPoint(x: rand, y: -obstSize * 0.6)
        case .Right:
            point = CGPoint(x: bounds.width + obstSize * 0.6, y: rand)
        case .Down:
            point = CGPoint(x: rand, y: bounds.height + obstSize * 0.6)
        case .Left:
            point = CGPoint(x: -obstSize * 0.6, y: rand)
        }
        
        return point
        
        //return center
    }
}
