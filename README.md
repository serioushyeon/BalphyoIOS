# 발표몇분
### 최고의 발표를 돕는 최적의 발표 도우미, 발표몇분

2071446 진지현

<br>

### 1.프로젝트 수행 목적

#### 1.1 프로젝트 정의

* chat gpt api와 asw polly tts를 활용한 발표 도우미 어플리케이션



#### 1.2 프로젝트 배경

* 발표에서 중요한 가치 중 하나는 정해진 시간 안에 정확히 발표를 마무리하는 것이다. 발표몇분은 발표를 준비하고 연습하는 과정을 효율적으로 개선하고, 누구나 효과적으로 발표할 수 있도록 지원한다.
* 발표 시간과 관련된 어려움을 파악하기 위해 대학생을 대상으로 설문조사를 진행한결과, 82.9%가 정해진 시간에 맞춰 발표를 끝내는 것에 어려움을 느낀 경험이 있다고 응답하였다. 또한 발표를 준비할 때 발표시간 관리를 어렵게 한 원인 중 1위는 직접 측정하기 전까지는 작성한 대본의 발화시간을 알 수 없음, 2위는 제한시간에 맞는 적절한 양의 대본 작성, 3위는 대본과 남은 시간을 동시에 보며 연습하기 어려움이라는 결과가 나왔다.(발표 시간 관리 서비스’ 수요조사 (2024년 3월 8~21일, 304명 응답)
* 이러한 어려움을 해소하기 위해 발표 몇분은 제한된 시간에 맞춘 발표를 준비하고 연습하는 과정을 효율적으로 개선하는 서비스를 제공한다.

<img width="1005" alt="스크린샷 2024-06-19 오후 3 11 15" src="https://github.com/serioushyeon/BalphyoIOS/assets/108039053/4d96dfb1-df96-4faf-9a43-b09d321f8c2b">

<img width="1005" alt="image" src="https://github.com/serioushyeon/BalphyoIOS/assets/108039053/31f190e7-b930-4aed-a10e-ccb15a02a7dc">



#### 1.3 프로젝트 목표

* 발표 시간 맞춤형 대본 생성
  * 원하는 시간에 맞는 대본을 생성해준다.
* 발표 시간 계산기
  * 대본과 목표 발표 시간, 말의 빠르기를 입력하면 TTS로 생성된 음원의 시간과 목표 시간을 비교하여 초과,부족,일치 여부를 알려준다. 초과될 시 SpeechMark를 활용하여 초과된 분량의 텍스트를 하이라이팅하여 보여준다.
* 발표 훈련 플로우 컨트롤러
  * 발표 대본을 노래방처럼 재생하며 발표를 연습할 수 있다. 작성한 대본을 TTS가 읽어주며 실시간으로 해당 대본 텍스트를 하이라이팅해주어 발표 연습에 도움을 준다.

### 2. 프로젝트 개요

#### 2.1 프로젝트 설명

* UID 방식으로 사용자를 식별한다.
* 대본 생성: 대본의 제목, 주제, 소주제(5개까지), 목표 발표 시간을 입력하면 Chat GPT API를 활용하여 자동으로 대본을 생성해준다. 생성된 대본은 직접 수정하거나 보관함에 저장 가능하다.
* 발표 시간 계산: 대본의 제목과 대본을 입력한다. 대본은 보관함에서 바로 불러와서 입력이 가능하다. 원하는 목표 시간과 말의 빠르기를 입력하면 주어진 대본을 TTS가 읽은 시간과 목표 시간을 비교하여 초과, 부족 시 몇분 몇초가 차이나는지 알려준다. 초과된 분량의 텍스트는 SpeechMark를 활용하여 하이라이팅한다.
* 발표 훈련 플로우 컨트롤러 : 업데이트 예정입니다.

#### 2.2 결과물

* 스플래시, 로그인, 홈, 로딩화면

  <img width="1004" alt="스크린샷 2024-06-19 오후 3 07 18" src="https://github.com/serioushyeon/BalphyoIOS/assets/108039053/484adf3f-ff55-48a2-81ad-e719f7cf4afd">

* 발표 대본 생성

  <img width="1006" alt="스크린샷 2024-06-19 오후 3 14 28" src="https://github.com/serioushyeon/BalphyoIOS/assets/108039053/3da85398-ee13-49c8-a952-e174d889ce56">

* 발표 시간 계산

  <img width="1009" alt="스크린샷 2024-06-19 오후 3 07 59" src="https://github.com/serioushyeon/BalphyoIOS/assets/108039053/24faf77a-1cfa-4a1b-8742-911da8ec8b94">

  <img width="1007" alt="스크린샷 2024-06-19 오후 3 08 13" src="https://github.com/serioushyeon/BalphyoIOS/assets/108039053/47cf581d-9352-4fa9-a18b-d18c6f9654b0">

* 보관함

  <img width="420" alt="image" src="https://github.com/serioushyeon/BalphyoIOS/assets/108039053/49a8862c-647f-4e5d-a000-16f3bfb9e7d2">

  <img width="420" alt="image" src="https://github.com/serioushyeon/BalphyoIOS/assets/108039053/cf51a108-a93b-4627-aade-709347268e45">

* 발표 훈련 플로우 컨트롤러 (업데이트 예정)

  <img width="420" alt="image" src="https://github.com/serioushyeon/BalphyoIOS/assets/108039053/3efe113f-cea5-4453-9f72-d5583b0dabdb">




#### 2.4 기대효과

<img width="823" alt="image" src="https://github.com/serioushyeon/BalphyoIOS/assets/108039053/b1c6334e-209b-4dec-a85d-a880dd7113ac">


#### 2.5 관련 기술

* AWS Polly
* SpeechMark
* Chat Gpt API
  
#### 2.6 개발 도구

* Xcode
* SpringBoot
* Git
* Docker
* AWS

#### 2.7 발표영상

Youtube 동영상

 [<img width="856" alt="image" src="https://github.com/serioushyeon/BalphyoIOS/assets/108039053/8af123fe-fae4-401a-bf32-4037e5249e97">
](https://youtu.be/SnZrh8Kuvt0?si=zfASSXkqVCR2qPUT)
