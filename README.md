# [PLAYTE](https://apps.apple.com/kr/app/playte/id6463757225)
![Swift](https://img.shields.io/badge/swift-5.7-orange?logo=swift) 
![Xcode](https://img.shields.io/badge/xcode-14.1-orange?logo=xcode)
![iOS](https://img.shields.io/badge/iOS-14.0-orange)

<br>
<img src="https://github.com/Central-MakeUs/Re_Cipe_iOS/assets/66459715/4a772a30-c899-4e37-ba6e-c0330d5e6fc9.png" width="260"></img>&nbsp;&nbsp;&nbsp;<img src="https://github.com/Central-MakeUs/Re_Cipe_iOS/assets/66459715/ad49f6b7-8f1a-4acc-adb2-e74468ab6a30.png" width="260"></img>&nbsp;&nbsp;&nbsp;<img src="https://github.com/Central-MakeUs/Re_Cipe_iOS/assets/66459715/7b883ecb-2752-4ba3-8926-0d6b38341094.png" width="260"></img>
<img src="https://github.com/Central-MakeUs/Re_Cipe_iOS/assets/66459715/78e7c30b-1730-4167-92c6-b56c876cbec9.png" width="260"></img>&nbsp;&nbsp;&nbsp;<img src="https://github.com/Central-MakeUs/Re_Cipe_iOS/assets/66459715/fbf442ec-53f7-4e7e-b0da-40e5c480d979.png" width="260"></img>&nbsp;&nbsp;&nbsp;<img src="https://github.com/Central-MakeUs/Re_Cipe_iOS/assets/66459715/7f08e887-ae44-4ec2-ae6d-01dddb1dba2d.png" width="260"></img>
 <br>

> 레시피, 이제는 읽지말고 플레이하자! <br>
> 숏폼을 이용한 레시피 간편 제공 커뮤니티 "플레이트" <br>

    넘쳐나는 요리 레시피, 하나하나 읽고 찾아보기 너무 힘들어요🥲
  
    플레이트에서는 짧은 시간 동안 요리의 기승전결을 파악할 수 있도록 숏폼을 이용해 레시피를 제공합니다.
  
    사용자들은 나만의 레시피를 간편하게 플레이하면서 맛있는 요리 문화를 만들어나갈 수 있어요!

## ⭐️주요 기능

- 레시피 동영상 플레이(미리보기 지원)
- 레시피 글로 확인하기 지원
- 사용자 업로드 기능
- 댓글, 대댓글, 리뷰 등 사용자 후기 작성 가능
- 레시피 저장 가능

<br>
<br>

## 🛠기술 스택 및 구조
- Architecture: MVVM-C
- UIKit Programmatically
- RxSwift
    - debounce를 통해 서버 통신 하기 전, 지연을 주어 검색로직에 활용하였습니다.
    - 뷰모델을 통한 Input, Output을 이용하여 Network, Component들의 비즈니스 로직을 분리하기 위해 사용하였습니다.
      
- RxCocoa
    - TextField 및 Button의 Action을 보다 편리하게 Delegate 및 addTarget 함수를 작성하지 않고 사용하기 위해 채택하였습니다.
      
- RxKeyboard
    - TextField의 키보드를 동적으로 위치를 조정하기 위해 일부 사용하였습니다.
 
- CoreData
    - 사용자의 최근 시청기록을 저장하기 위해 사용되었습니다.
    - 유저를 차단하기 위해 내부적으로 저장해두었다 필터링 하기 위한 목적으로 사용되었습니다.
    - 최근 검색 키워드를 저장하기 위해 사용되었습니다.
      
- Alamofire
    - 이미지, 동영상을 업로드 할 때(multipart/form-data) 사용하였습니다.
      
- SnapKit
    - Code UI를 작성하기 위해 사용하였습니다.
      
- AVFoundation
    - 리뷰와 레시피 작성을 위한 사진 및 동영상을 사용자의 앨범으로부터 가져오기 위해 사용되었습니다.
    - 사진 다중 선택 및 갯수제한 기능을 사용하기 위해 사용하였습니다.
    - 동영상의 길이가 60초이하인 영상만 선택할 수 있게 하는 필터링 기능을 사용하였습니다.
    - 동영상 재생(미리보기 포함)을 위해 사용하였습니다.
    - 동영상 볼륨조절과 특정 영상 시간대로 영상재생을 위해 사용되었습니다.
    - 동영상 썸네일 추출을 위해 사용하였습니다.
