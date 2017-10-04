//
//  String.swift
//  Example
//
//  Created by Ade Septiadi on 5/8/17.
//  Copyright © 2017 Ade Septiadi. All rights reserved.
//

import Foundation

extension String{
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(_ from: Int) -> String {
        return self.substring(from: self.characters.index(self.startIndex, offsetBy: from))
    }
    
    /*
     Fungsi untuk menghitung jumlah karakter pada string
     */
    var length: Int {
        return self.characters.count
    }
    
    /*
     Fungsi untuk pengecekan apakah value string nil atau string empty
     Kondisi :
     - Jika string nil atau empty, akan mengembalikan nilai true
     - Jika string tidak nil atau empty, akan mengembalikan nilai false
     */
    func isNilOrEmpty()->Bool{
        if self == ""{
            return true
        }
        
        return false
    }
}
