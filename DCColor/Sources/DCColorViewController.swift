//
//  DCColorViewController.swift
//  DCColor
//
//  Created by David Crooks on 23/03/2017.
//  Copyright © 2017 David Crooks. All rights reserved.
//

import UIKit

class DCColorViewController: UIViewController {
    @IBOutlet weak var swatch: DCSwatch!

    
    var color:Color!  {
        didSet {
            if let sw = swatch {
                sw.color = color
            }
            colorControls.forEach{$0.color = color}
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        color = UIColor.magenta
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func colorChanged(_ sender: DCColorControl) {
        color = sender.color
    }
    
    @IBAction func colorAction(_ sender: DCColorControl) {
        print("ColorAction")
    }
    
    @IBOutlet var colorControls: [DCColorControl]!
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
