//
//  ViewController.swift
//  Draper
//
//  Created by Björn Dahlgren on 2017-06-17.
//  Copyright © 2017 Björn Dahlgren. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        MuzeiFeaturedArt().load { (artwork: Artwork?) in
            DispatchQueue.main.async {
                self.imageView?.image = artwork?.image
                self.titleLabel?.text = artwork?.title
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

