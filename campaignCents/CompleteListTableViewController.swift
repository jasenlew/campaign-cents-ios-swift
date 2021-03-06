//
//  CompleteListTableViewController.swift
//  campaignCents
//
//  Created by Jasen Lew on 8/20/14.
//  Copyright (c) 2014 Jasen Lew. All rights reserved.
//

import UIKit

class CompleteListTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {

    // Full list from plist
    var candidatesDictionary:AnyObject? = nil;
    var candidatesArray = [Politician]()
    
    // Filtered list of candidates
    var filteredCandidates = [Politician]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Loading dictionary from nationalCandidatesList
        var documentList = NSBundle.mainBundle().pathForResource("nationalCandidatesList", ofType:"plist")
        candidatesDictionary = NSDictionary(contentsOfFile: documentList)
        println(" \(__FUNCTION__)Fetching 'kochPoliticians.plist 'file \n \(candidatesDictionary) \n")
        
        self.tableView.reloadData()
        
        // Hides navigationController on first VC, which is loaded on app load
        self.navigationController.navigationBarHidden = false
        self.navigationController.navigationBar.tintColor = UIColor(red: 24/255, green: 89/255, blue: 68/255, alpha: 1)
        
        // loop through entire candidatesDictionary and create an instance of Candy and append to array
        for var i = 0; i < (candidatesDictionary!["New item"]! as NSArray).count; i++ {
            self.candidatesArray.append(Politician(firstName: (((candidatesDictionary! as NSDictionary)["New item"] as? NSArray)![i] as NSDictionary!)["firstName"]! as NSString,
                fullName: (((candidatesDictionary! as NSDictionary)["New item"] as? NSArray)![i] as NSDictionary!)["fullName"]! as NSString,
                lastName: (((candidatesDictionary! as NSDictionary)["New item"] as? NSArray)![i] as NSDictionary!)["lastName"]! as NSString,
                party: (((candidatesDictionary! as NSDictionary)["New item"] as? NSArray)![i] as NSDictionary!)["party"]! as NSString,
                partyLetter: (((candidatesDictionary! as NSDictionary)["New item"] as? NSArray)![i] as NSDictionary!)["partyLetter"]! as NSString,
                position: (((candidatesDictionary! as NSDictionary)["New item"] as? NSArray)![i] as NSDictionary!)["position"]! as NSString,
                state: (((candidatesDictionary! as NSDictionary)["New item"] as? NSArray)![i] as NSDictionary!)["state"]! as NSString,
                voteSmartID: (((candidatesDictionary! as NSDictionary)["New item"] as? NSArray)![i] as NSDictionary!)["voteSmartID"]! as NSInteger))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }

    // Adjust number of rows to be either number of search results OR total list
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController.searchResultsTableView {
            return filteredCandidates.count
        } else {
            return (candidatesDictionary!["New item"]! as NSArray).count
        }
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {

        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        var candidate : Politician
        // Check to see whether the normal table or search results table is being displayed and set the Candy object from the appropriate array
        if tableView == self.searchDisplayController.searchResultsTableView {
            candidate = filteredCandidates[indexPath.row]
            
            cell.textLabel.text = "\(filteredCandidates[indexPath.row].fullName)"
            cell.detailTextLabel.text = "\(filteredCandidates[indexPath.row].position) (\(filteredCandidates[indexPath.row].state)-\(filteredCandidates[indexPath.row].partyLetter))"
        
        /**** WIP: Next step is grabbing and rendering correct photo (retaining previously indexed photo) ****
            // Gets photo from votesmart API
            var tempVoteSmartID = (((candidatesDictionary! as NSDictionary)["New item"] as? NSArray)![indexPath.row] as NSDictionary!)["voteSmartID"]! as Int
          
            let url = NSURL.URLWithString("http://votesmart.org/canphoto/\(tempVoteSmartID).jpg")
            var err: NSError?
            var imageData:NSData? = NSData.dataWithContentsOfURL(url,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)
            if imageData != nil {
                cell.imageView.image = UIImage(data:imageData)
            }
        */
            
            cell.accessoryType = UITableViewCellAccessoryType.None
        } else {
            if ((candidatesDictionary! as NSDictionary)["New item"] as? NSArray)![indexPath.row] as NSDictionary! != nil {
                cell.textLabel.text = (((candidatesDictionary! as NSDictionary)["New item"] as? NSArray)![indexPath.row] as NSDictionary!)["fullName"]! as NSString
                
                var tempState = (((candidatesDictionary! as NSDictionary)["New item"] as? NSArray)![indexPath.row] as NSDictionary!)["state"]! as NSString
                var tempPartyLetter = (((candidatesDictionary! as NSDictionary)["New item"] as? NSArray)![indexPath.row] as NSDictionary!)["partyLetter"]! as NSString
                var tempPosition = (((candidatesDictionary! as NSDictionary)["New item"] as? NSArray)![indexPath.row] as NSDictionary!)["position"]! as NSString
                
                cell.detailTextLabel.text = "\(tempPosition) (\(tempState)-\(tempPartyLetter))"
                
                // Gets photo from votesmart API
                var tempVoteSmartID = (((candidatesDictionary! as NSDictionary)["New item"] as? NSArray)![indexPath.row] as NSDictionary!)["voteSmartID"]! as Int
                
                let url = NSURL.URLWithString("http://votesmart.org/canphoto/\(tempVoteSmartID).jpg")
                var err: NSError?
                var imageData:NSData? = NSData.dataWithContentsOfURL(url,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)
                if imageData != nil {
                    cell.imageView.image = UIImage(data:imageData)
                }
                
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        }

        return cell
    }
    
    // Filter the array using the filter method
    func filterContentForSearchText (searchText:String, scope:String = "All") {
        self.filteredCandidates = self.candidatesArray.filter({( currentCandidate:Politician ) -> Bool in
            var categoryMatch = (scope == "All") || (currentCandidate.party == scope)

            var nameMatch = (currentCandidate.fullName.rangeOfString(searchText))
            var stateMatch = (currentCandidate.state.rangeOfString(searchText))
            var partyMatch = (currentCandidate.party.rangeOfString(searchText))

            return (categoryMatch && nameMatch != nil || categoryMatch && stateMatch != nil || categoryMatch && partyMatch != nil)
        })
    }
    
    // Runs the text filtering function whenever the user changes the search string in the search bar
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        let scopes = self.searchDisplayController.searchBar.scopeButtonTitles as [String]
        let selectedScope = scopes[self.searchDisplayController.searchBar.selectedScopeButtonIndex] as String
        self.filterContentForSearchText(searchString, scope: selectedScope)
        return true
    }
    
    // Will handle the changes in the Scope Bar input
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        let scope = self.searchDisplayController.searchBar.scopeButtonTitles as [String]
        self.filterContentForSearchText(self.searchDisplayController.searchBar.text, scope: scope[searchOption])
        return true
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
