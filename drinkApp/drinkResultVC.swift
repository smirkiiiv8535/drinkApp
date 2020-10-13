//
//  drinkResultVC.swift
//  drinkApp
//
//  Created by 林祐辰 on 2020/9/27.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class drinkResultVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var drinkTable: UITableView!
    
    @IBOutlet weak var drinkCount: UILabel!
    @IBOutlet weak var drinkMoney: UILabel!
    
    
    var db :Firestore!
    var finalOrder = [Order]()
    var priceBox = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drinkTable.delegate = self
        drinkTable.dataSource = self
        db = Firestore.firestore()
        loading()
        fetchDrinks()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    func loading(){
       loadingIndicator.startAnimating()
    }
    func stopLoading(){
        loadingIndicator.stopAnimating()
        loadingIndicator.hidesWhenStopped = true
    }

    func fetchDrinks(){
        db.collection("drinks").getDocuments {(snapshot, error) in
           if let error = error{
                print(error)
            }else if let snapshotData = snapshot {
                let downloadDrinks = snapshotData.documents.compactMap { (snapshotData) in
                    try? snapshotData.data(as: Order.self)
                }
                self.finalOrder = downloadDrinks
                print(downloadDrinks)
          }
        
        DispatchQueue.main.async {
            self.drinkTable.reloadData()
            self.updateAddOrder()
            self.stopLoading()
         }
    }
}
    
    var totalPrice = 0
    func updateAddOrder(){
        drinkCount.text = "\(finalOrder.count)"
        for i in 0..<finalOrder.count{
              let sumMoney = finalOrder[i].fixedPrice
              priceBox.append(sumMoney)
              totalPrice = priceBox.reduce(0, +)
        }
        drinkMoney.text = "\(totalPrice)"
    }
       
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finalOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = drinkTable.dequeueReusableCell(withIdentifier: "finalDrinkCell", for: indexPath) as? finalDrinkReuseCell
        let selectedDrink = finalOrder[indexPath.row]
        
        cell?.finalDrink.text = selectedDrink.item
        cell?.finalOrderPerson.text = selectedDrink.name
        cell?.drinkFinalSize.text = selectedDrink.drinkSize.rawValue
        cell?.drinkFinalSugar.text = selectedDrink.sweetness.rawValue
        cell?.drinkFinalIce.text = selectedDrink.ice.rawValue
        cell?.drinkFinalPrice.text = "$ \(selectedDrink.fixedPrice)"
        cell?.drinkImage.image = UIImage(named: "\(selectedDrink.imageIndex)")
        return cell!
    }
    
    func deleteDrinks(drinks:Order){
        db.collection("drinks").document(drinks.id).delete()
   }
    
    func updateMinusOrder(number:Int){
        drinkCount.text = "\(finalOrder.count)"
        priceBox.remove(at: number)
        totalPrice = priceBox.reduce(0, +)
        drinkMoney.text = "\(totalPrice)"
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doDelete = UIContextualAction(style: .destructive, title: "刪訂單") { [self] (action, view, completion) in
            let orderNumber = indexPath.row
            self.deleteDrinks(drinks: self.finalOrder[orderNumber])
            self.finalOrder.remove(at: orderNumber)
            self.drinkTable.deleteRows(at: [indexPath], with: .fade)
            self.updateMinusOrder(number:orderNumber)
        }
    
        let doEdit = UIContextualAction(style: .normal, title: "修改訂單") { [self] (action, view, completion) in
           self.performSegue(withIdentifier: "editDrinks", sender: indexPath.row)
        }
        
        doEdit.backgroundColor = .cyan
        var swipeAction = UISwipeActionsConfiguration()
        swipeAction = UISwipeActionsConfiguration(actions: [doDelete,doEdit])
        swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let orderVC = segue.destination as? showDrinkVC
        let sender = sender as! Int
        let needFixedOrder = finalOrder[sender]
        
        orderVC!.id = needFixedOrder.id
        orderVC!.drinkDefaultPrice = needFixedOrder.defaultPrice
        orderVC!.fixedCupPrice = needFixedOrder.fixedPrice
        orderVC!.pickedDrink = needFixedOrder.item
        orderVC!.person = needFixedOrder.name
        orderVC!.imageNum = needFixedOrder.imageIndex
        
        switch needFixedOrder.sweetness {
            case SweetLevel.none:
                orderVC!.sweetness = .none
            case SweetLevel.quarter:
                orderVC!.sweetness = .quarter
            case SweetLevel.half:
                orderVC!.sweetness = .half
            case SweetLevel.threeFour:
                orderVC!.sweetness = .threeFour
            case SweetLevel.full:
                orderVC!.sweetness = .full
            }

        switch needFixedOrder.ice {
           case Ice.none:
                orderVC!.ice = .none
           case Ice.light:
                orderVC!.ice = .light
           case Ice.full:
                orderVC!.ice = .full
           case Ice.hot:
                orderVC!.ice = .hot
        }

        switch needFixedOrder.drinkSize {
            case DrinkSize.bigBubble:
                orderVC?.drinkSize = .bigBubble
            case DrinkSize.big:
                orderVC!.drinkSize = .big
            case DrinkSize.mediumBubble:
                orderVC!.drinkSize = .mediumBubble
            case DrinkSize.medium:
                orderVC!.drinkSize = .medium
            }
   }
    
   }

