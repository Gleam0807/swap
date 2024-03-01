# Swap - 습관을 관리하고 트로피를 수집하는 앱

<div align="center">

[![iOS](https://img.shields.io/badge/iOS-17.0+-orange?logo=apple)]()
[![Xcode](https://img.shields.io/badge/xcode-v15.2-blue?logo=xcode)]()
[![swift](https://img.shields.io/badge/swift-v5.9-orange?logo=swift)]()
[![realm](https://img.shields.io/badge/realm--orange?logo=realm)]()


</div align="center">

| Light | Dark |
|----------|----------|
| <img src="https://github.com/Gleam0807/swap/assets/73210774/e4944950-67d6-4311-9ae9-e4b885739672" width="450"> | <img src="https://github.com/Gleam0807/swap/assets/73210774/b430c870-7c7f-4844-af9e-76d4759c2bac" width="450"> |

## 프로젝트 소개
사용자가 특정 목표를 설정하고 해당 목표를 실시간으로 관리하고 달성할 수 있도록 해주는 [습관기록] 어플 이며, 목표 달성의 지루함을 없애기 위해 '트로피수집' 기능을 도입하여 사용자들에게 재미요소를 추가했습니다. 
사용자는 목표를 설정하고 달성함으로써 다양한 트로피를 수집할 수 있습니다.

## 개발 정보

**개발 기간** 24.01.28. ~ 24.02.29. (1달)

**개발 인원** 1인

**앱스토어 링크** [AppStore](https://apps.apple.com/kr/app/mypetbox/id6444332365?l)

# Trouble Shooting(트러블 슈팅)
## 1. FSCalendar에서 주간달력 사용 시 일자가 깨지며 정상적으로 표시가 되지 않는 문제 발생
**🛠️ 해결방법 🛠️**
> 구글링하여 원인을 찾아본 결과 FSCalenda에 이슈로 이미 등록되어있던 문제였으며, FSCalenda에 자체에 frame을 수정해주어 문제를 해결할 수 있었습니다.

> https://github.com/WenchaoD/FSCalendar/issues/655를 참고하여 수정하였습니다.
```swift
-- FSCalendar.m 수정

- (CGFloat)preferredRowHeight
{
    if (_preferredRowHeight == FSCalendarAutomaticDimension) {
        CGFloat headerHeight = self.preferredHeaderHeight;
        CGFloat weekdayHeight = self.preferredWeekdayHeight;
        CGFloat contentHeight = self.transitionCoordinator.cachedMonthSize.height-headerHeight-weekdayHeight;
        CGFloat padding = 5;
        if (!self.floatingMode) {
            _preferredRowHeight = (contentHeight-padding*2)/6.0;
        } else {
            _preferredRowHeight = _rowHeight;
        }
    }
    //return _preferredRowHeight;
    return _rowHeight;
}
```

## 2. 앱 실행 시 신규유저와 기존유저에 mainView가 나뉘도록 수정
**🛠️ 해결방법 🛠️**
> AppDelegate에서 initialViewController를 설정하여 닉네임이 없으면 신규유저 뷰로 있으면 기존유저 뷰로 이동하도록 수정하였습니다.
```swift
-- AppDelegate.swift 일부

let defaults = UserDefaults.standard
let name = defaults.string(forKey: "nickname")
var initialViewController: UIViewController?

if name == nil {
    initialViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController // 신규유저
} else {
    initialViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController // 기존유저
}
```

## 3. Date타입 사용 시 한국시간과 차이가 나는 문제 발생
**🛠️ 해결방법 🛠️**
> 한국시간으로 바꾸기 위해서는 DateFormatter를 하여 locale과 timezone을 설정하여 시간대를 변경해주었습니다.
```swift
-- UIViewController++Extension.swift 일부

extension DateFormatter {
  var recordDisplayDateFormatter: DateFormatter {
    let formatter = self
    formatter.dateFormat = "yyyy년 MM월 dd일"
    formatter.locale = Locale(identifier: "ko_kr")
    formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    return formatter
  }
}
```

## 4. 다중 이미지 처리 방법 이슈
**🛠️ 해결방법 🛠️**
> 다중 이미지 저장 시 Data타입으로 저장 후 UIImage로 변환하는 방법과 firebase를 연동하여 이미지를 저장 후 불러오는 방법 등 다양한 방법이 존재하였지만

> 이미지가 많아짐에 따라 크래쉬가 발생해 앱이 죽어버릴 수도 있으나, 사용자가 많지않을것이라고 판단해 Data타입으로 저장 하여 보여주는걸 택했습니다. 만약 사용자가많다면 firebase 등 다른 방법이 더 적합할것이라고 생각합니다.
```swift
-- SwapRecord.swift 일부

@Persisted var firstImage: Data?
@Persisted var secondImage: Data?
@Persisted var thirdImage: Data?
@Persisted var fourthImage: Data?  // 최대 4개의 이미지가 받을 것이기에 4개의 변수를 만들어 관리합니다.

-- SwapRecordRepository.swift 일부

if !images.isEmpty {
    for (index, image) in images.prefix(4).enumerated() {
        let imageData = image.jpegData(compressionQuality: 0.8) // jpegData로 변환
        switch index {
            case 0: swapRecord.firstImage = imageData
            case 1: swapRecord.secondImage = imageData
            case 2: swapRecord.thirdImage = imageData
            case 3: swapRecord.fourthImage = imageData
            default: break
        }
    }
}

-- RecordViewController.swift

if let swapId = swapId {
    let imageData = swapRecordRepository.fetchImages(swapId: swapId, recordDate: selectedDate ?? Date())
    if !imageData.isEmpty {
        let imageViews = [cell.firstImage, cell.secondImage, cell.thirdImage, cell.fourthImage]
        for (index, imageView) in imageViews.enumerated() { // imageViews에 알맞는 이미지를 UIImage로 변환 후 반영
            guard let imageData = imageData[index] else { break }
            if let image = UIImage(data: imageData) {
                imageView?.image = image
            }
        }
    }
} else {
    cell.secondImage.image = nil
    cell.thirdImage.image = nil
    cell.fourthImage.image = nil
}
```
 
## 5. 알림 설정 시 여러 날짜에 대해 대응이 안되는 문제 발생
**🛠️ 해결방법 🛠️**
> 날짜 하나에 대한 알림을 설정하는 건 구현하였으나, 여러 날짜에 대한 설정을 하려면 저장되어있는 startDate와 endDate를 불러와 startDate부터 endDate까지 반복하여 알림을 예약하도록 구현하여 해결하였습니다.

```swift
-- SwapListRepository.swift 일부

func scheduleNotification(title: String, seletedTimeDate: Date, identifierCnt: Int) {
  let content = UNMutableNotificationContent()
  content.title = "Swap 알림"
  content.body = "\(title)를 실천하실 시간이에요🙌"
  content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "Clock.mp3")) // 커스텀 알림음
  let calendar = Calendar.current
  let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: seletedTimeDate)

  let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
  //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) //테스트용
  let request = UNNotificationRequest(identifier: "SwapAlarm_\(identifierCnt)", content: content, trigger: trigger)

  UNUserNotificationCenter.current().add(request) { error in
      if let error = error {
          print("Notification Error: ", error)
      }
  }
}

func scheduleNotificationsForRange(title: String, startDate: Date, endDate: Date, selectedTimeDate: Date) {
  let calendar = Calendar.current
  var alarmDate = startDate
  var identifierCnt = 1
  // startDate부터 endDate까지 반복하면서 알림 예약
  while alarmDate <= endDate {
      let notificationTime = calendar.date(bySettingHour: calendar.component(.hour, from: selectedTimeDate), minute: calendar.component(.minute, from: selectedTimeDate), second: 0, of: alarmDate)!
      scheduleNotification(title: title, seletedTimeDate: notificationTime, identifierCnt: identifierCnt)

      // 다음 날짜로 설정
      alarmDate = calendar.date(byAdding: .day, value: 1, to: alarmDate)!
      identifierCnt += 1
  }
}

-- AppDelegate.swift

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  requestNotificationAuthorization()
  UNUserNotificationCenter.current().delegate = self
}

func requestNotificationAuthorization() {
  let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .sound)

  UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { success, error in
      if let error = error {
          print("Error: \(error)")
      }
  }
}
```
