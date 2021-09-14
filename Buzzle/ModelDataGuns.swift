//
//  ModelData.swift
//  CallOfInfo
//
//  Created by Alpay Kücük on 28.04.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import Foundation
import UIKit


class ModelDataGuns {
    
    var menupunkte = [MenuPunkt]()
    
    var sturmgewehre = [Waffe]()
    var lmgs = [Waffe]()
    var schrotflinten = [Waffe]()
    var mgs = [Waffe]()
    var gewehre = [Waffe]()
    var sniper = [Waffe]()
    var pistolen = [Waffe]()
    var werfer = [Waffe]()
    
    var eroberungmaps = [Map]()
    var maps2v2 = [Map]()
    
    var allewaffen = [Waffe]()
    var allemaps = [Map]()
    
    var waffenarten = [String]()
    var maparten = [String]()
    
    init() {
        initwaffenarten()
        initmaparten()
        //initMenuPunkte()
        initWaffen()
        initalleWaffen()
        initMaps()
    }
    
    func initwaffenarten() {
        waffenarten.append("Assault Rifles")
        waffenarten.append("Submachine Guns")
        waffenarten.append("Shotguns")
        waffenarten.append("Light Machine Guns")
        waffenarten.append("Marksman Rifles")
        waffenarten.append("Sniper Rifles")
        waffenarten.append("Handguns")
        waffenarten.append("Launchers")
    }
    
    func initmaparten() {
        maparten.append("Default Maps")
        maparten.append("2 vs 2 Maps")
        
    }
    
    func initMenuPunkte() {
        let menupunkt1 = MenuPunkt(name: "Guns", bild: UIImage(named: "waffen")!)
        let menupunkt2 = MenuPunkt(name: "Maps", bild: UIImage(named: "maps")!)
        let menupunkt3 = MenuPunkt(name: "Modis", bild: UIImage(named: "modis")!)
        
        menupunkte.append(menupunkt1)
        menupunkte.append(menupunkt2)
        //menupunkte.append(menupunkt3)
    }
    
    func initalleWaffen() {
        allewaffen.append(contentsOf: sturmgewehre)
        allewaffen.append(contentsOf: lmgs)
        allewaffen.append(contentsOf: schrotflinten)
        allewaffen.append(contentsOf: mgs)
        allewaffen.append(contentsOf: gewehre)
        allewaffen.append(contentsOf: sniper)
        allewaffen.append(contentsOf: pistolen)
        allewaffen.append(contentsOf: werfer)
    }
    
    func initWaffen() {
        initSturmgewehre()
        initlmgs()
        initSchrotflinten()
        initmgs()
        initgewehre()
        initSniper()
        initpistolen()
        initWerfer()
    }
    
    func initSturmgewehre() {
        let sturmgewehr1 = Waffe(id: "1", name: "Kilo 141", bild: UIImage(named: "w1")!, genauigkeit: 75, schaden: 80, reichweite: 70, feuerrate: 72, mobilität: 67, kontrolle: 80)
        let sturmgewehr2 = Waffe(id: "2", name: "FAL", bild: UIImage(named: "w2")!, genauigkeit: 75, schaden: 77, reichweite: 68, feuerrate: 64, mobilität: 60, kontrolle: 65)
        let sturmgewehr3 = Waffe(id: "3", name: "M4A1", bild: UIImage(named: "w3")!, genauigkeit: 77, schaden: 78, reichweite: 70, feuerrate: 74, mobilität: 70, kontrolle: 79)
        let sturmgewehr4 = Waffe(id: "4", name: "FR 5.56", bild: UIImage(named: "w4")!, genauigkeit: 76, schaden: 78, reichweite: 70, feuerrate: 80, mobilität: 65, kontrolle: 79)
        let sturmgewehr5 = Waffe(id: "5", name: "Oden", bild: UIImage(named: "w5")!, genauigkeit: 73, schaden: 83, reichweite: 76, feuerrate: 60, mobilität: 61, kontrolle: 63)
        let sturmgewehr6 = Waffe(id: "6", name: "M13", bild: UIImage(named: "w6")!, genauigkeit: 75, schaden: 74, reichweite: 70, feuerrate: 74, mobilität: 68, kontrolle: 79)
        let sturmgewehr7 = Waffe(id: "7", name: "FN Scar 17", bild: UIImage(named: "w7")!, genauigkeit: 72, schaden: 79, reichweite: 74, feuerrate: 69, mobilität: 61, kontrolle: 70)
        let sturmgewehr8 = Waffe(id: "8", name: "AK-74", bild: UIImage(named: "w8")!, genauigkeit: 75, schaden: 80, reichweite: 75, feuerrate: 71, mobilität: 70, kontrolle: 75)
        let sturmgewehr9 = Waffe(id: "9", name: "RAM-7", bild: UIImage(named: "w9")!, genauigkeit: 72, schaden: 76, reichweite: 60, feuerrate: 70, mobilität: 72, kontrolle: 76)
        let sturmgewehr10 = Waffe(id: "10", name: "Grau 5.56", bild: UIImage(named: "w10")!, genauigkeit: 76, schaden: 79, reichweite: 72, feuerrate: 71, mobilität: 70, kontrolle: 76)
    
        sturmgewehre.append(sturmgewehr1)
        sturmgewehre.append(sturmgewehr2)
        sturmgewehre.append(sturmgewehr3)
        sturmgewehre.append(sturmgewehr4)
        sturmgewehre.append(sturmgewehr5)
        sturmgewehre.append(sturmgewehr6)
        sturmgewehre.append(sturmgewehr7)
        sturmgewehre.append(sturmgewehr8)
        sturmgewehre.append(sturmgewehr9)
        sturmgewehre.append(sturmgewehr10)
        
    }
    
    func initlmgs() {
        let lmg1 = Waffe(id: "11", name: "AUG", bild: UIImage(named: "w11")!, genauigkeit: 70, schaden: 55, reichweite: 59, feuerrate: 80, mobilität: 70, kontrolle: 75)
        let lmg2 = Waffe(id: "12", name: "P90", bild: UIImage(named: "w12")!, genauigkeit: 50, schaden: 50, reichweite: 50, feuerrate: 85, mobilität: 80, kontrolle: 83)
        let lmg3 = Waffe(id: "13", name: "MP5", bild: UIImage(named: "w13")!, genauigkeit: 60, schaden: 50, reichweite: 53, feuerrate: 80, mobilität: 82, kontrolle: 76)
        let lmg4 = Waffe(id: "14", name: "Uzi", bild: UIImage(named: "w14")!, genauigkeit: 55, schaden: 50, reichweite: 46, feuerrate: 75, mobilität: 77, kontrolle: 70)
        let lmg5 = Waffe(id: "15", name: "PP19 Bizon", bild: UIImage(named: "w15")!, genauigkeit: 60, schaden: 55, reichweite: 52, feuerrate: 75, mobilität: 74, kontrolle: 70)
        let lmg6 = Waffe(id: "16", name: "MP7", bild: UIImage(named: "w16")!, genauigkeit: 60, schaden: 42, reichweite: 45, feuerrate: 85, mobilität: 80, kontrolle: 76)
        let lmg7 = Waffe(id: "17", name: "Striker 45", bild: UIImage(named: "w17")!, genauigkeit: 70, schaden: 68, reichweite: 68, feuerrate: 75, mobilität: 76, kontrolle: 77)
        
        lmgs.append(lmg1)
        lmgs.append(lmg2)
        lmgs.append(lmg3)
        lmgs.append(lmg4)
        lmgs.append(lmg5)
        lmgs.append(lmg6)
        lmgs.append(lmg7)
        
        
    }
    
    func initSchrotflinten() {
        
        let schrotflinte1 = Waffe(id: "18", name: "Model 680", bild: UIImage(named: "w18")!, genauigkeit: 65, schaden: 90, reichweite: 45, feuerrate: 42, mobilität: 70, kontrolle: 67)
        let schrotflinte2 = Waffe(id: "19", name: "R9-0 Shotgun", bild: UIImage(named: "w19")!, genauigkeit: 55, schaden: 80, reichweite: 40, feuerrate: 50, mobilität: 70, kontrolle: 72)
        let schrotflinte3 = Waffe(id: "20", name: "725", bild: UIImage(named: "w20")!, genauigkeit: 75, schaden: 90, reichweite: 60, feuerrate: 50, mobilität: 66, kontrolle: 56)
        let schrotflinte4 = Waffe(id: "21", name: "Origin 12 Shotgun", bild: UIImage(named: "w21")!, genauigkeit: 50, schaden: 80, reichweite: 35, feuerrate: 55, mobilität: 75, kontrolle: 71)
        let schrotflinte5 = Waffe(id: "22", name: "VLK Rogue", bild: UIImage(named: "w22")!, genauigkeit: 60, schaden: 80, reichweite: 45, feuerrate: 50, mobilität: 80, kontrolle: 75)
        
        schrotflinten.append(schrotflinte1)
        schrotflinten.append(schrotflinte2)
        schrotflinten.append(schrotflinte3)
        schrotflinten.append(schrotflinte4)
        schrotflinten.append(schrotflinte5)

    }
    
    
    func initmgs() {
        
        let mg1 = Waffe(id: "23", name: "PKM", bild: UIImage(named: "w23")!, genauigkeit: 75, schaden: 77, reichweite: 75, feuerrate: 68, mobilität: 45, kontrolle: 60)
        let mg2 = Waffe(id: "24", name: "SA87", bild: UIImage(named: "w24")!, genauigkeit: 77, schaden: 79, reichweite: 80, feuerrate: 60, mobilität: 50, kontrolle: 75)
        let mg3 = Waffe(id: "25", name: "M91", bild: UIImage(named: "w25")!, genauigkeit: 80, schaden: 81, reichweite: 83, feuerrate: 60, mobilität: 46, kontrolle: 60)
        let mg4 = Waffe(id: "26", name: "MG34", bild: UIImage(named: "w26")!, genauigkeit: 75, schaden: 77, reichweite: 79, feuerrate: 75, mobilität: 46, kontrolle: 74)
        let mg5 = Waffe(id: "27", name: "Holger-26", bild: UIImage(named: "w27")!, genauigkeit: 80, schaden: 74, reichweite: 82, feuerrate: 74, mobilität: 46, kontrolle: 72)
        
        mgs.append(mg1)
        mgs.append(mg2)
        mgs.append(mg3)
        mgs.append(mg4)
        mgs.append(mg5)
        
        
    }
    
    
    func initgewehre() {
        
        let gewehr1 = Waffe(id: "28", name: "EBR-14", bild: UIImage(named: "w28")!, genauigkeit: 75, schaden: 74, reichweite: 71, feuerrate: 55, mobilität: 59, kontrolle: 72)
        let gewehr2 = Waffe(id: "29", name: "MK2 Carbine", bild: UIImage(named: "w29")!, genauigkeit: 80, schaden: 81, reichweite: 73, feuerrate: 60, mobilität: 63, kontrolle: 60)
        let gewehr3 = Waffe(id: "30", name: "Kar98K", bild: UIImage(named: "w30")!, genauigkeit: 77, schaden: 80, reichweite: 75, feuerrate: 46, mobilität: 50, kontrolle: 73)
        let gewehr4 = Waffe(id: "31", name: "Crossbow", bild: UIImage(named: "w31")!, genauigkeit: 75, schaden: 85, reichweite: 60, feuerrate: 30, mobilität: 75, kontrolle: 66)
        
        gewehre.append(gewehr1)
        gewehre.append(gewehr2)
        gewehre.append(gewehr3)
        gewehre.append(gewehr4)
        
    }
    
    
    func initSniper() {
        
        let sniper1 = Waffe(id: "32", name: "Dragunov", bild: UIImage(named: "w32")!, genauigkeit: 80, schaden: 76, reichweite: 75, feuerrate: 46, mobilität: 46, kontrolle: 73)
        let sniper2 = Waffe(id: "33", name: "HDR", bild: UIImage(named: "w33")!, genauigkeit: 86, schaden: 82, reichweite: 86, feuerrate: 43, mobilität: 46, kontrolle: 75)
        let sniper3 = Waffe(id: "34", name: "AX-50", bild: UIImage(named: "w34")!, genauigkeit: 86, schaden: 90, reichweite: 81, feuerrate: 48, mobilität: 48, kontrolle: 70)
        
        
        sniper.append(sniper1)
        sniper.append(sniper2)
        sniper.append(sniper3)
        
    }
    
    func initpistolen() {
        
        let pistole1 = Waffe(id: "35", name: "Riot Shield", bild: UIImage(named: "w35")!, genauigkeit: 20, schaden: 100, reichweite: 10, feuerrate: 10, mobilität: 100, kontrolle: 30)
        let pistole2 = Waffe(id: "36", name: "X16", bild: UIImage(named: "w36")!, genauigkeit: 55, schaden: 59, reichweite: 40, feuerrate: 56, mobilität: 80, kontrolle: 75)
        let pistole3 = Waffe(id: "37", name: "1911", bild: UIImage(named: "w37")!, genauigkeit: 52, schaden: 55, reichweite: 40, feuerrate: 50, mobilität: 79, kontrolle: 70)
        let pistole4 = Waffe(id: "38", name: ".357", bild: UIImage(named: "w38")!, genauigkeit: 60, schaden: 62, reichweite: 55, feuerrate: 46, mobilität: 80, kontrolle: 71)
        let pistole5 = Waffe(id: "39", name: "M19", bild: UIImage(named: "w39")!, genauigkeit: 60, schaden: 58, reichweite: 36, feuerrate: 60, mobilität: 80, kontrolle: 75)
        let pistole6 = Waffe(id: "40", name: ".50 GS", bild: UIImage(named: "w40")!, genauigkeit: 50, schaden: 60, reichweite: 50, feuerrate: 52, mobilität: 75, kontrolle: 60)
        let pistole7 = Waffe(id: "45", name: "Combat Knife", bild: UIImage(named: "w45")!, genauigkeit: 90, schaden: 99, reichweite: 10, feuerrate: 0, mobilität: 100, kontrolle: 90)
        
        pistolen.append(pistole1)
        pistolen.append(pistole2)
        pistolen.append(pistole3)
        pistolen.append(pistole4)
        pistolen.append(pistole5)
        pistolen.append(pistole6)
        pistolen.append(pistole7)

    }
 
    func initWerfer() {
        
        let werfer1 = Waffe(id: "41", name: "PILA", bild: UIImage(named: "w41")!, genauigkeit: 75, schaden: 80, reichweite: 92, feuerrate: 20, mobilität: 44, kontrolle: 30)
        let werfer2 = Waffe(id: "42", name: "Strela-P", bild: UIImage(named: "w42")!, genauigkeit: 75, schaden: 90, reichweite: 88, feuerrate: 40, mobilität: 49, kontrolle: 40)
        let werfer3 = Waffe(id: "43", name: "JOKR", bild: UIImage(named: "w43")!, genauigkeit: 90, schaden: 80, reichweite: 95, feuerrate: 30, mobilität: 44, kontrolle: 42)
        let werfer4 = Waffe(id: "44", name: "RPG-7", bild: UIImage(named: "w44")!, genauigkeit: 55, schaden: 90, reichweite: 88, feuerrate: 35, mobilität: 48, kontrolle: 40)
        
        werfer.append(werfer1)
        werfer.append(werfer2)
        werfer.append(werfer3)
        werfer.append(werfer4)
        
    }
    
    
    
    func initMaps() {
        initEroberungMaps()
        init2v2Maps()
        allemaps.append(contentsOf: eroberungmaps)
        allemaps.append(contentsOf: maps2v2)
    }
    
    
    func initEroberungMaps() {
        let map1 = Map(id: "1", name: "Aniyah Incursion", beschreibung: "Aniyah Incursion is a multiplayer map from Call of Duty: Modern Warfare that was added as part of Season 3 Free Content on April 8, 2020. It is a medium sized map available for standard modes.", bild: UIImage(named: "1")!, maplayout_bild: UIImage(named: "11")!, eroberung_bild: UIImage(named: "1111")!, hardpoint_bild: UIImage(named: "111")!)
        
        let map2 = Map(id: "2", name: "Arklov Peak", beschreibung: "Arklov Peak is a multiplayer map in Call of Duty: Modern Warfare. It's a medium sized snowy map designed for 6 versus 6 battles.", bild: UIImage(named: "2")!, maplayout_bild: UIImage(named: "22")!, eroberung_bild: UIImage(named: "no")!, hardpoint_bild: UIImage(named: "222")!)
        
        let map3 = Map(id: "3", name: "Atlas Superstore", beschreibung: "Shop at the Atlas Superstore, a new multiplayer map that takes place in a supercenter warehouse that has been taken over by Al Qatala forces. Fight in dense lanes, over fallen shelves, and in the shipping, receiving, and employee-only areas. Clean up in aisle six!", bild: UIImage(named: "3")!, maplayout_bild: UIImage(named: "33")!, eroberung_bild: UIImage(named: "3333")!, hardpoint_bild: UIImage(named: "333")!)
        
        let map4 = Map(id: "4", name: "Azhir Cave", beschreibung: "Azhir Cave is a multiplayer map in Call of Duty: Modern Warfare. It's a medium sized map with 2 main areas: a large cave and a village. The card is designed for 6 against 6 battles. A night version of Azhir Cave is also available for realism mode.", bild: UIImage(named: "4")!, maplayout_bild: UIImage(named: "44")!, eroberung_bild: UIImage(named: "no")!, hardpoint_bild: UIImage(named: "444")!)
        
        let map5 = Map(id: "5", name: "Crash", beschreibung: "Crash is a Call of Duty: Modern Warfare multiplayer map that originated in Call of Duty 4: Modern Warfare and was added as part of the first season's free content. It's a medium sized card with a wide variety of engagement options. Whether it's long lines of sight leading to sniper battles or engaging in hand-to-hand combat, the action here is sure to be fast, hectic, and fun.", bild: UIImage(named: "5")!, maplayout_bild: UIImage(named: "55")!, eroberung_bild: UIImage(named: "5555")!, hardpoint_bild: UIImage(named: "555")!)
        
        let map6 = Map(id: "6", name: "Euphrates Bridge", beschreibung: "Euphrates Bridge is a multiplayer map in Call of Duty: Modern Warfare. It's a medium sized map with a big yellow bridge in the middle of the level that has great sniper campsites. The card is designed for 6 against 6 battles.", bild: UIImage(named: "6")!, maplayout_bild: UIImage(named: "66")!, eroberung_bild: UIImage(named: "no")!, hardpoint_bild: UIImage(named: "666")!)
        
        let map7 = Map(id: "7", name: "Grazna Raid", beschreibung: "Grazna Raid is a multiplayer map from Call of Duty: Modern Warfare. It's a medium sized map with a small town with open areas and explorable buildings.", bild: UIImage(named: "7")!, maplayout_bild: UIImage(named: "77")!, eroberung_bild: UIImage(named: "no")!, hardpoint_bild: UIImage(named: "777")!)
        
        let map8 = Map(id: "8", name: "Gun Runner", beschreibung: "Gun Runner is a multiplayer map from Call of Duty: Modern Warfare. It's a medium sized card with a refinery complex. The card is designed for 6 against 6 battles. A night version of Gun Runner is also available for realism mode.", bild: UIImage(named: "8")!, maplayout_bild: UIImage(named: "88")!, eroberung_bild: UIImage(named: "8888")!, hardpoint_bild: UIImage(named: "888")!)
        
        let map9 = Map(id: "9", name: "Hackney Yard", beschreibung: "Hackney Yard is a multiplayer map from Call of Duty: Modern Warfare. It's a medium sized map located in an industrial park filled with trash. The farm is on the Thames. During the fight, you can see boats go by. Large cargo boxes, bins and other shipping containers serve as temporary cover and climbing access points in this small area.", bild: UIImage(named: "9")!, maplayout_bild: UIImage(named: "99")!, eroberung_bild: UIImage(named: "9999")!, hardpoint_bild: UIImage(named: "999")!)
        
        let map10 = Map(id: "10", name: "Hovec Sawmill", beschreibung: "A sleepy farming village is in danger as its main sawmill building caught fire. Operators fight inside and around the burning wreck, visiting local shops such as the butcher's shop, exhibition hall and even the beekeeping area, which has some active beehives!", bild: UIImage(named: "10")!, maplayout_bild: UIImage(named: "1010")!, eroberung_bild: UIImage(named: "10101010")!, hardpoint_bild: UIImage(named: "101010")!)
        
        let map11 = Map(id: "11", name: "Khandor Hideout", beschreibung: "Khandor Hideout is a multiplayer map released on March 27, 2020 as part of Call of Duty: Modern Warfare's second season. It is a medium sized map available for standard modes. The map has long lines of sight and interiors to complement different areas of battle. The large, centrally located camp is an activity center and haven for CQB players.", bild: UIImage(named: "1-")!, maplayout_bild: UIImage(named: "11-")!, eroberung_bild: UIImage(named: "1111-")!, hardpoint_bild: UIImage(named: "111-")!)
        
        let map12 = Map(id: "12", name: "Piccadilly", beschreibung: "Piccadilly is a multiplayer map in Call of Duty: Modern Warfare. It's a medium-sized map in London with buses in the center of the map and accessible buildings on the edges that offer good sniper spots. The card is designed for 6 against 6 battles.", bild: UIImage(named: "2-")!, maplayout_bild: UIImage(named: "22-")!, eroberung_bild: UIImage(named: "no")!, hardpoint_bild: UIImage(named: "222-")!)
        
        let map13 = Map(id: "13", name: "Rammaza", beschreibung: "Rammaza is a multiplayer map from Call of Duty: Modern Warfare. It's a medium-sized map of a war-torn city in the Middle East. Rammaza is a sprawling, complex arena with a mix of open air and closed combat settings. Three asymmetrical lanes run the length of Rammaza, with various elevated routes traversing the airspace above.", bild: UIImage(named: "3-")!, maplayout_bild: UIImage(named: "33-")!, eroberung_bild: UIImage(named: "3333-")!, hardpoint_bild: UIImage(named: "333-")!)
        
        let map14 = Map(id: "14", name: "Rust", beschreibung: "Rust takes the battle to an oil farm in the middle of the desert. The location of the Modern Warfare 2 campaign's Mission Endgame may be just the thing for players who aren't learning the tricks to tackle this arid playing field. Use the surroundings as cover and reach for the high and low ground to take advantage of your enemies.", bild: UIImage(named: "4-")!, maplayout_bild: UIImage(named: "44-")!, eroberung_bild: UIImage(named: "4444-")!, hardpoint_bild: UIImage(named: "444-")!)
        
        let map15 = Map(id: "15", name: "Shipment", beschreibung: "Shipment is a multiplayer map featured in Call of Duty: Modern Warfare, Remake of Call of Duty 4: Modern Warfare, and added as part of the first season's free content. It's one of the smallest maps in Modern Warfare. This small playable area only has some containers partially or fully open while others are locked.", bild: UIImage(named: "5-")!, maplayout_bild: UIImage(named: "55-")!, eroberung_bild: UIImage(named: "5555-")!, hardpoint_bild: UIImage(named: "555-")!)
        
        let map16 = Map(id: "16", name: "Shoot House", beschreibung: "Shoot House is a multiplayer map from Call of Duty: Modern Warfare that was released on November 8, 2019 on all platforms with a free update. One of the smallest 6v6 game maps, it has a traditional three-lane, fast-paced design that encourages hectic skirmishes and high octane battles.", bild: UIImage(named: "6-")!, maplayout_bild: UIImage(named: "66-")!, eroberung_bild: UIImage(named: "6666-")!, hardpoint_bild: UIImage(named: "666-")!)
        
        let map17 = Map(id: "17", name: "St. Petrograd", beschreibung: "St. Petrograd is a multiplayer map in Call of Duty: Modern Warfare. It's a medium-sized map with a wide and complex battle arena. The city lies on an east-west axis and has two main flank routes that run the length of the map: Canal Street to the north and the Tracks to the south. Between these routes there is a multitude of playgrounds to discover. Wind your way through maze-like apartments, infiltrate evacuated companies, and gain vertical advantages on rooftops and trains.", bild: UIImage(named: "7-")!, maplayout_bild: UIImage(named: "77-")!, eroberung_bild: UIImage(named: "7777-")!, hardpoint_bild: UIImage(named: "777-")!)
        
        let map18 = Map(id: "18", name: "Talisk Backlot", beschreibung: "In the middle of the Urzikstan desert lies a city in the center of which a major construction project is taking place. With citizens evacuated for a long time, door-to-door fights take place while teams battle for control of the various viewpoints and buildings. Prepare for a great mix of close-range and long-range sniper duels.", bild: UIImage(named: "8-")!, maplayout_bild: UIImage(named: "88-")!, eroberung_bild: UIImage(named: "8888-")!, hardpoint_bild: UIImage(named: "888-")!)
        
        let map19 = Map(id: "19", name: "Vacant", beschreibung: "Vacant is a Call of Duty: Modern Warfare multiplayer map that originated in Call of Duty 4: Modern Warfare and was added as part of the first season's free content. It's a medium-sized asymmetrical card that combines inside and outside combat. Although the main office and warehouse buildings provide some protection from aerial killstreaks, there are some skylights and other ceiling elements that allow air to enter the facility.", bild: UIImage(named: "9-")!, maplayout_bild: UIImage(named: "99-")!, eroberung_bild: UIImage(named: "9999-")!, hardpoint_bild: UIImage(named: "999-")!)
        
        
        
        eroberungmaps.append(map1)
        eroberungmaps.append(map2)
        eroberungmaps.append(map3)
        eroberungmaps.append(map4)
        eroberungmaps.append(map5)
        eroberungmaps.append(map6)
        eroberungmaps.append(map7)
        eroberungmaps.append(map8)
        eroberungmaps.append(map9)
        eroberungmaps.append(map10)
        eroberungmaps.append(map11)
        eroberungmaps.append(map12)
        eroberungmaps.append(map13)
        eroberungmaps.append(map14)
        eroberungmaps.append(map15)
        eroberungmaps.append(map16)
        eroberungmaps.append(map17)
        eroberungmaps.append(map18)
        eroberungmaps.append(map19)
        
        
        
    }
    
    func init2v2Maps() {
        
        let map20 = Map(id: "20", name: "Atrium", beschreibung: "Atrium is a multiplayer map from Call of Duty: Modern Warfare that was added as part of the first season's free content. It's a small map designed for 2v2 shooting combat mode. The structure of Atrium is nearly symmetrical, which in terms of strategy means that spawning on one side of the map will most likely result in the same tactic as the other. In the middle of this spacious room is a large deciduous tree on a fountain with a koi pond.", bild: UIImage(named: "1--")!, maplayout_bild: UIImage(named: "11--")!, eroberung_bild: UIImage(named: "no")!, hardpoint_bild: UIImage(named: "no")!)
        
        let map21 = Map(id: "21", name: "Bazaar", beschreibung: "A dense cross-section of the streets of Urzikstan is turned into a battlefield in the bazaar. Experience the tense gunfight as you navigate a new combat zone. The random Gunfight loadouts all have a chance to shine as the symmetrical layout of the cards offers opportunities for big moments and epic games.", bild: UIImage(named: "2--")!, maplayout_bild: UIImage(named: "22--")!, eroberung_bild: UIImage(named: "no")!, hardpoint_bild: UIImage(named: "no")!)
        
        let map22 = Map(id: "22", name: "Cargo", beschreibung: "Cargo is an open-air card that takes place in the hold of a ship somewhere at sea. This ship's hold is dimly lit and filled with containers and boxes, all of which can be covered up during the game to achieve verticality. Also, the various set pieces can be used as cover, mount weapons, and some that you can even walk through on your way across the map.", bild: UIImage(named: "3--")!, maplayout_bild: UIImage(named: "33--")!, eroberung_bild: UIImage(named: "no")!, hardpoint_bild: UIImage(named: "no")!)
        
        let map23 = Map(id: "23", name: "Docks", beschreibung: "A London shipyard with ships sailing past the filling point of one team along the river while the other team spawns due west on the road side. Buildings 51 - the foreman's office - and 52 - the crew's quarters - are two-story brick structures that define the north and south of the map. A bridge connects the two over a concrete path. The walkway under the center of the bridge, which is also above an east-west concrete waterway, serves as the location for the overtime flag.", bild: UIImage(named: "4--")!, maplayout_bild: UIImage(named: "44--")!, eroberung_bild: UIImage(named: "no")!, hardpoint_bild: UIImage(named: "no")!)
        
        let map24 = Map(id: "24", name: "Docks (Winter)", beschreibung: "A London shipyard with ships sailing past the filling point of one team along the river while the other team spawns due west on the road side. Buildings 51 - the foreman's office - and 52 - the crew's quarters - are two-story brick structures that define the north and south of the map. A bridge connects the two over a concrete path. The walkway under the center of the bridge, which is also above an east-west concrete waterway, serves as the location for the overtime flag.", bild: UIImage(named: "5--")!, maplayout_bild: UIImage(named: "55--")!, eroberung_bild: UIImage(named: "no")!, hardpoint_bild: UIImage(named: "no")!)
        
        let map25 = Map(id: "25", name: "Gulag Showers", beschreibung: "The Gulag Showers Map also appears in Call of Duty: Warzone when players enter the Gulag (prison) with 3 different variants.", bild: UIImage(named: "6--")!, maplayout_bild: UIImage(named: "66--")!, eroberung_bild: UIImage(named: "no")!, hardpoint_bild: UIImage(named: "no")!)
        
        let map26 = Map(id: "26", name: "Hill", beschreibung: "Hill is a multiplayer map from Call of Duty: Modern Warfare. It's a small map designed for 2 vs 2 Gunfight mode.", bild: UIImage(named: "7--")!, maplayout_bild: UIImage(named: "77--")!, eroberung_bild: UIImage(named: "no")!, hardpoint_bild: UIImage(named: "no")!)
        
        let map27 = Map(id: "27", name: "King", beschreibung: "A roughly symmetrical camp for training areas in which each player starts behind an L-shaped defensive structure made from sections of wood. Along the perimeter are two interconnected metal shipping containers (each with Shoot House sprayed on them) that provide protection but do not have a clear line of sight.", bild: UIImage(named: "8--")!, maplayout_bild: UIImage(named: "88--")!, eroberung_bild: UIImage(named: "no")!, hardpoint_bild: UIImage(named: "no")!)
        
        let map28 = Map(id: "28", name: "Pine", beschreibung: "A forest training area with machining metal targets beyond the perimeter and a small lawn from the infile point. The eastern infile point is a shooting range, while the western infile point is a bunker entrance. Each edge area leads to a ledge and a rusty vehicle to navigate or hide behind, as well as a raised command post with a tarpaulin on the south side.", bild: UIImage(named: "9--")!, maplayout_bild: UIImage(named: "99--")!, eroberung_bild: UIImage(named: "no")!, hardpoint_bild: UIImage(named: "no")!)
        
        let map29 = Map(id: "29", name: "Rust", beschreibung: "Rust takes the battle to an oil farm in the middle of the desert. The location of the Modern Warfare 2 campaign's Mission Endgame may be just the thing for players who aren't learning the tricks to tackle this arid playing field. Use the surroundings as cover and reach for the high and low ground to take advantage of your enemies.", bild: UIImage(named: "4-")!, maplayout_bild: UIImage(named: "44-")!, eroberung_bild: UIImage(named: "no")!, hardpoint_bild: UIImage(named: "no")!)
        
        let map30 = Map(id: "30", name: "Shipment", beschreibung: "Shipment is a multiplayer map featured in Call of Duty: Modern Warfare, Remake of Call of Duty 4: Modern Warfare, and added as part of the first season's free content. It's one of the smallest maps in Modern Warfare. This small playable area only has some containers partially or fully open while others are locked.", bild: UIImage(named: "5-")!, maplayout_bild: UIImage(named: "55-")!, eroberung_bild: UIImage(named: "no")!, hardpoint_bild: UIImage(named: "no")!)
        
        let map31 = Map(id: "31", name: "Speedball", beschreibung: "A live shooting range that stays true to its name through its style. Containers, stacks of tires, concrete slabs and wooden structures serve as a cover between the two teams, which are on the opposite sides of the east and west. The overtime flag appears near the southern part of the map, in the middle of two containers dueling with small towers and the central concrete wall from Duel.", bild: UIImage(named: "10--")!, maplayout_bild: UIImage(named: "1010--")!, eroberung_bild: UIImage(named: "no")!, hardpoint_bild: UIImage(named: "no")!)
        
        let map32 = Map(id: "32", name: "Stack", beschreibung: "A desert training area where both teams start on a raised balcony (one with an overhang) with two ramps each; one on each perimeter edge. The side paths each have sand-filled support boxes and stacks of tires, and both widen slightly in the middle. The center of Stack is an elevated platform with plywood stairs (one on each corner) and an open container in which the flag appears.a", bild: UIImage(named: "a1")!, maplayout_bild: UIImage(named: "a11")!, eroberung_bild: UIImage(named: "no")!, hardpoint_bild: UIImage(named: "no")!)
        
        
        maps2v2.append(map20)
        maps2v2.append(map21)
        maps2v2.append(map22)
        maps2v2.append(map23)
        maps2v2.append(map24)
        maps2v2.append(map25)
        maps2v2.append(map26)
        maps2v2.append(map27)
        maps2v2.append(map28)
        maps2v2.append(map29)
        maps2v2.append(map30)
        maps2v2.append(map31)
        maps2v2.append(map32)
        
    }
    
    
    func searchWaffenId(id: String) -> Waffe {
        for currentWaffe in allewaffen {
            if currentWaffe.id == id {
                return currentWaffe
            }
        }
        return Waffe()
    }
    
    func deleteAllCommunityPics() {
        for currentWaffe in allewaffen {
                currentWaffe.fotosDerCommunity.removeAll()
        }
    }
    
    
}
