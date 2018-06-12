# sinatra 사용
# sinatra 자동적으로 reload하기(sinatra/reloader)

# ruby bundler
gem 'json', '~> 1.6'
require 'sinatra'
require 'sinatra/reloader'
require "bcrypt"
require './model.rb' #DB structure

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

# CREATE
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

# READ
#id를 통해 특정 글 검색하기(variable writing)
get '/posts/:id' do
    #id를 받아온다
    @id = params[:id]
    #DB에서 해당 id를 받아서 보낸다.
    @post = Post.get(@id)
   erb :'posts/show' 
end

# DELETE
get '/posts/destroy/:id' do
    @id = params[:id]
    Post.get(@id).destroy
    erb :'posts/destroy'
end

# Update
# 1. id를 받아와서 뿌려주고
# 2. id를 받아와서 내용 업데이트

get '/posts/edit/:id' do
    @post = Post.get(params[:id])
    erb :'posts/edit'
end

get '/posts/update/:id' do
    @id = params[:id]
    Post.get(@id).update(title: params[:title], body: params[:body])
    #redirect : 다시 Read로 넘기기
    redirect '/posts/'+@id
end

# User Create
get '/user/new' do
   erb :'user/new'
end

get '/user/create' do
    #비밀번호 체크
    @password = params[:password]
    @passwordConfirm = params[:passwordConfirm]
    if @password == @passwordConfirm
        #password는 보안을 줘서 저장
        User.create(name: params[:name],email: params[:email],password: BCrypt::password.create(@password))
    else
        redirect '/user/new'
    end
    erb :'user/create' 
end

get '/user' do
    @user = User.all
    erb :'user/users'
end

