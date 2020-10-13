//
//  showDrinkVC.swift
//  drinkApp
//
//  Created by 林祐辰 on 2020/9/27.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


class showDrinkVC: UIViewController {

    var nonPListdata:PassChooseData?
    var pListdata : DrinkDB?
       
    @IBOutlet weak var drinkPicture: UIImageView!
    @IBOutlet weak var drinkName: UILabel!
    @IBOutlet weak var showFixedPrice: UILabel!
    @IBOutlet weak var personName: UITextField!
    @IBOutlet weak var orderCupSize: UISegmentedControl!
    @IBOutlet weak var orderSweetness: UISegmentedControl!
    @IBOutlet weak var orderIce: UISegmentedControl!
 
    var imageNum = ""
    var pickedDrink:String?
    var drinkDefaultPrice:Int?
    var fixedCupPrice:Int?

override func viewDidLoad() {
        super.viewDidLoad()
        
         if let nonpList = nonPListdata{
             imageNum = nonpList.pictureName
             drinkPicture.image = UIImage(named:"\(imageNum)")
          }
        
        if let plist = pListdata{
           pickedDrink  = plist.drink
           drinkDefaultPrice = plist.option[0].price
           drinkName.text = pickedDrink
           showFixedPrice.text = "$ \(drinkDefaultPrice!)"
           fixedCupPrice = drinkDefaultPrice
       }
     }
    
    
    var needFix:Order?
    var person = ""
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        
        personName.text = person
        drinkName.text = pickedDrink
        showFixedPrice.text = "$ \(fixedCupPrice!)"
        drinkPicture.image = UIImage(named:"\(imageNum)")
       
        
        switch sweetness {
        case .none:
            orderSweetness.selectedSegmentIndex = 0
        case .quarter:
            orderSweetness.selectedSegmentIndex = 1
        case .half:
            orderSweetness.selectedSegmentIndex = 2
        case .threeFour:
            orderSweetness.selectedSegmentIndex = 3
        case .full:
            orderSweetness.selectedSegmentIndex = 4

        }
     
        switch ice {
        case .none:
            orderIce.selectedSegmentIndex = 0
        case .light:
            orderIce.selectedSegmentIndex = 1
        case .full:
            orderIce.selectedSegmentIndex = 2
        case .hot:
            orderIce.selectedSegmentIndex = 3
        }
        
     switch drinkSize {
       case .bigBubble:
         orderCupSize.selectedSegmentIndex = 3
       case .big:
         orderCupSize.selectedSegmentIndex = 2
       case .mediumBubble:
         orderCupSize.selectedSegmentIndex = 1
       case .medium:
         orderCupSize.selectedSegmentIndex = 0
        }
    }
    
    var drinkSize:DrinkSize = .medium
    @IBAction func pickCupSize(_ sender: Any) {

        if orderCupSize.selectedSegmentIndex == 3{
            drinkSize = DrinkSize.bigBubble
            if (pickedDrink == "冷露歐蕾"||pickedDrink == "熟成歐蕾"||pickedDrink == "白玉歐蕾"){
                fixedCupPrice = drinkDefaultPrice!+20
                showFixedPrice.text = "$ \(fixedCupPrice!)"
            }else{
                fixedCupPrice = drinkDefaultPrice!+15
                showFixedPrice.text = "$ \(fixedCupPrice!)"
            }
        }else if orderCupSize.selectedSegmentIndex == 2{
            drinkSize = DrinkSize.big
            if (pickedDrink == "冷露歐蕾"||pickedDrink == "熟成歐蕾"||pickedDrink == "白玉歐蕾"){
            fixedCupPrice = drinkDefaultPrice!+10
            showFixedPrice.text = "$ \(fixedCupPrice!)"
          }else{
            fixedCupPrice = drinkDefaultPrice!+5
            showFixedPrice.text = "$ \(fixedCupPrice!)"
           }
        }else if orderCupSize.selectedSegmentIndex == 1{
            drinkSize = DrinkSize.mediumBubble
            fixedCupPrice = drinkDefaultPrice!+10
            showFixedPrice.text = "$ \(fixedCupPrice!)"
        }else{
            drinkSize = DrinkSize.medium
            fixedCupPrice = drinkDefaultPrice
            showFixedPrice.text = "$ \(fixedCupPrice!)"
        }
    }
    
    var sweetness:SweetLevel = .none
    @IBAction func pickSweetness(_ sender: Any) {
        switch orderSweetness.selectedSegmentIndex {
        case 0:
            sweetness = SweetLevel.none
        case 1:
            sweetness = SweetLevel.quarter
        case 2:
            sweetness = SweetLevel.half
        case 3:
            sweetness = SweetLevel.threeFour
        case 4:
            sweetness = SweetLevel.full
        default:
            sweetness = SweetLevel.none
        }
    }
    
    
    var ice :Ice = .none
    @IBAction func pickIce(_ sender: Any) {
        switch orderIce.selectedSegmentIndex {
        case 0:
            ice = Ice.none
        case 1:
            ice = Ice.light
        case 2:
            ice = Ice.full
        case 3:
            ice = Ice.hot
        default:
            ice = Ice.none
        }
    }
    
    var drink:Order?
    var storedData :Firestore!
    //  var docRef :DocumentReference!
    var id = UUID().uuidString

    

    @IBAction func createOrder(_ sender: Any) {
        storedData = Firestore.firestore()
        //   以前寫法 (要將資料型別一率轉成 [String: Any])
        //    let drink :[String:Any] = ["item":pickedDrink!, "name": personName.text!, "size": drinkSize, "sweetness": sweetness, "ice": ice, "price": fixedCupPrice!]

        drink = Order(id:id, item: pickedDrink!, name: personName.text!, drinkSize: drinkSize, sweetness: sweetness, ice: ice, defaultPrice:drinkDefaultPrice!, fixedPrice: fixedCupPrice!, imageIndex: imageNum)
        
        do {
         //   使用SPM後的寫法 可以直接使用自訂型別,讓CloudFireBase 幫你生出Document ID
         //  docRef = try storedData.collection("drinks").addDocument(from: drink)
            
         // 使用Swift生成ID 的方式 設定 DocumentID
           try storedData.collection("drinks").document("\(id)").setData(from: drink)
          }catch {
           print(error)
          }
       }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if personName.text?.isEmpty == true{
         let alertScreen = UIAlertController(title: "名字沒有打喔", message: "幫我打一下吧", preferredStyle: .alert)
         let alertBtn = UIAlertAction(title: "Ok", style: .default, handler: nil)
         alertScreen.addAction(alertBtn)
         present(alertScreen, animated: true, completion: nil)
            return false
        }else{
            return true
        }
    }
}
