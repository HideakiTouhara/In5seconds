//
//  ViewController.swift
//  In5minutes
//
//  Created by HideakiTouhara on 2017/08/22.
//  Copyright © 2017年 HideakiTouhara. All rights reserved.
//

import UIKit

class SearchTopViewController: UIViewController {
    
    @IBOutlet weak var basicCard: UIView!
    @IBOutlet weak var meat: UIView!
    @IBOutlet weak var jfood: UIView!
    @IBOutlet weak var cfood: UIView!
    @IBOutlet weak var bread: UIView!
    @IBOutlet weak var pasta: UIView!
    
    @IBOutlet weak var thumbImageView: UIImageView!
    
    
    var cards = [UIView]()
    
    var selectedCardCount = 0
    
    var preQueries = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cards.append(meat)
        cards.append(jfood)
        cards.append(cfood)
        cards.append(bread)
        cards.append(pasta)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushShopList" {
            let vc = segue.destination as! ShopListViewController
            selectQueries(preQueries: preQueries, vc: vc)
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        
        if(selectedCardCount >= cards.count){
            return
        }
        
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        cards[selectedCardCount].center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        card.transform = CGAffineTransform(rotationAngle: 0.61 * (xFromCenter / (view.frame.width / 2)))
        cards[selectedCardCount].transform = CGAffineTransform(rotationAngle: 0.61 * (xFromCenter / (view.frame.width / 2)))
        
        if xFromCenter > 0 {
            thumbImageView.image = #imageLiteral(resourceName: "good")
            thumbImageView.tintColor = UIColor.green
        } else {
            thumbImageView.image = #imageLiteral(resourceName: "bad")
            thumbImageView.tintColor = UIColor.red
        }
        
        thumbImageView.alpha = abs(xFromCenter) / (view.bounds.size.width / 2)
        
        if sender.state ==  UIGestureRecognizerState.ended {
            
            if card.center.x < 75 {
                UIView.animate(withDuration: 0.05, animations: {
                    self.cards[self.selectedCardCount].center = CGPoint(x: self.cards[self.selectedCardCount].center.x - 300, y: self.cards[self.selectedCardCount].center.y)
                })
                card.center = self.view.center
                card.transform = CGAffineTransform.identity
                self.thumbImageView.alpha = 0
                
                if(selectedCardCount < cards.count - 1){
                    selectedCardCount += 1
                } else {
                    performSegue(withIdentifier: "PushShopList", sender: self)
                }
                return
                
            } else if card.center.x > (view.frame.width - 75) {
                UIView.animate(withDuration: 0.05, animations: {
                    self.cards[self.selectedCardCount].center = CGPoint(x: self.cards[self.selectedCardCount].center.x + 300, y: self.cards[self.selectedCardCount].center.y)
                })
                card.center = self.view.center
                card.transform = CGAffineTransform.identity
                self.thumbImageView.alpha = 0
                
                preQueries.append(cards[selectedCardCount].restorationIdentifier!)
                
                if(selectedCardCount < cards.count - 1){
                    selectedCardCount += 1
                } else {
                    performSegue(withIdentifier: "PushShopList", sender: self)
                }
                return
            }
            UIView.animate(withDuration: 0.05, animations: {
                card.center = self.view.center
                card.transform = CGAffineTransform.identity
                self.cards[self.selectedCardCount].center = self.view.center
                self.cards[self.selectedCardCount].transform = CGAffineTransform.identity
                self.thumbImageView.alpha = 0
            })
        }
    }
    
    func selectQueries(preQueries: [String], vc: ShopListViewController) {
        var selectedQuery = [String]()
        for query in preQueries {
            if query == "meat" {
                selectedQuery.append("ステーキ")
            } else if query == "jfood" {
                selectedQuery.append("寿司")
            } else if query == "cfood" {
                selectedQuery.append("ラーメン")
            } else if query == "bread" {
                selectedQuery.append("パン")
            } else if query == "pasta" {
                selectedQuery.append("パスタ")
            }
        }
        
        var qc: QueryCondition = QueryCondition()
        var success: Bool = false
        
        switch selectedQuery.count {
        case 0:
            qc.query = "うどん"
            vc.yls.loadData(condition: qc, reset: true, startNumber: 1)
            qc.query = "牛丼"
            vc.yls.loadData(condition: qc, startNumber: 2)
            qc.query = "肉"
            vc.yls.loadData(condition: qc, startNumber: 3)
            break
        case 1:
            qc.query = selectedQuery[0]
            vc.yls.loadData(condition: qc, reset: true, startNumber: 1)
            vc.yls.loadData(condition: qc, startNumber: 2)
            vc.yls.loadData(condition: qc, startNumber: 3)
            break
        case 2:
            qc.query = selectedQuery[0]
            vc.yls.loadData(condition: qc, reset: true, startNumber: 1)
            qc.query = selectedQuery[1]
            vc.yls.loadData(condition: qc, startNumber: 1)
            vc.yls.loadData(condition: qc, startNumber: 2)
            break
        case 3:
            qc.query = selectedQuery[0]
            vc.yls.loadData(condition: qc, reset: true, startNumber: 1)
            qc.query = selectedQuery[1]
            vc.yls.loadData(condition: qc, startNumber: 1)
            qc.query = selectedQuery[2]
            vc.yls.loadData(condition: qc, startNumber: 2)
            break
        case 4:
            selectedQuery.remove(at: Int(arc4random_uniform(4)))
            qc.query = selectedQuery[0]
            vc.yls.loadData(condition: qc, reset: true, startNumber: 1)
            qc.query = selectedQuery[1]
            vc.yls.loadData(condition: qc, startNumber: 1)
            qc.query = selectedQuery[2]
            vc.yls.loadData(condition: qc, startNumber: 2)
            break
        case 5:
            selectedQuery.remove(at: Int(arc4random_uniform(5)))
            selectedQuery.remove(at: Int(arc4random_uniform(4)))
            qc.query = selectedQuery[0]
            vc.yls.loadData(condition: qc, reset: true, startNumber: 1)
            qc.query = selectedQuery[1]
            vc.yls.loadData(condition: qc, startNumber: 1)
            qc.query = selectedQuery[2]
            vc.yls.loadData(condition: qc, startNumber: 2)
            break
        default:
            qc.query = "うどん"
            vc.yls.loadData(condition: qc, reset: true, startNumber: 1)
            qc.query = "牛丼"
            vc.yls.loadData(condition: qc, startNumber: 2)
            qc.query = "肉"
            vc.yls.loadData(condition: qc, startNumber: 3)
            break
        }
    }


}

