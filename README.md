# Sinatra 03

#### Emmet 기능

Ex) html파일에서 `html:5`#누르고 tab을 누르면 기본 html코드들이 자동 완성된다.



- ##### 준비사항

  ##### 필수 gem 설치

  `$ gem install sinatra`

  `$ gem install sinatra-reloader`

  

- 폴더 구조

  - app.rb

  - views/

    - posts  //게시글에 관련된 erb파일

    - layout.erb

      

#### 시작 페이지 만들기

```ruby
# app.rb
get '/lunch' do
    @lunch = ["김밥", "라면", "빵"]
    erb :lunch
end
```

```erb
<h1>오늘 점심은 <%= @lunch.sample %></h1>
```



### CRUD 방식

DB조작 가장 기초 방식 : create, read, update, delete

- Create

  ```ruby
  # 첫번 째 방식
  Post.create(title: "test", body: "test")
  
  # 두번 째 방법
  p = Post.new
  p.title = "test"
  p.body = "test"
  p.save #db에 작성
  ```

- Read

  ```ruby
  # get(id)
  Post.get(1) 
  ```

- Update

  ```ruby
  # 첫번 째 방식
  Post.get(1).update(title: "test", body: "test..")
  
  # 두번 째 방식
  p = Post.get(1)
  p.title = "제목"
  p.body = "내용"
  p.save
  ```

- Destroy

  ```ruby
  Post.get(1).destroy
  ```

  

#### [DataMapper](http://recipes.sinatrarb.com/p/models/data_mapper)

- ORM을 지원해준다 (Object Relational Mapper),  객체관계매핑

  객체지향에서의 class와 DB에 있는 내용을 mapping 해준다.
  cf. 몇 백만명이 쓰는 서비스의 대규모의 DB를 다루기에는 좋지는 않다.

`gem install datamapper`

`gem install dm-sqlite-adapter`

```ruby
# app.rb
# c9을 쓰는 경우 library충돌로 인해 코드 추가 필요
gem 'json', '~> 1.6'
require 'data_mapper'

# datamapper log 찍기
DataMapper::Logger.new($stdout, :bebug)

#blob.db 세팅
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")

#Post 객체 생성
class Post
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :body, Text
  property :created_at, DateTime
end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the post table
Post.auto_upgrade!
```



```ruby
require ./app.rb'
# 생성하기 예제
Post.create(title: "테스트", body: "테스트")

# 전체 불러오기
Post.all 
# id == 1 불러오기(특정 ID값)
Post.get(1)

# 처음 값 지우기
Post.first.destroy
# 변경하기
Post.last.update(title: "", body: "")
```



### [Bootstrap. ver 4.1](https://getbootstrap.com/docs/4.1/getting-started/introduction/)

