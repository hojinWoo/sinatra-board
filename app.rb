# sinatra 사용
# sinatra 자동적으로 reload하기(sinatra/reloader)
gem 'json', '~> 1.6' #json version fix (C9 error clear)
require 'sinatra'
require "sinatra/reloader"
require 'data_mapper'

# datamapper log 찍기
DataMapper::Logger.new($stdout, :bebug)

# need install dm-sqlite-adapter
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")

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

# parameter log 찍기
before do
   p "********************"
   p params
   p "********************"
end


# '/'경로 => index.html
# 라우팅 설정
get '/' do
    send_file 'index.html'
end

# 'lunch' 경로 => @lunch.sample을 erb에서 보여주기
get '/lunch' do
    @lunch = ["김밥", "라면", "빵"]
    erb :lunch
end

#게시글 전부 보여주기
get '/posts' do
    #data mapper 활용, 전부 보여주기
    @posts = Post.all.reverse
   erb :'posts/posts' 
end


get '/posts/new' do
   erb :'posts/new'
end

get '/posts/create' do
    @title = params[:title]
    @body = params[:body]
    
    #SQL문과 mapping이 된다.
    
    #symbol로 따로 빠르게 가져올 수 있다.
    # Object_id : memory의 id를 알 수 있다.
    # symbol을 쓰면 같은 메모리를 쓰기 때문에 string보다 더 빠르게 접근 가능 (불변)
    Post.create(title: @title, body: @body)
    #cf. 예전에 쓴 문법 : Post.create(title => @title)
    
    erb :'posts/create'
end