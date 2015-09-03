//
//  UserInfoViewController.swift
//  Loomoon
//
//  Created by Yura Vorontsov on 03.09.15.
//  Copyright (c) 2015 Yura Vorontsov. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController, DataReciever, UITableViewDelegate, UITableViewDataSource {

    var dataSourse: Networking!
    var dataModel: DataModel!
    var alert = UIAlertController(title: "Error", message: "Some error with network", preferredStyle: UIAlertControllerStyle.Alert)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBAction func logout(sender: UIBarButtonItem)
    {
        doLogout()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = ""
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        dataSourse.dataReciever = self
        alert.addAction(UIAlertAction(title: "try again", style: .Default, handler: {UIAlertAction in self.doNetworkRequest()}))
        alert.addAction(UIAlertAction(title: "relogin", style: .Default, handler: {UIAlertAction in dispatch_async(dispatch_get_main_queue()){ self.doLogout()}}))
        doNetworkRequest()
    }

    func dataForCurrentUser(data: NSDictionary)
    {
        spinner.stopAnimating()
        dataModel = DataModel(data: data)
        title = dataModel.name
        tableView.hidden = false
        tableView.reloadData()
    }
    
    func someNetworkError()
    {
        spinner.stopAnimating()
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func doLogout()
    {
        dataSourse.dataReciever = nil
        dataSourse.logout()
        navigationController?.popViewControllerAnimated(true)
    }
    
    func doNetworkRequest()
    {
        dispatch_async(dispatch_get_main_queue()){
            self.spinner.startAnimating()}
        dataSourse.userData()
    }
    
//MARK: tableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if dataModel == nil {return 0}
        switch section
        {
        case 0:
            return dataModel.user.count
        case 1:
            return dataModel.subscriptions.count
        default:
            return dataModel.tags.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        switch indexPath.section
        {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("defaultCell", forIndexPath: indexPath) as! UserTableViewCell
            cell.header.text = dataModel.user[indexPath.row].header
            cell.info.text = dataModel.user[indexPath.row].descriptions
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("defaultCell", forIndexPath: indexPath) as! UserTableViewCell
            cell.header.text = dataModel.subscriptions[indexPath.row].header
            cell.info.text = dataModel.subscriptions[indexPath.row].descriptions
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("tagCell", forIndexPath: indexPath) as! TagTableViewCell
            cell.header1.text = dataModel.tags[indexPath.row][0].header
            cell.info1.text = dataModel.tags[indexPath.row][0].descriptions
            cell.header2.text = dataModel.tags[indexPath.row][1].header
            cell.info2.text = dataModel.tags[indexPath.row][1].descriptions
            return cell
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        switch section
        {
        case 0:
            return "User"
        case 1:
            return "Subscripts"
        default:
            return "Tags"
        }
    }
}
