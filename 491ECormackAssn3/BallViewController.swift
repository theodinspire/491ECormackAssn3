//
//  BallViewController.swift
//  491ECormackAssn3
//
//  Created by Eric Cormack on 5/10/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit
import CoreMotion

class BallViewController: UIViewController {
    //  Views!
    @IBOutlet var ballView: BallView!
    
    //  Drag!
    var drag: UIPushBehavior?
    
    //      Methods
    //  UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ballView.location = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //  Write own code
        ballView.initialize()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //  Write own code
        
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
            drag = UIPushBehavior(items: [ballView.ball], mode: .instantaneous)
            ballView.animator.addBehavior(drag!)
        }
        
        let tranlsation = sender.translation(in: view)
        drag?.pushDirection = CGVector(dx: tranlsation.x / 3, dy: tranlsation.y / 3)
        
        if sender.state == .ended || sender.state == .cancelled {
            if let drag = drag { ballView.animator.removeBehavior(drag) }
            drag = nil
        }
    }
}

