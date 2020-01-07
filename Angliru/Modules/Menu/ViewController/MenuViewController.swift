//
//  MenuViewController.swift
//  Angliru
//
//  Created by Juanra Fernández on 27/07/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import UIKit
import SideMenu

class MenuViewController: BaseViewController {

    @IBOutlet weak var buttonCloseSesion: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func buttonCloseSession_clicked(_ sender: Any) {
        self.signOut()
    }
}
