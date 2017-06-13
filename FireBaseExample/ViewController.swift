//
//  ViewController.swift
//  FireBaseExample
//
//  Created by lionel on 6/8/17.
//  Copyright © 2017 lionel. All rights reserved.
//

import UIKit

//importing firebase
import Firebase

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var refBanks: DatabaseReference!
    
    @IBOutlet weak var fetchBanks: UIButton!
    
    @IBOutlet weak var txtBankName: UITextField!
    @IBOutlet weak var txtBankBalance: UITextField!
    @IBOutlet weak var txtBankType: UITextField!
    
    @IBAction func goToUpdateBanks(_ sender: Any) {
        
        let objUpdateBanksViewController = self.storyboard?.instantiateViewController(withIdentifier: "UpdateBanksViewController") as! UpdateBanksViewController;
        ///objUpdateBanksViewController.oBank = oBank //pass on the object from the main screen
        self.navigationController?.pushViewController(objUpdateBanksViewController, animated: true);
    }
    @IBAction func addBankToFireBase(_ sender: Any) {
        if(self.txtBankName.text != "" &&
           self.txtBankType.text  != "" &&
            self.txtBankBalance.text != "")
        {
            addBank();
        }
        else{
            print("Missing information to write to database...");
        }
    }
    
    @IBAction func getBanks(_ sender: Any) {
        fetchBanksFireBase();
    }
    
    @IBOutlet weak var tvBankList: UITableView!
    
    var arrBanks = [
        Bank(BankName:"",BankType:"",BankBalance:0,fireBaseKey:"")
    ];
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvBankList.dataSource = self;
        tvBankList.delegate = self;
        
        //FirebaseApp.configure();
        refBanks  = Database.database().reference().child("Bank")
        
    }

    func addBank()
    {
      let key = refBanks.childByAutoId().key
      let bank = ["id":key,
                  "BankName": self.txtBankName.text! as String,
                  "BankType": self.txtBankType.text! as String,
                  "BankBalance":self.txtBankBalance.text! as String
                  ]
        refBanks.child(key).setValue(bank);
        fetchBanksFireBase();
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*TABLEVIEW DELEGATE METHODS  */
    /*The "2" below are the minimum required for the  UITableViewDelegate protocol */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrBanks.count;
    }
    
    /*required for UITableViewDelegate */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell();
        
        //question structure, not a static string for our row data
        var currentBank: Bank!;
        currentBank = arrBanks[indexPath.row];
        
        //use the name property to set the value of the cell
        cell.textLabel?.text = currentBank.BankName! +   " Balance: \(currentBank.BankBalance!)";
        
        //set cell to transparent
        cell.backgroundColor = UIColor.clear;
        return cell;
        
    }
    
    //for adding swipe behavior
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let AddAccountAction = UITableViewRowAction(style: .default, title: "View Bank Detail", handler:
        {
            //closure parameters
            action,indexPath in
            
            
            tableView.reloadData();
            //tell the table view it's done editing
            tableView.isEditing = false;
            
            //let's create an Object and and pass all values
            var oBank = Bank();
            oBank.BankName = self.arrBanks[indexPath.row].BankName;
            oBank.BankBalance = self.arrBanks[indexPath.row].BankBalance;
            oBank.BankType = self.arrBanks[indexPath.row].BankType;
            oBank.fireBaseKey = self.arrBanks[indexPath.row].fireBaseKey;
            
            
        let objUpdateBanksViewController = self.storyboard?.instantiateViewController(withIdentifier: "UpdateBanksViewController") as! UpdateBanksViewController;
            objUpdateBanksViewController.oBank = oBank //pass on the object from the main screen
            self.navigationController?.pushViewController(objUpdateBanksViewController, animated: true);
 
        });
        
        
        //let actions = [likeAction,DislikeAction,CommentsAction]
        let actions = [AddAccountAction]
        return actions;
        
    }

    
    func fetchBanksFireBase()
    {
        //refBanks.queryOrdered(byChild: "BankType").queryEqual(toValue: "Investment").observe(DataEventType.value, with: 
        refBanks.observe(DataEventType.value, with:
        {(snapshot) in
            //if the reference has some values 
            if snapshot.childrenCount > 0 {
                
                self.arrBanks.removeAll();
                
               //iterate through all the values
                for banks in snapshot.children.allObjects as! [DataSnapshot] {
                    //grabbing values
                    let bankObject = banks.value as? [String: AnyObject];
                    let bankName =  bankObject?["BankName"];
                    let bankType =  bankObject?["BankType"];
                    let bankBalance = bankObject?["BankBalance"];
                    let bankKey = bankObject?["id"];
                    
                    //creating bank object with model and fetched values
                    let bank = Bank(BankName: (bankName as! String), BankType: (bankType as! String), BankBalance: (bankBalance as! NSString).doubleValue,fireBaseKey: (bankKey as! String));
                    
                    self.arrBanks.append(bank)
                }
         
            //reload the tableview's data
                self.tvBankList.reloadData();
                
          } //if snapshot.children > 0 {
            
        })
    }


}

