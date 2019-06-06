//
//  DateFormatHelper.swift
//  meim
//
//  Created by jimmy on 2017/6/2.
//
//

import UIKit

extension String
{
    func dateFrom(_ from : String, to : String) -> String
    {
        let formator = DateFormatter()
        formator.dateFormat = from
        if let date = formator.date(from: self)
        {
            formator.dateFormat = to
            return formator.string(from: date)
        }
        
        return ""
    }
    
    func date(with format : String) -> Date?
    {
        let formator = DateFormatter()
        formator.dateFormat = format
        if let date = formator.date(from: self)
        {
            return date
        }
        
        return nil
    }
}

extension Date
{
    func dateTo(_ format : String) -> String
    {
        let formator = DateFormatter()
        formator.dateFormat = format
        return formator.string(from: self)
    }
    
    func todayInMonth() -> Int
    {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        let componentSet: Set<Calendar.Component> = Set(arrayLiteral: .year, .month, .day)
        let components: DateComponents = calendar.dateComponents(componentSet, from: self)
        let todayComponents: DateComponents = calendar.dateComponents(componentSet, from: Date())
        if components.year == todayComponents.year, components.month == todayComponents.month, let day = todayComponents.day
        {
            return day
        }
        
        return 0
    }
    
    func dayInMonth(date: Date) -> Int
    {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        let componentSet: Set<Calendar.Component> = Set(arrayLiteral: .year, .month, .day)
        let components: DateComponents = calendar.dateComponents(componentSet, from: self)
        let todayComponents: DateComponents = calendar.dateComponents(componentSet, from: date)
        if components.year == todayComponents.year, components.month == todayComponents.month, let day = todayComponents.day
        {
            return day
        }
        
        return 0
    }

    
    func lastMonth() -> Date?
    {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        let componentSet: Set<Calendar.Component> = Set(arrayLiteral: .year, .month, .day)
        var components: DateComponents = calendar.dateComponents(componentSet, from: self)
        if let month = components.month, let year = components.year
        {
            if month == 1
            {
                components.month = 12
                components.year = year - 1
            }
            else
            {
                components.month = month - 1
            }
            
            components.day = 1
            
            return calendar.date(from: components)
        }
        
        return nil
    }
    
    func nextMonth() -> Date?
    {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        let componentSet: Set<Calendar.Component> = Set(arrayLiteral: .year, .month, .day)
        var components: DateComponents = calendar.dateComponents(componentSet, from: self)
        if let month = components.month, let year = components.year
        {
            if month == 12
            {
                components.month = 1
                components.year = year + 1
            }
            else
            {
                components.month = month + 1
            }
            
            components.day = 1
            
            return calendar.date(from: components)
        }
        
        return nil
    }
    
    func weekDayIndex() -> Int?
    {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        let componentSet: Set<Calendar.Component> = Set(arrayLiteral:.year, .month, .day, .weekday)
        var components: DateComponents = calendar.dateComponents(componentSet, from: self)
        components.day = 1
        if let date = calendar.date(from: components)
        {
            components = calendar.dateComponents(componentSet, from: date)
            if var weekDay = components.weekday
            {
                weekDay -= 1
                
                return weekDay
            }
        }
        
        return nil
    }
    
    func weekDay() -> Int?
    {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        let componentSet: Set<Calendar.Component> = Set(arrayLiteral:.year, .month, .day, .weekday)
        var components: DateComponents = calendar.dateComponents(componentSet, from: self)
        if let date = calendar.date(from: components)
        {
            components = calendar.dateComponents(componentSet, from: date)
            if var weekDay = components.weekday
            {
                weekDay -= 1
                return weekDay
            }
        }
        
        return nil
    }
    
    
    func monthLength() -> Int
    {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        if let range = calendar.range(of: .day, in: .month, for: self)
        {
            return range.count
        }
        
        return 0
    }
    
    func chineseOneMonthComponents() -> [String]
    {
        let monthList = ["正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月","九月", "十月", "冬月", "腊月"]
        let dayList = ["初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十",
                       "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十",
                       "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"]
        
        var resuntMonthString : [String] = []
        let calendar: Calendar = Calendar(identifier: .gregorian)
        let componentSet: Set<Calendar.Component> = Set(arrayLiteral:.year, .month, .day)
        var components: DateComponents = calendar.dateComponents(componentSet, from: self)
        components.day = 0
        
        let chineseCalendar: Calendar = Calendar(identifier: .chinese)
        for _ in 0..<monthLength()
        {
            components.day = components.day! + 1
            if let date = calendar.date(from: components)
            {
                let components: DateComponents = chineseCalendar.dateComponents(componentSet, from: date)
                if let day = components.day, let month = components.month
                {
                    if day == 1
                    {
                        resuntMonthString.append(monthList[month - 1])
                    }
                    else
                    {
                        resuntMonthString.append(dayList[day - 1])
                    }
                }
                
            }
        }
        
        return resuntMonthString
    }
    
    func chineseComponents() -> DateComponents
    {
        let calendar: Calendar = Calendar(identifier: .chinese)
        let componentSet: Set<Calendar.Component> = Set(arrayLiteral:.year, .month, .day, .weekday)
        let components: DateComponents = calendar.dateComponents(componentSet, from: self)
        
        return components
    }
    
    func chineseDateString() -> String{
        let monthList = ["正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月","九月", "十月", "冬月", "腊月"]
        let dayList = ["初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十",
                       "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十",
                       "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"]
        
        let calendar: Calendar = Calendar(identifier: .gregorian)
        let componentSet: Set<Calendar.Component> = Set(arrayLiteral:.year, .month, .day)
        var components: DateComponents = calendar.dateComponents(componentSet, from: self)
        //components.day = 0
        
        let chineseCalendar: Calendar = Calendar(identifier: .chinese)
        for _ in 0..<monthLength()
        {
            components.day = components.day!
            if let date = calendar.date(from: components)
            {
                let components: DateComponents = chineseCalendar.dateComponents(componentSet, from: date)
                if let day = components.day, let month = components.month
                {
                    return monthList[month - 1] + dayList[day - 1]
                }
                
            }
        }
        return ""
//        let date = self
//        let dateFormatter = DateFormatter.init()
//        dateFormatter.dateFormat = "yyyy年MM月dd日 HH时mm分ss秒 Z"
//        let formatedDate = dateFormatter.string(from: date)
//        print(formatedDate)
//        
//        //切换到中国农历（如果之前有创建其他日历，需要先把之前到日历给释放或者清空）
//        let chinese = Calendar.init(identifier: .chinese)
//        let components = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second])
//        let theComponents = chinese.dateComponents(components, from: date)
//        print("阴历的日期是：\(theComponents)")
    }
}

extension Int {
    var cn: String {
        get {
            if self == 0 {
                return "零"
            }
            var zhNumbers = ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九"]
            var units = ["", "十", "百", "千", "万", "十", "百", "千", "亿", "十","百","千"]
            var cn = ""
            var currentNum = 0
            var beforeNum = 0
            let intLength = Int(floor(log10(Double(self))))
            for index in 0...intLength {
                currentNum = self/Int(pow(10.0,Double(index)))%10
                if index == 0{
                    if currentNum != 0 {
                        cn = zhNumbers[currentNum]
                        continue
                    }
                } else {
                    beforeNum = self/Int(pow(10.0,Double(index-1)))%10
                }
                if [1,2,3,5,6,7,9,10,11].contains(index) {
                    if currentNum == 1 && [1,5,9].contains(index) && index == intLength { // 处理一开头的含十单位
                        cn = units[index] + cn
                    } else if currentNum != 0 {
                        cn = zhNumbers[currentNum] + units[index] + cn
                    } else if beforeNum != 0 {
                        cn = zhNumbers[currentNum] + cn
                    }
                    continue
                }
                if [4,8,12].contains(index) {
                    cn = units[index] + cn
                    if (beforeNum != 0 && currentNum == 0) || currentNum != 0 {
                        cn = zhNumbers[currentNum] + cn
                    }
                }
            }
            return cn
        }
    }
}
