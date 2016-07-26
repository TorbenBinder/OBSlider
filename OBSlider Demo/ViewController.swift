//
//  ViewController.swift
//  obslider test
//
//  Created by TBinder on 26/07/16.
//  Copyright © 2016 Steinberg Media Technologies GmbH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var OBSliderValueLabel: UILabel!
    @IBOutlet weak var UISliderValueLabel: UILabel!
    
    @IBOutlet weak var obSlider: OBSlider!
    @IBOutlet weak var uiSlider: UISlider!
    
    @IBAction func sliderValueChanged(sender: OBSlider)
    {
        updateUI()
    }
    
    func updateUI()
    {
        let percentFormatter: NSNumberFormatter = NSNumberFormatter()
        percentFormatter.numberStyle = .PercentStyle
        
        UISliderValueLabel.text = "Value: \(obSlider.value)"
        OBSliderValueLabel.text = "Scrubbing speed: \(percentFormatter.stringFromNumber(obSlider.scrubbingSpeed))"
    }
    
    // Do any additional setup after loading the view, typically from a nib.
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

}
