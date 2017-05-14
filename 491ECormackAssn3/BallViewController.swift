//
//  BallViewController.swift
//  491ECormackAssn3
//
//  Created by Eric Cormack on 5/10/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit
import CoreMotion

class BallViewController: UIViewController, UICollisionBehaviorDelegate {
    //  Views!
    @IBOutlet var ballView: BallView!
    
    //  Label
    @IBOutlet weak var scoreLabel: UILabel!
    
    //  Score
    var score = 0 {
        didSet {
            scoreLabel.text = String(score)
            ballView.updateBackground(forScore: score)
            
            if abs(CGFloat(score)) >= ballView.gameOverValue {
                performSegue(withIdentifier: "gameOverSegue", sender: view)
            }
        }
    }
    
    //  Timers
    var hazardTimer: Timer?
    var goalTimer: Timer?
    
    //  Drag!
    var drag: UIPushBehavior?
    
    //      Methods
    //  UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ballView.location = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        ballView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //  Write own code
        ballView.initialize()
        
        hazardTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
            self.ballView.addHazard()
        }
        goalTimer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { _ in
            self.ballView.addGoal()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //  Write own code
        hazardTimer?.invalidate()
        goalTimer?.invalidate()
        
        //  Call Super
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //  Handle input
    @IBAction func handlePan(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            drag = UIPushBehavior(items: [ballView.ball!], mode: .instantaneous)
            ballView.animator.addBehavior(drag!)
        }
        
        let tranlsation = sender.translation(in: view)
        drag?.pushDirection = CGVector(dx: tranlsation.x / 3, dy: tranlsation.y / 3)
        
        if sender.state == .ended || sender.state == .cancelled {
            if let drag = drag { ballView.animator.removeBehavior(drag) }
            drag = nil
        }
    }
    
    //  Handle collisions
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        guard let this = item1 as? UIView else { return }
        guard let that = item2 as? UIView else { return }
        
        if CGFloat(score) < ballView.gameOverValue && CGFloat(score) > -ballView.gameOverValue {
            if this.accessibilityIdentifier == BallView.ballname {
                if that.accessibilityIdentifier == BallView.hazardname {
                    score -= 1
                } else if that.accessibilityIdentifier == BallView.goalname {
                    score += 1
                }
            } else if that.accessibilityIdentifier == BallView.ballname {
                if this.accessibilityIdentifier == BallView.hazardname {
                    score -= 1
                } else if this.accessibilityIdentifier == BallView.goalname {
                    score += 1
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? GameOverViewController {
            view.layer.removeAllAnimations()
            if score >= 0 { //  Win
                target.color = ballView.winColor
                target.text = "You win!"
            } else {        //  Lose
                target.color = ballView.loseColor
                target.text = "You lose!"
            }
        }
    }
}

