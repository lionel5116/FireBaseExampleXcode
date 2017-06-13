//
//  UpdateBanksViewController.swift
//  FireBaseExample
//
//  Created by lionel on 6/10/17.
//  Copyright © 2017 lionel. All rights reserved.
//

import UIKit
import Firebase


class UpdateBanksViewController: UIViewController {
    
    var refBanks: DatabaseReference!
    
    var oBank = Bank();
    var fireBaseKey:String?;
    
    
    @IBAction func goToManageExpenses(_ sender: Any) {
        
        let objManageExpenseViewController = self.storyboard?.instantiateViewController(withIdentifier: "ManageExpenseViewController") as! ManageExpenseViewController;
        //objUpdateBanksViewController.oBank = oBank //pass on the object from the main screen
        self.navigationController?.pushViewController(objManageExpenseViewController, animated: true);
    
    }


    @IBOutlet weak var lblFireBaseKey: UILabel!
    @IBOutlet weak var txtBankName: UITextField!
    @IBOutlet weak var txtBankType: UITextField!
    @IBOutlet weak var txtBankBalance: UITextField!
    
    @IBAction func updateBank(_ sender: Any) {
        updateBankFirebase();
    }
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.txtBankName.text = oBank.BankName;
        self.txtBankType.text = oBank.BankType;
        self.txtBankBalance.text = String(describing: oBank.BankBalance!)
        fireBaseKey = oBank.fireBaseKey;
        lblFireBaseKey.text = fireBaseKey;
        
        refBanks  = Database.database().reference().child("Bank")
        
    }

    func updateBankFirebase()
    {
        let key = oBank.fireBaseKey
        let bankBalance:String? = self.txtBankBalance.text;
        let updateBank = ["BankName":oBank.BankName!,"BankType":self.txtBankType.text!,"BankBalance":bankBalance,"id":key!]
        refBanks.child(key!).setValue(updateBank)
        lblFireBaseKey.text = "Record updated..."
    };
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
