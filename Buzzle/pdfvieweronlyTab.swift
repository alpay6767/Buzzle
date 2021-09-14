//
//  pdfuploadView.swift
//  Gamers.ly
//
//  Created by Alpay Kücük on 15.08.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit
import PDFReader
import PMAlertController


class pdfvieweronlytab: UIViewController {
    
    
    @IBOutlet weak var containeer: UIView!
    
    
    var document : URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let documentpdf = PDFDocument(url: document!)!
        let readerController = PDFViewController.createNew(with: documentpdf)
        readerController.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        
        embed(readerController, inView: containeer)
        
        
        
    }
    
    
    @IBAction func abbrechen(_ sender: Any) {
        vibratePhone()
        self.dismiss(animated: true) {
            
        }
    }
    
}

