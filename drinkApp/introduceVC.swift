//
//  introduceVC.swift
//  drinkApp
//
//  Created by 林祐辰 on 2020/10/3.
//

import UIKit

class introduceVC: UIViewController {

    
    @IBOutlet weak var slideShowImg: UIImageView!
    @IBOutlet var drinkCollection: [UIButton]!
    var pListData = [DrinkDB]()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAd()
        getDrinkData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    // 點選任一個飲料按鈕  將寫好的飲料資訊傳到下一頁,透過segue傳到下一頁
    
    @IBAction func pressBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "pickDrink", sender: sender)
    }

    @IBAction func unwindToIntroduceVC(_ unwindSegue: UIStoryboardSegue) {
    
    }
    

    // 取得Plist 資料
    
    func getDrinkData(){
        let dataURl = Bundle.main.url(forResource: "Menu", withExtension: "plist")!
        if let data = try?Data(contentsOf: dataURl),let renderData = try?PropertyListDecoder().decode([DrinkDB].self, from: data){
            self.pListData = renderData
       }
        
    }
    
    
//  輪播
    func getAd(){
        let adImage = ["banner1","banner2","banner3"]
        var playedImage = [UIImage]()
        
        for i in 0...adImage.count-1{
            playedImage.append(UIImage(named: "\(adImage[i])")!)
        }
        
        slideShowImg.animationImages = playedImage
        slideShowImg.animationDuration = 14
        slideShowImg.animationRepeatCount = 0
        slideShowImg.startAnimating()
        
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let showVC = segue.destination as? showDrinkVC ,let button = sender as? UIButton{
            let number = button.tag
            showVC.nonPListdata = allData[number]
            showVC.pListdata = pListData[number]
        }
    }

}
