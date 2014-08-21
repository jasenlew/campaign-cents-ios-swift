//
//  CompleteListTableViewController.swift
//  campaignCents
//
//  Created by Jasen Lew on 8/20/14.
//  Copyright (c) 2014 Jasen Lew. All rights reserved.
//

import UIKit

class CompleteListTableViewController: UITableViewController {

    // Full list from plist
    var candidatesDictionary:AnyObject? = nil;
    
    // Filtered list of candidates
    var filteredCandidates:AnyObject? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Loading dictionary from nationalCandidatesList
        var documentList = NSBundle.mainBundle().pathForResource("nationalCandidatesList", ofType:"plist")
        candidatesDictionary = NSDictionary(contentsOfFile: documentList)
        println(" \(__FUNCTION__)Fetching 'kochPoliticians.plist 'file \n \(candidatesDictionary) \n")
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        // Adjust number of rows to be either number of search results OR total list
        if tableView == self.searchDisplayController.searchResultsTableView {
            return (filteredCandidates!["New item"]! as NSArray).count
        } else {
            return (candidatesDictionary!["New item"]! as NSArray).count
        }
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {

        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
/*        
        var candidate:AnyObject? = nil;
        // Check to see whether the normal table or search results table is being displayed and set the Candy object from the appropriate array
        if tableView == self.searchDisplayController.searchResultsTableView {
            candidate = (filteredCandidates!["New item"]! as NSArray)[indexPath.row]
        } else {
            candidate = (candidatesDictionary!["New item"]! as NSArray)[indexPath.row]
        }
        
        println("*******************************")
        
        // Configure the cell
        if (candidate! as NSDictionary)["fullname"]! as? String != nil {
            cell.textLabel.text = (candidate! as NSDictionary)["fullname"]! as? String
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }

*/
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
