# TIL
Today I learned



### how to use git bash

```bash
$ git init

# add all
$ git add .
    
# git 상태 확인
$ git status

# 완전한 저장 ('m' option: log로 남길 수 있음)
$ git commit -m "ruby md file ~flow of control"
# 성공시 create mode 100644 ~~식으로 나온다

# 처음 설정한 경우 config설정을 해야 한다
$ git config --global user.email "bb@google.com"
$ git config --global user.name "aa"

# remote : 위치 설정
$ git remote add origin https://github.com/hojinWoo/TIL.git
# 뒤의 주소를 origin이라는 별명으로 사용하겠다.
# remote 종류 확인
$ git remote -v


# first push : github upload
$ git push -u origin master

# 등록된 곳으로 push가 된다
$ git push
```

