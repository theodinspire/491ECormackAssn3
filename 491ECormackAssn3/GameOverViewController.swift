//
//  GameOverViewController.swift
//  491ECormackAssn3
//
//  Created by Eric Cormack on 5/14/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {
    var text = "Game over"
    var color = UIColor.white
    
    @IBOutlet var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = color
        label.text = text
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetGame(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToStartSegue", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
