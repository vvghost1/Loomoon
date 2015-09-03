//
//  DataModel.swift
//  Loomoon
//
//  Created by Yura Vorontsov on 03.09.15.
//  Copyright (c) 2015 Yura Vorontsov. All rights reserved.
//

import Foundation

class DataModel
{
    var name = ""
    var title = "User"
    struct TableLine: Printable
    {
        let header: String
        let descriptions: String
        var description: String{get{return header + " " + descriptions + "\n"}}
    }
    var user = [TableLine]()
    var subscriptions = [TableLine]()
    var tags = [[TableLine]]()

    
    init(data: NSDictionary)
    {
        var curr: TableLine
//user
        if let str = data["FirstName"] as? String
        {
            name = str
        }
        if let str = data["Title"] as? String
        {
            title = str
        }
        if let str = data["Birthday"] as? String
        {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:SS"
            let date = dateFormatter.dateFromString(str)
            dateFormatter.dateFormat = "yyyy/MM/dd"
            user.append(TableLine(header: "День рождения",descriptions: dateFormatter.stringFromDate(date!)))
        }
        if let str = data["Sex"] as? String
        {
            user.append(TableLine(header: "Пол",descriptions: str))
        }
        if let str = data["Cards"] as? NSDictionary
        {
            if let str1 = str["Item"] as? String
            {
                user.append(TableLine(header: "Карты",descriptions: str1))
            }
        }
        if let str = data["DateRegistered"] as? String
        {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:SS"
            let date = dateFormatter.dateFromString(str)
            dateFormatter.dateFormat = "yyyy/MM/dd"
            user.append(TableLine(header: "Дата регистрации",descriptions: dateFormatter.stringFromDate(date!)))
        }
        if let str = data["DocumentType"] as? String
        {
            user.append(TableLine(header: "Тип документа",descriptions: str))
        }
        if let str = data["ID"] as? Int
        {
            user.append(TableLine(header: "Номер",descriptions: String(str)))
        }
        if let str = data["MariageStatus"] as? String
        {
            user.append(TableLine(header: "Семейное положение",descriptions: str))
        }
        if let str = data["MobilePhoneNumber"] as? String
        {
            user.append(TableLine(header: "Телефон",descriptions: str))
        }
//subs
        
        if let subs1 = data["Subcriptions"] as? NSDictionary, subs = subs1["Item"] as? NSDictionary
        {
            if let str = subs["Name"] as? String
            {
                subscriptions.append(TableLine(header: "Имя",descriptions: str))
            }
            if let str = subs["Id"] as? Int
            {
                subscriptions.append(TableLine(header: "Id",descriptions: String(str)))
            }
            if let str = subs["Description"] as? String
            {
                subscriptions.append(TableLine(header: "Описание",descriptions: str))
            }
            if let str = subs["CardProductId"] as? Int
            {
                subscriptions.append(TableLine(header: "Номер карты",descriptions: String(str)))
            }
        }
        if let tags1 = data["Tags"] as? NSDictionary, tags2 = tags1["Item"] as? NSArray
        {
            for item in tags2
            {
                if let item1 = item as? NSDictionary
                {
                var curr = [TableLine]()
                if let hdr = item1["Value"] as? String
                {
                    curr.append(TableLine(header: "Значение",descriptions: hdr))
                }
                if let hdr = item1["Description"] as? String
                {
                    curr.append(TableLine(header: "Описание",descriptions: hdr))
                }
                tags.append(curr)
                }
            }
        }
    }
}