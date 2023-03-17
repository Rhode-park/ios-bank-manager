# 은행 창구 매니저🏦

## 목차
1. [소개](#1-소개)
2. [팀원](#2-팀원)
3. [타임라인](#3-타임라인)
4. [프로젝트 구조](#4-프로젝트-구조)
5. [실행화면(기능 설명)](#5-실행-화면기능-설명)
6. [트러블슈팅](#6-트러블-슈팅)
7. [참고링크](#7-참고-링크)

<br/>

## 1. 소개
 은행에서 1명의 은행원이 10-30명 사이의 고객의 업무를 1:1로 처리해주는 콘솔앱입니다. 은행원은 두 명의 예금 담당 은행원과 한 명의 대출 담당 은행원이 존재합니다. 고객을 생성할 때 고객이 볼 업무의 종류가 정해지며, 그에 따라서 은행원들이 예금과 대출 업무를 처리하는 방식입니다.

<br/>

## 2. 팀원

|⭐️Rhode| ⭐️Sehong |
| :--------: | :-------: |
|<img height="210px" src="https://i.imgur.com/XyDwGwe.jpg">| <img height="210px" src="https://i.imgur.com/64dvDJl.jpg"> |
| Navigator / Driver | Navigator / Driver |

</br>

## 3. 타임라인
### 프로젝트 진행 기간
**23.03.06 (월) ~ 23.03.17 (금)** 

|날짜|스텝| 타임라인 |
| :-------: | :-------: | ------- |
|03.06 (월) | STEP1 | BankQueue 구현 및 BankQueueTest 구현 |
|03.07 (화) | STEP1 | BankQueue 리팩토링 |
|03.08 (수) | STEP2 | Bank, Client, BankManager 구현 |
|03.09 (목) | STEP2 | - |
|03.10 (금) | STEP2 | Bank, Client, BankManager 리팩토링 |
|03.13 (월) | STEP3 | Bank, Client, BankManager 리팩토링 및 clientWaitingLine 클래스 구현 |
|03.14 (화) | STEP3 | Bank 리팩토링 |
|03.15 (수) | STEP2 | - |
|03.16 (목) | STEP2 | - |
|03.17 (금) | STEP2 | - |

<br/>

## 4. 프로젝트 구조
### 폴더 구조

````
BankManagerConsoleApp
│   ├── Bank.swift
│   ├── Client.swift
│   ├── ClientWaitingLine.swift
│   ├── Queue
│   │   ├── LinkedList.swift
│   │   ├── Node.swift
│   │   └── Queue.swift
│   └── main.swift
└── QueueTest
    └── QueueTest.swift
````


### 클래스 다이어그램

![](https://i.imgur.com/UwatlYH.png)

<br/>

## 5. 실행 화면(기능 설명)

| Invalid Input | Input 1 | Input 2 |
| :--------: | :--------: | :--------: |
| ![](https://i.imgur.com/3bERhPM.gif) | ![](https://i.imgur.com/gvtOjTE.gif) | ![](https://i.imgur.com/r0D61ll.gif) |
| 1, 2 외의 것을 입력하게 되면 '입력이 잘못되었습니다.' 라는 문구와 함께 다시 입력창이 나타납니다. | 1을 입력하면 10부터 30까지 중 랜덤한 숫자의 고객들이 들어오고 비동기적으로 그들의 업무를 처리하게 됩니다. 업무가 마감될 때 총 처리한 고객의 수와 처리에 걸린 시간이 나타납니다. | 2를 입력하면 프로그램이 종료됩니다. |

</br>

## 6. 트러블 슈팅

### 1. DispatchQueue.global().async가 실행되지 않았던 문제

현재의 코드는 다음과 같습니다:

```swift
private mutating func distributeClient(bankManagerCount: Int) {
    var clientList = managingClientQueue()
    let bankManager = BankManager()
    let group = DispatchGroup()
    let semaphore = DispatchSemaphore(value: 1)
    
    for _ in Int.zero..<bankManagerCount {
        DispatchQueue.global().async(group: group) {
            semaphore.wait()
            
            while !clientList.isEmpty {
                guard let client = clientList.dequeue()?.clientWaitingNumber else { return }
                
                bankManager.work(client: client)
                semaphore.signal()
            }
        }
    }
    group.wait()
}
```
원래는 코드에 `group.wait()`이 없었습니다. 그래서 `DispatchQueue.global().async(group: group)` 내부 코드가 실행되지 않았습니다. 비동기이기 때문에 업무를 던져주고 결과까지 기다리지 않는다는 것을 간과했었습니다. 그래서 `group.wait()` 코드를 삽입해주었습니다. 그 결과 해당 그룹의 모든 작업이 완료때까지 현재 스레드를 block 시킬 수 있었습니다.

`wait()`의 정의는 다음과 같습니다:
![](https://i.imgur.com/4Q4xCqb.png)

이와 비슷한 기능으로는 `notify(queue:)`가 있는 것으로 알고 있습니다. `notify(queue:)`는 그룹으로 묶인 모든 작업이 끝났을 때 실행될 작업을 넘겨줍니다.



### 2. 함수 실행 시간을 계산하는 workTime 메서드 구현


은행원 n명이 단 하나의 업무를 수행하고 완료하는데 걸리는 시간은 0.7초 입니다. 해당 부분을 구현하기 위해서 단순히 작업 하나(손님 1명) 에 0.7을 곱하는 단순 계산을 선택하는 방식과 실제 작업시간을 계산하는 방식 중 어떤것을 사용할지 고민하였습니다.

아래의 workTime 함수는 workTimeFunction이라는 매개변수를 가지는 클로저를 입력 받고, 해당 함수는 어떤 작업을 수행하는 함수를 의미합니다. 함수 내부에서는 먼저 작업 시작시간을 저장하고, 클로저를 호출하여 수행한 뒤 작업이 종료 되는 시간을 저장하고 있습니다. 이후 시작시간과 종료시간의 시간 차를 timeIntervalSince 메서드가 초단위로 계산하여 workTime을 반환해줍니다.

```swift
 private func workTime(workTimeFunction: () -> Void) -> TimeInterval {
    let startTime = Date()
        
    workTimeFunction()
        
    let endTime = Date()
    let workTime = endTime.timeIntervalSince(startTime)
        
    return workTime
}
```


### 3. 3명의 은행원이 동시에 업무를 처리하기 

은행에는 3명의 은행원이 근무하고, 2명은 예금업무를 1명은 대출업무를 처리합니다. 저희는 은행원들이 일을 동시에 할 수 있도록 커스텀큐를 생성해주었습니다. 
커스텀큐의 기본적인 설정은 Serial이기때문에 대출업무는 attributes를 설정해주지 않았고, 예금업무는 2명이서 동시적으로 업무를 보고 있기때문에 concurrent로 설정하고 semaphore의 value를 2로 설정하여 예금 업무를 담당하는 은행원 2명만이 동시적으로 일을 할 수 있도록 구현하였습니다. 
```swift
private let depositSemaphore = DispatchSemaphore(value: 2)
private let depositQueue = DispatchQueue(label: "loan", attributes: .concurrent)
    
private let loanQueue = DispatchQueue(label: "deposit")
```

```swift
private mutating func distributeClient() {
    let group = DispatchGroup()
    var clientQueue = clientWaitingLine.manageClientQueue()
    let bankManager = BankManager()
    
    while let client = clientQueue.dequeue() {
        switch client.banking {
        case .deposit:
            depositQueue.async(group: group) { [self] in
                depositSemaphore.wait()
                    
                bankManager.work(client: client)
                depositSemaphore.signal()
            }
        case .loan:
            loanQueue.async(group: group) {
                bankManager.work(client: client)
            }
        }
    }
    group.wait()
}
```

### 4. BankingType으로 ClientQueue생성하기 
저희는 처음에 Client를 생성할때 숫자를 랜덤으로 뽑아서 예금고객과 대출고객 번호를 각각 생성해주었습니다. 리뷰어의 조언을 받고 해당 부분은 예금과 대출이라는 banking 타입을 랜덤으로 고객을 생성하는 방식으로 변경해주었습니다.  
```swift
func manageClientQueue() -> Queue<Client>  {
    var clientQueue = Queue<Client>()
    clientCount = Int.random(in: 10...30)
        
    for i in 1...clientCount {
        Client.Banking.allCases.randomElement().map {
            clientQueue.enqueue(Client(clientWaitingNumber: i, banking: $0))
        }
    }
        
    return clientQueue
}
```

## 7. 참고 링크

> - [야곰닷넷 - 동시성프로그래밍](https://yagom.net/courses/%eb%8f%99%ec%8b%9c%ec%84%b1-%ed%94%84%eb%a1%9c%ea%b7%b8%eb%9e%98%eb%b0%8d-concurrency-programming/)
> - [WWDC 2015 Protocol - Oriented Programming in Swift](https://developer.apple.com/videos/play/wwdc2016/720/)
