# 트래블로그 - Travelog

여행자를 위한 OCR 기반 여행 기록 어플리케이션

## 목차
  - [1. 소개](#1-소개)
  - [2. 아키텍처](#2-아키텍처)
  - [3. 규칙](#3-규칙)
  - [4. 기술 스택](#4-기술-스택)
  - [5. 개발방법](#5-팀원)

## 1. 소개

## 2. 아키텍처

## 3. 규칙

### 3-1. 브랜치 전략
![title](https://media.vlpt.us/images/yejine2/post/e6833c35-f4ff-493a-b5a2-b4cd82f91f13/git-flow.png)   
[이미지 출처](https://www.campingcoder.com/2018/04/how-to-use-git-flow/)

#### main 브랜치
- 기준이 되는 브랜치로 사용자에게 제품이 배포됨.
- main 브랜치에서 개발을 진행하면 안됨.

#### develop 브랜치
- develop 브랜치 위에서 자유롭게 개발자들이 작업. 
- develop 브랜치를 개발할 때는 feature 브랜치를 따서 feature 브랜치 위에서 작업.

#### hotfix 브랜치
- main 브랜치의 서브용으로 프로젝트를 긴급 수정해야할 때 사용하는 브랜치.
- 완료된 hotfix 브랜치는 하나는 main, 다른 하나는 develop 브랜치와 병합.

#### feature 브랜치
- 새로운 기능을 추가하는 브랜치로 develop 브랜치로부터 파생.
- 기능 추가 완료 후 develop 브랜치에 병합.

### 3.2 커밋 규칙
1) 커밋 메시지 제목에 타입을 표시

    ex) Type : Commit Message

2) 커밋 종류
    - feat 	: 새로운 기능 추가
    - fix 		: 버그 수정
    - docs 	: 문서 수정
    - style 	: 코드 formatting, 세미콜론(;) 누락, 코드 변경이 없는 경우
    - refactor : 코드 리팩토링
    - test 	: 테스트 코드, 리팩토링 테스트 코드 추가
    - chore 	: 빌드 업무 수정, 패키지 매니저 수정

### 3.3 Swift 코딩 스타일
[Apple Developer Academy에서 사용하는 Swift 코딩 스타일](https://github.com/DeveloperAcademy-POSTECH/swift-style-guide)

## 4. 기술 스택

<!--
<img src="https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=Swift&logoColor=white"> <img src="https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=Python&logoColor=white"> <br>
<img src="https://img.shields.io/badge/Flask-000000?style=flat&logo=Flask&logoColor=white"> <img src="https://img.shields.io/badge/Mysql-4479A1?style=flat&logo=Mysql&logoColor=white"> <img src="https://img.shields.io/badge/Nginx-009639?style=flat&logo=Nginx&logoColor=white"> <img src="https://img.shields.io/badge/Gunicorn-499848?style=flat&logo=Gunicorn&logoColor=white"> <img src="https://img.shields.io/badge/Firebase-FFCA28?style=flat&logo=Firebase&logoColor=white"> <br>
<img src="https://img.shields.io/badge/AWS-232F3E?style=flat&logo=Amazon AWS&logoColor=white"> <img src="https://img.shields.io/badge/Docker-2496ED?style=flat&logo=Docker&logoColor=white"> <img src="https://img.shields.io/badge/Jenkins-D24939?style=flat&logo=Jenkins&logoColor=white"> <br> <img src="https://img.shields.io/badge/Jira-0052CC?style=flat&logo=Jira&logoColor=white"> <img src="https://img.shields.io/badge/Figma-F24E1E?style=flat&logo=Figma&logoColor=white"> <img src="https://img.shields.io/badge/Slack-4A154B?style=flat&logo=Slack&logoColor=white"> -->

## 5. 팀원 
| 이름 | 이승현 | 이정동 | 박준희 | 박다미 |
| --- | --- | --- | --- | --- |
| GitHub | [@hyuuuun](https://github.com/hyuuuun) | [@ljdongz](https://github.com/ljdongz) | [@junhxx](https://github.com/junhxx) | [@dami0806](https://github.com/dami0806) |
| 역할 | - | - | - | - |

