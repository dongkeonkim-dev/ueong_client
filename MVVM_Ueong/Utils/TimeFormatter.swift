//
//  TimeFormatter.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 10/5/24.
//

import Foundation

// MySQL DATETIME -> Swift Date
func DATETIMEToDate(TIMESTAMP timeStamp: String) -> Date? {
    let isoFormatter = ISO8601DateFormatter()
    if let date = isoFormatter.date(from: timeStamp) {
        return date
    }
    // 다른 형식 추가 (필요한 경우)
    let fallbackFormatter = DateFormatter()
    fallbackFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // 추가적인 형식 예시
    return fallbackFormatter.date(from: timeStamp)
}

// Swift Date -> String:"~ 전"
func timeAgo(_ date: Date?) -> String {
    guard let date = date else {
        return "알 수 없음" // 날짜가 nil일 경우 반환할 기본 메시지
    }

    let calendar = Calendar.current
    let components = calendar.dateComponents([.second, .minute, .hour, .day, .month, .year], from: date, to: Date())

    if let years = components.year, years > 0 {
        return "\(years)년 전"
    } else if let months = components.month, months > 0 {
        return "\(months)달 전"
    } else if let days = components.day, days > 0 {
        return "\(days)일 전"
    } else if let hours = components.hour, hours > 0 {
        return "\(hours)시간 전"
    } else if let minutes = components.minute, minutes > 0 {
        return "\(minutes)분 전"
    } else {
        return "방금 전" // 1분 이내의 경우
    }
}
