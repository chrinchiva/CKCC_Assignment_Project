//
//  homeScreenTableViewController.swift
//  OnlineShoppingProject
//
//  Created by petersoeun on 12/25/17.
//  Copyright © 2017 RoboCam. All rights reserved.
//

import UIKit
import Firebase
class homeScreenTableViewController: UITableViewController {
var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
//        
//                if Auth.auth().currentUser != nil {
//                    let uid  = Auth.auth().currentUser?.uid
//                    ref.child("numberOfAllImage").observeSingleEvent(of: .value, with: { (snapshot) in
//                        print(snapshot)
//                        let value = snapshot.value as! Int? ?? 0
//                        //let result = Decimal(string: value)
//                        let myApp = MyApp.shared
//                        myApp.TotalProductNumber = value
//        
//                        print("Image productnumber is here:", MyApp.shared.TotalProductNumber)
//        
//        
//        
//                    }){(error) in
//                        print(error.localizedDescription)
//                    }
//        
//                }else{
//        
//                }
        
        fetchUser()
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    func fetchUser(){
        Database.database().reference().child("userprofiles").observe(.childAdded, with: { (snapshot) in
            // print("user found")
            //let user = User()
            
            print("start print fetch user: ")
            
            
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            let useremail  = value?["email"] as? String ?? ""
            let userphone = value?["phone"] as? String ?? ""
            let userImage = value?["image"] as? String ?? "default_image_select"
            let iemail = useremail
            let iphone = userphone
            let iuser = username
            var iimage = userImage
            print("Username:",iuser,"email:",iemail,"Image:",iimage)
            
            // iimage.append(userImage)
            
            //user.profileImage[1] = iimage
            //let myApp = MyApp.shared
            //myApp.profileImage[0] = iimage
            
            //print(MyApp.shared.profileImage)
            //  }
        }, withCancel: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "hello"
        cell.detailTextLabel?.text = "sub view"

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
