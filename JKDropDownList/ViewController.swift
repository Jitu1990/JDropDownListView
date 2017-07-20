//
//  ViewController.swift
//  JKDropDownList
//
//  Created by Jitendra Solanki on 7/19/17.
//  Copyright © 2017 jitendra. All rights reserved.
//

import UIKit

class ViewController: UIViewController,JKDropDownDelegate,JKDropDownDataSource {

    @IBOutlet weak var dropDownList: JKDropDownView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let dropList = JKDropDownView.init(frame: CGRect.init(x: 50, y: 100, width: 200, height: 100))
//        dropList.backgroundColor = UIColor.cyan
//        self.view.addSubview(dropList)
        dropDownList.delegate = self
        dropDownList.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func numberOfItemIn(dropDownView list: JKDropDownView) -> Int {
         return 10
    }
    func ItemForRowIn(dropDownView list: JKDropDownView, atIndexPath indexPath: IndexPath) -> String {
         return "Item \(indexPath.row)"
    }
    
    func didSelectItemIn(dropDownView list: JKDropDownView, atIndexPath indexPath: IndexPath) -> String {
         return "Item \(indexPath.row)"
    }
}

