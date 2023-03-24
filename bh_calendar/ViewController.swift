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
    @IBOutlet weak var headerTest: UILabel!
    
    @IBOutlet weak var prevBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    var events : [String] = []
    
    private var currentPage: Date?
    
    private lazy var today: Date = {
        return Date()
    }()
    
    @IBAction func prevBtnClick(_ sender: Any) {
        scrollCurrentPage(isPrev: true)
    }
    
    @IBAction func nextBtnClick(_ sender: Any) {
        scrollCurrentPage(isPrev: false)
    }
    
    // MARK: - 오늘 날짜로 돌아오는 버튼
    @IBAction func currentBtnClicked(_ sender: Any) {
        todayLabelUI()
    }
    
    private lazy var dateFormatter : DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    private lazy var hd: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = "MM월\nyyyy년"
        return df
    }()
    
    private lazy var tcd : DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = "MM월"
        return df
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.delegate = self
        calendarView.dataSource = self
        
        setEvents()
        
        todayLabelUI()
        calendarUI()
        headerSet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        prevBtn.setTitle("", for: .normal)
        nextBtn.setTitle("", for: .normal)
        
        let headerClick = UITapGestureRecognizer(target: self, action: #selector(currentBtnClicked))
        headerTest.isUserInteractionEnabled = true
        headerTest.addGestureRecognizer(headerClick)
        
    }
    
    fileprivate func todayLabelUI(){
        self.calendarView.select(today)
        currentPage = calendarView.currentPage
        
        eventCheck(date: today)
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
        calendarView.headerHeight = 60

        // 헤더 양 옆(전달 & 다음 달) 글씨 투명도
        // 0.0 = 안보이게 됩니다.
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.5
        
        // MARK: - 배경 테두리
//        calendarView.layer.borderWidth = 1
//        calendarView.layer.borderColor = UIColor.black.cgColor
//        calendarView.layer.cornerRadius = 15
        
        // MARK: - 색상 설정
        // 배경색
        calendarView.backgroundColor = .clear
//        UIColor(red: 241/255, green: 249/255, blue: 255/255, alpha: 1)
        
        // 선택한 날짜 배경색
        calendarView.appearance.selectionColor = UIColor(hex: "ffed99")
//        UIColor(red: 38/255, green: 153/255, blue: 251/255, alpha: 1)
        
        // 오늘 날짜 배경색
        calendarView.appearance.todayColor = UIColor(red: 255/255, green: 237/255, blue: 153/255, alpha: 0.4) // UIColor(hex: "ffed99") 의 알파조절한 것
//        UIColor(red: 188/255, green: 224/255, blue: 253/255, alpha: 1)
        
        // 이벤트 표시 색상(날짜 아래 점으로 표시)
        // 선택 X
        calendarView.appearance.eventDefaultColor = UIColor(hex: "b59b8a")
        // 선택 O
        calendarView.appearance.eventSelectionColor = UIColor(hex: "b59b8a")
        
        // 텍스트 색상 설정
        // 평일
        calendarView.appearance.titleDefaultColor = .black
        // 주말
//        calendarView.appearance.titleWeekendColor = .red
        // 선택 O
        calendarView.appearance.titleSelectionColor = .black
        // 오늘 날짜 선택시 배경색
//        calendarView.appearance.todaySelectionColor = .black
        // 오늘 날짜 텍스트 색
        calendarView.appearance.titleTodayColor = .black
        
        // 달에 유효하지 않은 날짜의 색 지정
//        calendarView.appearance.titlePlaceholderColor = UIColor.white.withAlphaComponent(0.2)
        
        // MARK: - 선택 모서리
        // 선택된 날짜 모서리 설정 (0으로 하면 사각형으로 표시)
//        calendarView.appearance.borderRadius = 0
        
        // MARK: - 다중 선택
        // 다중 선택
        calendarView.allowsMultipleSelection = false

        // 꾹 눌러서 드래그 동작으로 다중 선택
        calendarView.swipeToChooseGesture.isEnabled = false
    }
    
    // MARK: - 날짜에 이벤트 추가하는 함수
    func setEvents() {
        
        // events
        let myFirstEvent = "2023-02-01"
        let mySecondEvent = "2023-02-13"
        let mythirdEvent = dateFormatter.string(from: today)
        
        events = [myFirstEvent, mySecondEvent , mythirdEvent]
        
    }
    
    // MARK: - 버튼으로 페이지 이동
    private func scrollCurrentPage(isPrev: Bool) {
        let cal = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = isPrev ? -1 : 1
        
        self.currentPage = cal.date(byAdding: dateComponents, to: self.currentPage ?? self.today)
        self.calendarView.setCurrentPage(self.currentPage!, animated: true)
    }
    
    // MARK: - custom header
    func headerSet(){
        headerTest.text = hd.string(from: calendarView.currentPage)
        headerTest.font = UIFont.boldSystemFont(ofSize: 10)
        if let text = headerTest.text{
            let range = (text as NSString).range(of: tcd.string(from: calendarView.currentPage))
            myLabelAdjustFont(text, size: 20, color: UIColor.black , range: range, label: headerTest)
        }
    }
    
    func eventCheck(date: Date){
        print(dateFormatter.string(from: date) + " 날짜가 선택되었습니다.")
        
        let check = dateFormatter.string(from: date)
        print(check)
        if events.contains(check){
            print("있음")
            labelTest.text = "이벤트가 있습니다"
        }else{
            print("없음")
            labelTest.text = "이벤트가 없습니다"
        }
    }
    
    func dateFormatterChange(date: Date) -> Date{
        let dateToStr = dateFormatter.string(from: date)
        let check = dateFormatter.date(from: dateToStr)
                
        return check!
    }
    
}



extension ViewController : FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance{
    
    // MARK: - 이벤트 표시 갯수 설정
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let check = dateFormatter.string(from: date)
        
        if self.events.contains(check) {
            return 1
        } else {
            return 0
        }
    }
    
    // MARK: - 날짜 선택 시 콜백 메소드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        eventCheck(date: date)
        
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
    
    // MARK: - 날짜별로 선택시 배경색상을 설정하는 메소드
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
//         switch dateFormatter.string(from: date) {
//         case "2023-01-05":
//             return .green
//
//         case "2023-01-06":
//             return .yellow
//
//         case "2023-01-07":
//             return .red
//
//        default:
//             return appearance.selectionColor
//         }
//    }
    
    // MARK: - title(날짜)의 디폴트 색상
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
//        return UIColor.white.withAlphaComponent(0.5)
//    }
        
    // MARK: - subtitle(이벤트)의 디폴트 색상
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleDefaultColorFor date: Date) -> UIColor? {
//        return UIColor.white.withAlphaComponent(0.5)
//    }
    
    // MARK: - 최대 선택 갯수를 제어하는 메소드
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
         // 날짜 n개까지만 선택
         if calendar.selectedDates.count > 3/*n*/ {
             return false
         } else {
             return true
         }
    }
    
    // MARK: - 페이징 처리
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.currentPage = calendar.currentPage
        headerSet()
    }
    
    // MARK: - 특정 날짜에 이미지 세팅
//    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
//        let imageDateFormatter = DateFormatter()
//        imageDateFormatter.dateFormat = "yyyyMMdd"
//        var dateStr = imageDateFormatter.string(from: date)
//        print("date : \(dateStr)")
//        return events.contains(dateStr) ? UIImage(named: "icon_cat") : nil
//    }
    
    
}

extension ViewController{
    // 라벨 특정부분만 폰트/사이즈 변경
    func myLabelAdjustFont(_ text:String, size : CGFloat, color: UIColor, range : NSRange, label: UILabel){
        
        // 폰트와 폰트 사이즈를 둘 다 변경
//        let font = UIFont(name:"Apple Color Emoji" , size: 50)
        
        // 폰트 사이즈만 변경
        let fontSize = UIFont.boldSystemFont(ofSize: size)
        
        //label에 있는 Text를 NSMutableAttributedString으로 만들어준다.
        let attributedStr = NSMutableAttributedString(string: text)
        
        // 위에서 만든 attributedStr에 addAttribute메소드를 통해 Attribute를 적용
        // value = font / fontSize
        attributedStr.addAttribute(.font , value: fontSize, range: range)
        attributedStr.addAttribute(.foregroundColor, value: color, range: range)
        
        // label에 속성을 적용
        label.attributedText = attributedStr
        label.sizeToFit()
        
    }
    
    // 라벨 특정 부분 색 변경
    func myLabelChangeColor(_ text:String, color: UIColor , range :NSRange){
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)
    }
    
    //Stoke지정 메소드
    func myLabelChangeStroke(_ text:String, range :NSRange){
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.strokeWidth, value:4.0, range: range)
        attributedString.addAttribute(.strokeColor, value: UIColor.blue, range: range)
        
    }
    
    //밑줄 그어주는 메소드
    func myLabelApplyUnderline(_ text:String, range :NSRange){
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.thick.rawValue, range: range)
        attributedString.addAttribute(.underlineColor, value: UIColor.blue, range: range)
        
    }
    
    
    //배경 지정 메소드
    func myLabelChangeBackgroundColor(_ text:String, range :NSRange){
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.backgroundColor, value: UIColor.blue, range: range)
        
    }
    
    //Strike지정 메소드 - 텍스트 가운데 줄
    func myLabelApplyStrike(_ text:String, range :NSRange){
        let attributedString = NSMutableAttributedString(string: text)
        // 아래에서 위로 뛰우는 정도
        attributedString.addAttribute(.baselineOffset, value: 0, range: range)
        // 줄 굵기
        attributedString.addAttribute(.strikethroughStyle, value: 1, range:range)
        
    }
}
