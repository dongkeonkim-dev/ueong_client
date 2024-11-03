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

func chatListTime(_ date: Date?) -> String {
  guard let date = date else {
    return "알 수 없음"
  }
  
  let calendar = Calendar.current
  let now = Date()
  let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date, to: now)
  
    // 날짜 포맷터 설정
  let dateFormatter = DateFormatter()
  dateFormatter.locale = Locale(identifier: "ko_KR")
  
    // 올해인지 확인
  if calendar.component(.year, from: date) != calendar.component(.year, from: now) {
      // 올해가 아니면 YYYY.MM.dd
    dateFormatter.dateFormat = "yyyy.MM.dd"
    return dateFormatter.string(from: date)
  }
  
    // 오늘인지 확인
  if calendar.isDateInToday(date) {
      // 오늘이면 HH:mm
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter.string(from: date)
  }
  
    // 어제인지 확인
  if calendar.isDateInYesterday(date) {
    return "어제"
  }
  
    // 올해면서 어제/오늘이 아니면 MM월 dd일
  dateFormatter.dateFormat = "M월 d일"
  return dateFormatter.string(from: date)
}

func chatTime(_ date: Date?) -> String {
  guard let date = date else {
    return "알 수 없음"
  }
  
  let calendar = Calendar.current
  let now = Date()
  
    // 날짜 포맷터 설정
  let timeFormatter = DateFormatter()
  timeFormatter.locale = Locale(identifier: "ko_KR")
  
    // 같은 해인지 확인
  if !calendar.isDate(date, equalTo: now, toGranularity: .year) {
      // 다른 해면 "YYYY.MM.dd HH:mm"
    timeFormatter.dateFormat = "yyyy.MM.dd HH:mm"
    return timeFormatter.string(from: date)
  }
  
    // 같은 날인지 확인
  if calendar.isDateInToday(date) {
      // 오늘이면 "HH:mm"
    timeFormatter.dateFormat = "HH:mm"
    return timeFormatter.string(from: date)
  }
  
    // 같은 해의 다른 날이면 "MM.dd HH:mm"
  timeFormatter.dateFormat = "MM.dd HH:mm"
  return timeFormatter.string(from: date)
}
