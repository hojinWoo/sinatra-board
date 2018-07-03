# Make a Board by Sinatra

#### Emmet 기능

Ex) html파일에서 `html:5`#누르고 tab을 누르면 기본 html코드들이 자동 완성된다.

  

- ##### 필수 gem 설치

  `$ gem install sinatra`

  `$ gem install sinatra-reloader`

  

- 폴더 구조

  - app.rb
  - views/
    - posts  //게시글에 관련된 erb파일
    - layout.erb
    - .erb



### Layout

```ruby
def hello
    puts "hello"
    yield
    puts "world"
end

# {} :block 
hello {puts "ruby"}
# hello
# ruby
# world
```



#### 시작 페이지 만들기(routing 및 view 설정)

```ruby
# app.rb
require 'sinatra'
require "sinatra/reloader"

# routing 설정
get '/' do
    send_file 'index.html'
end

# example
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



#### CRUD 만들기

- Create

  ```ruby
  # 사용자에게 입력받는 창, DB 조작X
  get '/posts/new' do
  end
  
  # 실제로 DB에 저장하는 곳
  get '/posts/create'do
      Post.create(title: params[:title], body: params[:body])
  end
  ```

- Read

  ```ruby
  # app.rb 
  get 'posts/:id' do
  	@post = Post.get(params[:id])
  end
  ```

  

### params

1. variable routing

   ```ruby
   #app.rb
   get '/hello/:name' do
   	@name = params[:name]
   	erb :name
   end
   ```

   

2. `form` tag를 통해서 받는 법

   ```html
   <!--필수로 넣어야 할 것-->
   <form action = "/posts/create">
       <input name = "title">
   </form>
   ```

   ```ruby
   # app.rb
   # params {title: "ABC"}
   get '/posts/create' do
       @title = params[:title]
   end
   ```



#### [DataMapper](http://recipes.sinatrarb.com/p/models/data_mapper)

- ORM 지원 (Object Relational Mapper),  객체관계매핑

  객체지향에서의 class와 DB에 있는 내용을 mapping 해준다. (ruby와 sqlite 매핑)
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





#### Bundle 설치, 의존성을 편하게 해준다.

`$ gem install bundler`



##### Gemfile 만들기 : root directory에 만들어야 한다

```ruby
# Bundler => manage ruby application
source 'https://rubygems.org'
gem 'sinatra'
gem 'sinatra-reloader'
gem 'datamapper'
gem 'dm-sqlite-adapter'
gem 'json', '~> 1.6' #json version fix (C9 error clear)
```

> `$ bundle install`  : Gemfile에 있는 것들을 다 설치해준다






## User CRUD

필수 : email, password

- 회원가입(C)

- 회원 정보 보기(R)



#### 암호화

- ##### bcrypt (패스워드 저장 목적으로 설계. 99년 발표, 가장 강력한 해쉬 매커니즘 중 하나)

- `gem install bcrypt`

  ```ruby
  require 'bcrypt'
  
  a = "aa"
  b = BCrypt::Password.create(a)
  
  # 단방향 해쉬
  a == b
  # => false
  b == a
  # =>true
  b == "aa"
  # =>true
  ```

- [암호화 패스워드](https://d2.naver.com/helloworld/318732) 방식 SHA-256, MD-5 방식 등 다양한 방식이 있음
  MD-5방식은 뚫렸음..



## 도메인

#### heroku

- 가입 후 dashboard를 만들기
- ##### [Resources] - Add ons 추가 (po를 입력하면 생긴다)

  `Heroku Postgres :: Database` 만들기



#### 배포 시 필요한 설정. 

```ruby
## Gemfile ##
# Board, pg : Heroku에서 지원하는 db, local이므로 그냥 sqlite 사용중
group :production do
    gem 'pg'
    gem 'dm-postgres-adapter'
end


## model.rb ##
# need install dm-sqlite-adapter
configure :development do
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")
end
# For Heroku 
configure :production do
  DataMapper::setup(:default, ENV["DATABASE_URL"])
end
```

> #### `$ bundle install --without production`



##### Install the Heroku CLI

`$ heroku login`



##### Create a new Git repository

`$ heroku git:remote -a sinatra-board-ssol` (각자 게시판 이름)



#### config.ru

`touch /config.ru` 추가 **root directory에 있어야 함**

```ruby
require './app'
run Sinatra::Application
```

> Heroku에서 서버 실행 방법이 rake를 활용하기 때문에 설정 필요
>
> > `$ ruby app.rb -o $IP`
> >
> > `$ bundle exec rakeup config.ru -o $IP -p $PORT`



##### 배포 

```bash
$ git add .
$ git commit -m "aa"
$ git push heroku master
```

> 배포하는 방법도 정말 다양함..

[heroku 주소](https://sinatra-board-ssol.herokuapp.com/)