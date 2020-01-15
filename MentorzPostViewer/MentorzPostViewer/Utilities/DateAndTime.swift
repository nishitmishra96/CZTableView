//
//  DateAndTime.swift
//  MentorzPostViewer
//
//  Created by Nishit Mishra on 01/12/19.
//  Copyright © 2019 Nishit Mishra. All rights reserved.
//

import Foundation
let SECONDS_IN_DAY = 86400
let SECONDS_IN_HOUR = 3600
let SECONDS_IN_MONTH = 2592000
let SECONDS_IN_WEEK = 604800
let SECONDS_IN_YEAR = 30672000
let SECONDS_IN_MINUTES = 60


class dateTimeUtil{
    
    class func getTimeDutation(forPost time: String?) ->  String?{
        let times = NSString.init(string: /time)
        let interval = times.longLongValue/1000
//        let interval = TimeInterval.init(integerLiteral: /Int64(/time))
        let dateInGMT = Date(timeIntervalSince1970: TimeInterval(interval))
        let dateInLocalTimezone = Date(timeInterval: 0, since: dateInGMT)
        
        let timeDifference = dateInLocalTimezone.timeIntervalSinceNow * -1
        
        let years = Int(timeDifference) / SECONDS_IN_YEAR
        if years > 0{
            let yearDurationString = (years == 1) ? NSLocalizedString("Year", comment: "") : NSLocalizedString("Years", comment: "")
            return "\(years) \(yearDurationString) ago"
        }
        
        let months = Int(timeDifference) / SECONDS_IN_MONTH
        if months > 0{
            let monthDurationString = (months == 1) ? NSLocalizedString("mon", comment: "") : NSLocalizedString("mons", comment: "")
            return "\(months) \(monthDurationString) ago"
        }
        
        let weeks = Int(timeDifference) / SECONDS_IN_WEEK
        if weeks > 0{
            let weekDurationString = (weeks == 1) ? NSLocalizedString("Wk", comment: "") : NSLocalizedString("wks", comment: "")
            return "\(weeks) \(weekDurationString) ago"
        }
        let days = Int(timeDifference) / SECONDS_IN_DAY
        if days > 0{
            let daysDurationString = (days == 1) ? NSLocalizedString("dy", comment: "") : NSLocalizedString("days", comment: "")
            return "\(days) \(daysDurationString) ago"
        }
        
        let hours = Int(timeDifference) / SECONDS_IN_HOUR
        if hours > 0{
            let hoursDurationString = (hours == 1) ? NSLocalizedString("hr", comment: "") : NSLocalizedString("hrs", comment: "")
            return "\(hours) \(hoursDurationString) ago"
        }
        
        let minutes = Int(timeDifference) / SECONDS_IN_MINUTES
         if minutes > 0{
             let hoursDurationString = (minutes == 1) ? NSLocalizedString("min", comment: "") : NSLocalizedString("mins", comment: "")
             return "\(minutes) \(hoursDurationString) ago"
         }
        
        return "Just now"
    }
    
    class func getTimeForComment(forComment time: String?) ->  String?{
        let times = NSString.init(string: /time)
        let interval = times.longLongValue/1000
//        let interval = TimeInterval.init(integerLiteral: /Int64(/time))
        let dateInGMT = Date(timeIntervalSince1970: TimeInterval(interval))
        let dateInLocalTimezone = Date(timeInterval: 0, since: dateInGMT)
        
        let timeDifference = dateInLocalTimezone.timeIntervalSinceNow * -1
        
        let years = Int(timeDifference) / SECONDS_IN_YEAR
        if years > 0{
            let yearDurationString = (years == 1) ? NSLocalizedString("yr", comment: "") : NSLocalizedString("yrs", comment: "")
            return "\(years) \(yearDurationString) ago"
        }
        
        let months = Int(timeDifference) / SECONDS_IN_MONTH
        if months > 0{
            let monthDurationString = (months == 1) ? NSLocalizedString("mon", comment: "") : NSLocalizedString("mons", comment: "")
            return "\(months) \(monthDurationString) ago"
        }
        
        let weeks = Int(timeDifference) / SECONDS_IN_WEEK
        if weeks > 0{
            let weekDurationString = (weeks == 1) ? NSLocalizedString("wk", comment: "") : NSLocalizedString("wks", comment: "")
            return "\(weeks) \(weekDurationString) ago"
        }
        let days = Int(timeDifference) / SECONDS_IN_DAY
        if days > 0{
            let daysDurationString = (days == 1) ? NSLocalizedString("dy", comment: "") : NSLocalizedString("dys", comment: "")
            return "\(days) \(daysDurationString) ago"
        }
        
        let hours = Int(timeDifference) / SECONDS_IN_HOUR
        if hours > 0{
            let hoursDurationString = (hours == 1) ? NSLocalizedString("hr", comment: "") : NSLocalizedString("hrs", comment: "")
            return "\(hours) \(hoursDurationString) ago"
        }
        
        let minutes = Int(timeDifference) / SECONDS_IN_MINUTES
         if minutes > 0{
             let hoursDurationString = (minutes == 1) ? NSLocalizedString("Min", comment: "") : NSLocalizedString("Mins", comment: "")
             return "\(minutes) \(hoursDurationString) ago"
         }
        
        return "Just now"
    }

}
