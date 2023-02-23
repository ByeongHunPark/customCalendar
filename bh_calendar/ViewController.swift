//
//  ViewController.swift
//  bh_calendar
//
//  Created by 박병훈 on 2023/02/23.
//

import UIKit
import FSCalendar

class ViewController: UIViewController{
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var labelTest: UILabel!
    
    var events : [Date] = []
    
    let dateFormatter = DateFormatter()
    let today = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatterSet()
        calendarView.delegate = self
        calendarView.dataSource = self
        
        todayLabelUI()
        calendarUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setEvents()
    }
    
    fileprivate func dateFormatterSet(){
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    fileprivate func todayLabelUI(){
        let todayEventCheck = dateFormatter.string(from: today)
        
        if events.contains(dateFormatter.date(from: todayEventCheck)!){
            labelTest.text = "이벤트가 있습니다"
        }else{
            labelTest.text = "이벤트가 없습니다"
        }
    }
    
    fileprivate func calendarUI(){
        
        // MARK: - 주간,월간설정
//        calendarView.scope = .week   // 주간
        calendarView.scope = .month  // 월간
        
        // MARK: - 언어설정
        // 1번째 방법 (추천)
        calendarView.locale = Locale(identifier: "ko_KR")
//
//        // 2번째 방법
//        calendarView.calendarWeekdayView.weekdayLabels[0].text = "일"
//        calendarView.calendarWeekdayView.weekdayLabels[1].text = "월"
//        calendarView.calendarWeekdayView.weekdayLabels[2].text = "화"
//        calendarView.calendarWeekdayView.weekdayLabels[3].text = "수"
//        calendarView.calendarWeekdayView.weekdayLabels[4].text = "목"
//        calendarView.calendarWeekdayView.weekdayLabels[5].text = "금"
//        calendarView.calendarWeekdayView.weekdayLabels[6].text = "토"
//
//        // Default ( Mon, Tue, … 로 나온다 )
//        // M, T, W, … 처럼 나오게 하려면 아래와 같이 작성해주면 됩니다.
//        calendarView.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase
        
        // MARK: - 스크롤설정
        calendarView.scrollEnabled = true   // 가능
//        calendarView.scrollEnabled = false  // 불가능
        
        calendarView.scrollDirection = .horizontal  // 가로
//        calendarView.scrollDirection = .vertical    // 세로
        
        // MARK: - 폰트설정
        // 헤더 폰트 설정
        calendarView.appearance.headerTitleFont = UIFont(name: "NotoSansKR-Medium", size: 16)

        // Weekday 폰트 설정
        calendarView.appearance.weekdayFont = UIFont(name: "NotoSansKR-Regular", size: 14)

        // 각각의 일(날짜) 폰트 설정 (ex. 1 2 3 4 5 6 ...)
        calendarView.appearance.titleFont = UIFont(name: "NotoSansKR-Regular", size: 14)
        
        // MARK: - 헤더설정(ex:2023년 1월)
        // 헤더의 날짜 포맷 설정
        calendarView.appearance.headerDateFormat = "YYYY년 MM월"

        // 헤더의 폰트 색상 설정
        calendarView.appearance.headerTitleColor = UIColor.link

        // 헤더의 폰트 정렬 설정
        // .center & .left & .justified & .natural & .right
        calendarView.appearance.headerTitleAlignment = .center

        // 헤더 높이 설정
        calendarView.headerHeight = 45

        // 헤더 양 옆(전달 & 다음 달) 글씨 투명도
        // 0.0 = 안보이게 됩니다.
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.5
        
        // MARK: - 색상 설정
        // 배경색
        calendarView.backgroundColor = UIColor(red: 241/255, green: 249/255, blue: 255/255, alpha: 1)
        
        // 선택한 날짜색
        calendarView.appearance.selectionColor = UIColor(red: 38/255, green: 153/255, blue: 251/255, alpha: 1)
        
        // 오늘 날짜색
        calendarView.appearance.todayColor = UIColor(red: 188/255, green: 224/255, blue: 253/255, alpha: 1)
        
        // 이벤트 표시 색상(날짜 아래 점으로 표시)
        calendarView.appearance.eventDefaultColor = UIColor.green
        calendarView.appearance.eventSelectionColor = UIColor.green
        
        
        // MARK: - 기타 설정
        // 선택된 날짜 모서리 설정 (0으로 하면 사각형으로 표시)
//        calendarView.appearance.borderRadius = 0

        // 평일 & 주말 색상 설정
        calendarView.appearance.titleDefaultColor = .black  // 평일
//        calendarView.appearance.titleWeekendColor = .red    // 주말
        
        // 다중 선택
        calendarView.allowsMultipleSelection = false

        // 꾹 눌러서 드래그 동작으로 다중 선택
        calendarView.swipeToChooseGesture.isEnabled = false
    }
    
    // MARK: - 날짜에 이벤트 추가하는 함수
    func setEvents() {
        
        
        // events
        let myFirstEvent = dateFormatter.date(from: "2023-02-01")
        let mySecondEvent = dateFormatter.date(from: "2023-02-13")
        
        events = [myFirstEvent!, mySecondEvent!]
        
    }
    
}



extension ViewController : FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance{
    
    // MARK: - 이벤트 표시 갯수 설정
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if self.events.contains(date) {
            return 1
        } else {
            return 0
        }
    }
    
    // MARK: - 날짜 선택 시 콜백 메소드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(dateFormatter.string(from: date) + " 날짜가 선택되었습니다.")
        
        if events.contains(date){
            labelTest.text = "이벤트가 있습니다"
        }else{
            labelTest.text = "이벤트가 없습니다"
        }
        
    }
    
    // MARK: - 날짜 선택 해제 콜백 메소드
    public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(dateFormatter.string(from: date) + " 날짜가 선택 해제 되었습니다.")
    }
    
    // MARK: - 선택 해제 관련 메소드
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
//         return false  // 선택해제 불가능
         return true   // 선택해제 가능
    }
    
    // MARK: - 날짜 밑에 문자열 표시 메소드
    // 이벤트 표시 대신 글짜를 표시
//    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
//         switch dateFormatter.string(from: date) {
//         case dateFormatter.string(from: Date()):
//             return "오늘"
//
//         case "2023-01-05":
//             return "국어공부"
//
//         case "2023-01-06":
//             return "영어공부"
//
//         case "2023-01-07":
//             return "수학공부"
//
//         default:
//             return nil
//
//            }
//        }
    
    // MARK: - 해당 날짜의 글씨 자체를 바꾸는 메소드
    // 해당 날짜가 return 값으로 대체 됨
//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//         switch dateFormatter.string(from: date) {
//         case "2023-01-11":
//             return "D-day"
//         default:
//             return nil
//         }
//    }
    
    // MARK: - 날짜별로 선택시 색상을 설정하는 메소드
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
         switch dateFormatter.string(from: date) {
         case "2023-01-05":
             return .green
             
         case "2023-01-06":
             return .yellow
             
         case "2023-01-07":
             return .red
             
        default:
             return appearance.selectionColor
         }
    }
    
    // MARK: - 최대 선택 갯수를 제어하는 메소드
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
         // 날짜 3개까지만 선택
         if calendar.selectedDates.count > 3 {
             return false
         } else {
             return true
         }
    }
}
