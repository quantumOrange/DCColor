//
//  ViewController.swift
//  DCColor
//
//  Created by quantumOrange on 02/27/2019.
//  Copyright (c) 2019 quantumOrange. All rights reserved.
//

import UIKit
import DCColor

class ViewController: UIViewController {
    @IBOutlet weak var swatch: DCSwatch!
    
    @IBAction func brightness(_ sender: UISlider) {
        let brightness = CGFloat(sender.value)
        
        color = UIColor(hue: 0.3, saturation: 1.0, brightness: brightness, alpha: 1.0)
        
        
    }
    
    var color:Color!  {
        didSet {
            if let sw = swatch {
                sw.color = color
            }
            colorControls.forEach{$0.color = color}
            //print("brightness = \(color.b)")
        }
    }
    
    @IBAction func switchColor(_ sender: Any) {
        let range:ClosedRange<CGFloat> = 0...1
        color = UIColor.init(red: CGFloat.random(in: range),
                             green: CGFloat.random(in: range),
                             blue: CGFloat.random(in: range), alpha: 1.0)
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
    
    @IBOutlet weak var mainColorControl: DCColorControl!
    
    

}

