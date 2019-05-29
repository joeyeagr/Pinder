//
//  LoadingViewController.swift
//  Pinder
//
//  Created by Tyler Donohue on 5/29/19.
//  Copyright © 2019 Joe Eagar. All rights reserved.
//

import Firebase
import UIKit

class LoadingViewController: UIViewController {

    var currentAuthID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(currentAuthID)
        checkForId()
    }
    
    func checkForId() {
        guard let id: String? = self.currentAuthID else { return }
        if id == nil {
            performSegue(withIdentifier: "TransitionToLogIn", sender: nil)
        } else {
            print("to account")
            performSegue(withIdentifier: "TransitionToAcount", sender: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
