//
//  TableViewForTodoList.swift
//  Todoey
//
//  Created by Mohammad Peighami on 11/30/1397 AP.
//  Copyright © 1397 Mohammad Peighami. All rights reserved.
//

import UIKit

class TableViewForTodoList: UITableView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        super.insertRows(at: indexPaths, with: UITableView.RowAnimation.none)
        
        endUpdates()
        beginUpdates()
        
        for indexPath in indexPaths {
            if let cell = cellForRow(at: indexPath) {
                
                var frame:CGRect = (cell.frame)
                let originX = cell.frame.origin.x
                let originY = cell.frame.origin.y
                let r = self.frame.width
                var values = [Dictionary<String, CGFloat>]()
                for n in 0...91 {
                    if n != 91 {
                        let x = cos(CGFloat(n) * CGFloat.pi / 180) * r
                        let y = sin(CGFloat(n) * CGFloat.pi / 180) * r
                        let dic = ["x": x, "y": y]
                        values.append(dic)
                    } else {
                        let x = originX
                        let y = originY
                        let dic = ["x": x, "y": y]
                        values.append(dic)
                    }
                }

                frame.origin.x = values[0]["x"]!
                frame.origin.y = self.frame.size.width - values[0]["y"]!
                print(self.frame.size.height)
                cell.frame = frame
                
                UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: .calculationModePaced, animations: {
                    for n in 0...91 {
                        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4 / 91, animations: {
                            cell.frame = frame;
                            frame.origin.x = values[n]["x"]!
                            frame.origin.y = self.frame.size.width + originY - values[n]["y"]!
                        })
                    }

                }, completion: nil)
            }
        }
        
    }

}
