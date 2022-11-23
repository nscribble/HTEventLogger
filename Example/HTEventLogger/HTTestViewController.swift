//
//  HTTestViewController.swift
//  HTEventLogger_Example
//
//  Created by Jason on 2022/11/23.
//  Copyright © 2022 nscribble. All rights reserved.
//

import Foundation
import UIKit
import HTEventLogger

@objc
class HTTestViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn = UIButton(frame: CGRect(x: 100, y: 120, width: 120, height: 40))
        btn.backgroundColor = .yellow
        btn.setTitleColor(.black, for: .normal)
        btn.setTitle("测试", for: .normal)
        btn.addTarget(self, action: #selector(onTapBtn(_:)), for: .touchUpInside)
        
        self.view.addSubview(btn)
    }
    
    @objc
    func onTapBtn(_ sender: UIButton) {
        self.pel.log { builder in
            _ = builder.click("tap")
                .properties(["title": sender.title(for: .normal) ?? "btn"])
                .ext(["anykey": "anyvalue"])
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.pel.logPageExposure()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.pel.logPageQuit()
    }
}

extension HTTestViewController: PageEventLogging {
    override var pel_pageId: String {
        return "p122345"
    }
    
    override var pel_pageProperties: [String : String] {
        return ["skill": "flying"]
    }
}
