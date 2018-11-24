//
//  ViewController.swift
//  CaseyImageView
//
//  Created by Casey on 20/11/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

import UIKit

/*
 https://a06mobileimage.cnsupu.com/style/A06M/_default/__static/__images/brand/brand1.jpg
 
 
 */

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

//    var imageArr = ["https://a06mobileimage.cnsupu.com/style/A06M/_default/__static/__images/brand/brand1.jpg",
//                    "http://img.hb.aicdn.com/ebf88b4fa5ab5d84d33b0d51a89f5fbe4ded9efe169c6-5zJhaW_fw658",
//                    "http://a06mobileimage.cnsupu.com/static/A06M/_default/__static/__images/dasheng/app/bank/icbc40.png",
//                    "http://a06mobileimage.cnsupu.com/static/A06M/_default/__static/__images/dasheng/app/bank/ccb40.png",
//                    "http://a06mobileimage.cnsupu.com/static/A06M/_default/__static/__images/dasheng/app/bank/boco40.pn",
//                    "http://a06mobileimage.cnsupu.com/static/A06M/_default/__static/__images/dasheng/app/bank/cmb40.png",
//                    "http://a06mobileimage.cnsupu.com/static/A06M/_default/__static/__images/dasheng/app/bank/boc40.png"]
    
    var imageArr = ["http://a06mobileimage.cnsupu.com/static/A06M/_default/__static/__images/dasheng/app/bank/icbc40.png"]
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        
        let tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.frame = CGRect.init(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64)
        
        tableview.register(UINib.init(nibName: "ImageViewCell", bundle: nil), forCellReuseIdentifier: "ImageViewCell")
        
        self.view.addSubview(tableview)
        
    }

    
    //MARK: tableview delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageViewCell", for: indexPath) as? ImageViewCell
        let index = indexPath.row%2
        cell?.imgView?.imageWithUrl(imageArr[indexPath.row])
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

}

