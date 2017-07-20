//
//  JKDropDownView.swift
//  JKDropDownList
//
//  Created by Jitendra Solanki on 7/19/17.
//  Copyright © 2017 jitendra. All rights reserved.
//

import UIKit

protocol JKDropDownDataSource:class {
    func numberOfItemIn(dropDownView list:JKDropDownView)->Int
    func ItemForRowIn(dropDownView list:JKDropDownView, atIndexPath indexPath:IndexPath)->String
}

@objc protocol JKDropDownDelegate:class {
   @objc optional func didSelectItemIn(dropDownView list:JKDropDownView, atIndexPath indexPath:IndexPath)->String
   @objc optional func didDeSelectItemIn(dropDownView list:JKDropDownView)
   @objc optional func heightForItemIn( dropDownView list:JKDropDownView, atIndexPath indexPath:IndexPath)->CGFloat

}
//@IBDesignable
class JKDropDownView: UIView,UITableViewDelegate,UITableViewDataSource {

    var defaultListHeight:CGFloat = 200
    
    var isListOpen = false
    
    let listIdentifier = "dropDownListCell"
    
    @IBInspectable var listHeight:Int = 200{
        didSet{
            defaultListHeight = CGFloat(listHeight)
        }
    }
    
    @IBInspectable var listOpenImage:UIImage?
    @IBInspectable var listCloseImage:UIImage?
    
    @IBInspectable weak var dataSource:JKDropDownDataSource?
    @IBInspectable weak var delegate:JKDropDownDelegate?
    
    let view  = UIView()
    let textLabel = UILabel()
    let tableView = UITableView()
    let button = UIButton()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
   */
    

//    override func draw(_ rect: CGRect) {
//        // Drawing code
//     }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
        //setupView()
    }
 
    override func awakeFromNib() {
         super.awakeFromNib()
        setupView()
    }
    func setupView(){
        /*set label to display text as user select a value in the list*/
        
        view.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: min(50, self.frame.size.height))
        var lblFrame = view.bounds
        view.backgroundColor = UIColor.brown
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        textLabel.text = "Hello List"
        lblFrame.size.width -= 30
        
        textLabel.frame = lblFrame
        textLabel.backgroundColor = UIColor.red
        view.addSubview(textLabel)
        
        /*set button to allow user to open and close the list*/
        button.frame = CGRect(x: lblFrame.origin.x + lblFrame.size.width, y: lblFrame.origin.y, width: 30, height: lblFrame.size.height)
        button.setBackgroundImage(listOpenImage, for: .normal)
        button.backgroundColor = UIColor.yellow
        button.addTarget(self, action: #selector(didTapOnButton), for: .touchUpInside)
        
        view.addSubview(button)
        
        /*add table view to show list of values, and initially set the height to zero*/
        var tableFrame = view.bounds
        tableFrame.origin.y += tableFrame.size.height
        tableFrame.size.height = 0
        
        tableView.frame = tableFrame
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.blue
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: listIdentifier)
        self.addSubview(tableView)
        
    }
    
    override func layoutSubviews() {
        

    }
    
    func didTapOnButton(){
        if isListOpen{
            isListOpen = false
            closeList()
        }else{
            isListOpen = true
            openList()
        }
    }
    
    func openList(){
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            
            var maxFrame = self.frame
           // let maxListHeight = self.defaultListHeight+(maxFrame.size.height-50)

            maxFrame.size.height += self.defaultListHeight
            self.frame = maxFrame
            
            var frame = self.tableView.frame
            frame.size.height = self.defaultListHeight
            self.tableView.frame  = frame
            
        }) { (completed) in
            
        }
    }
    
    func closeList(){
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            var maxFrame = self.frame
            //let maxListHeight = self.defaultListHeight-(maxFrame.size.height-50)

            maxFrame.size.height -= self.defaultListHeight
            self.frame = maxFrame
            var frame = self.tableView.frame
            frame.size.height = 0
            self.tableView.frame  = frame
        }) { (completed) in
            
        }
    }
    
    //MARK:- Tableview data source and delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let row:Int? = dataSource?.numberOfItemIn(dropDownView: self)
        return row ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: listIdentifier, for: indexPath)
        cell.textLabel?.text = dataSource?.ItemForRowIn(dropDownView: self, atIndexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         print("row selected at \(indexPath.row)")
        let selectedValue = delegate?.didSelectItemIn?(dropDownView: self, atIndexPath: indexPath)
        self.textLabel.text = selectedValue
    }

}
