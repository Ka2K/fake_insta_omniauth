#### Post(1)

* posts 컨트롤러 `rails g controller posts index new create show edit update destroy` 
* post 모델`rails g model post title:string content:text `

#### Comment(N)

* comments 컨트롤러 

  * CRUD - Create

* comment 모델 

  * `rails g model comment content:string post_id:integer`


#### [Devise](https://github.com/plataformatec/devise)

1. `devise`gem 설치

   ``` ruby
   # Gemfile
   gem 'devise'
   ```

   ```erb
   $ bundle install
   ```

2. devise 설치

   ```erb
   $ rails generate devise:install
   ```

   * `config/initiallize/devise.rb` 만들어짐

3. user 모델 만들기

   ```erb
   $ rails generate devise use
   ```

   * `db/migrate/20180625_devise_create_users.rb`
   * `model/user.rb`
   * `config/routes.rb`: devise_for :users

4. migration

   ```erb
   $ rails db:migrate
   ```

5. routes 확인

   | new_user_session_path         | GET    | /users/sign_in(.:format)       | devise/sessions#new          |
   | ----------------------------- | ------ | ------------------------------ | ---------------------------- |
   | user_session_path             | POST   | /users/sign_in(.:format)       | devise/sessions#create       |
   | destroy_user_session_path     | DELETE | /users/sign_out(.:format)      | devise/sessions#destroy      |
   | user_password_path            | POST   | /users/password(.:format)      | devise/passwords#create      |
   | new_user_password_path        | GET    | /users/password/new(.:format)  | devise/passwords#new         |
   | edit_user_password_path       | GET    | /users/password/edit(.:format) | devise/passwords#edit        |
   |                               | PATCH  | /users/password(.:format)      | devise/passwords#update      |
   |                               | PUT    | /users/password(.:format)      | devise/passwords#update      |
   | cancel_user_registration_path | GET    | /users/cancel(.:format)        | devise/registrations#cancel  |
   | user_registration_path        | POST   | /users(.:format)               | devise/registrations#create  |
   | new_user_registration_path    | GET    | /users/sign_up(.:format)       | devise/registrations#new     |
   | edit_user_registration_path   | GET    | /users/edit(.:format)          | devise/registrations#edit    |
   |                               | PATCH  | /users(.:format)               | devise/registrations#update  |
   |                               | PUT    | /users(.:format)               | devise/registrations#update  |
   |                               | DELETE | /users(.:format)               | devise/registrations#destroy |

   * 회원가입 : `get '/users/sign_up'`
   * 로그인 : `get 'users/sign_in'`
   * 로그아웃 : `delete 'users/sign_out'`

6. helper method

   * `user_sign_in?` : 유저가 로그인 했는지 안했는지 true/false로 리턴
   * `current_user` :  로그인 되어있는 user 오브젝트를 가지고 있음
   * `before_action :authenticate_user!` : 로그인 되어있는 유저 검증(필터)

7. View 파일 수정하기

   ```erb
   $ rails generate devise:views users
   ```

1. [custom column 추가하기](https://github.com/plataformatec/devise#strong-parameters)

   1. migration 파일에 원하는 column 추가

   2. `app/views/devise/registrations/new.html.erb`에 input 추가

   3. `app/controllers/application_controller.rb`

      ```ruby
        before_action :configure_permitted_parameters, if: :devise_controller?
      
        protected
      
        def configure_permitted_parameters
          devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
        end
      ```


#### [Active Record Query Interface](https://guides.rorlab.org/active_record_querying.html#%EC%A1%B0%EA%B1%B4)

```ruby
Post.find(1)
Post.first(3) # 앞에서부터 3개
Post.last(3) # 뒤에서부터 3개
Post.order(:title) # title column data 기준으로 정렬
Post.order(title: :desc) # Z~a
Post.order(title: :asc) # a~z
Post.where("title=?", "Golduck") #title column에서 data가 Golduck인 것을 찾아라
Post.where("title like ?", "%duck%") #title column에서 data에 duck이 들어간 것을 찾아라
Post.where.not("조건")
User.where("age > ? AND gender = ?", 25,"male") # 나이 25 초과, 남자 
```



#### [Form_tag, Form_for](https://guides.rorlab.org/form_helpers.html)

```erb
<form action="/posts" method="post">
  <input type="text" name="title" /> <br />
  <textarea name="content"></textarea> <br />
  <input type="hidden" name="authenticity_token" value="<%=form_authenticity_token%>">
  <input type="submit"
</form>
```

```erb
<%= form_tag('/posts', method: 'post') do %>
  <%= text_field_tag :title %>
  <%= text_area_tag :content %>
  <%= submit_tag "Submit" %>
<% end %>

```

```erb
<!-- new.html.erb와 edit.html.erb에서 똑같이 사용할 수 있음 => layout으로 뽑아서 사용 가능 -->
<%= form_for @post do |f| %>
  <%= f.text_field :title %>
  <%= f.text_area :content %>
  <%= f.submit %>
<% end %>
```

* `form_for` 주요 특징
  * 특정한 모델의 객체(POST)를 조작하기 위해 사용
  * 별도의 url(action="/"), method(get, post, put) 명시하지 않아도 됨.
  * Controller의 해당 액션(`new`,`edit`)에서 반드시 @post에 Post 오브젝트가 담겨야 함.
    * `new`:`@post = Post.new`
    * `edit`:`@post = Post.find(id)`
  * 각 input field의 symbol은 반드시 @post의 column 명이랑 일치해야 함.

#### [link_to : url helper](https://apidock.com/rails/ActionView/Helpers/UrlHelper/link_to)

```erb
<%= link_to '글보기', @post %>
<%= link_to '글보기', post_path %>
<%= link_to '새 글 쓰기', new_post_path %>
<%= link_to '글 수정', edit_post_path %>
<%= link_to '모든 글 보기', posts_path %>
<%= link_to '글 삭제', post_path, method: :delete, data: {confirm: "지울래?"} %>
```



#### [gem : simple form](https://github.com/plataformatec/simple_form)

1. Gemfile 설정

   ```ruby
   gem 'simple_form
   ```

2. bundle install

    ```erb
   $ bundle install
    ```

3. 설치

   ```erb
   $ rails generate simple_form:install --bootstrap
   ```

4. Bootstrap 프로텍트에 적용

   CDN을 `application.erb`에 넣어주기

5. Form helper 만들기

   ```ruby
   <%= simple_form_for @post do |f| %>
     <%= f.input :title %>
     <%= f.input :content %>
     <%= f.button :submit, class: "btn-info" %>
   <% end %>
   ```

#### Scaffold

```erb
$ rails new project_name
$ cd project_name
$ rails g scaffold post title:string content:text
$ rake db:migrate
```

* 4개의 코드로 빠르게 게시판을 만들 수 있음.

   