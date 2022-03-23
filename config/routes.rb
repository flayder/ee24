require 'resque/server'
# encoding : utf-8
Onru::Application.routes.draw do

  constraints SuperAdminAccessConstraint do
    mount Resque::Server.new, :at => "/resque"
  end

  constraints AuthorizedUsersConstraint do
    mount Ckeditor::Engine => '/ckeditor'
  end

  scope '/dictionaries' do
    constraints DictionaryConstraint.new do
      get ':link/rubric/:id' => 'dictionary_objects#rubric', :as => :dictionary_objects_rubric
      get ':link/letter/:letter' => 'dictionary_objects#letter', :as => :dictionary_objects_letter
      get ':link' => 'dictionary_objects#index', :as => :dictionary_objects
      get ':link/:id' => 'dictionary_objects#show', :as => :dictionary_object
    end
  end

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :register_for_remote_notifications, only: :create
      resources :doc_global_rubrics, only: :index do
        resources :doc_rubrics, only: :index
        resources :docs, only: [], controller: :'doc_global_rubrics/docs' do
          collection do
            get :count
          end
        end
      end

      resources :doc_rubrics, only: [] do
        get :doc_ids

        resources :docs, only: :index do
          collection do
            get :count, controller: :'doc_rubrics/docs'
          end
        end
      end

      resources :docs, only: :show do
        get :count, on: :collection
        get :show_html, defaults: { format: :html }
      end
    end
  end

  namespace :semantic_api do
    namespace :v1 do
      resources :docs, only: :index, defaults: { format: :json } do
        collection do
          get 'page_views'
        end
      end
    end
  end

  get 'admin' => 'admin/sites#show'
  get 'admin/tags/without/:taggable_type' => 'admin/tags#without', constraints: { taggable_type: /Doc|Gallery|Catalog|DictionaryObject/ }, as: :without_admin_tags
  namespace :admin do
    resources :photos do
      post :bulk_update, :on => :collection
    end

    resources :sites do
      get :change_default_site, on: :collection unless Rails.env.production?
    end

    resources :black_list_words, except: [:show, :update, :edit]

    namespace :design do
      resources :templates, except: :show
      resources :stylesheets, except: :show
    end

    namespace :forecast do
      resource :settings, only: [:edit, :update]
      resource :districts, only: [:edit, :update]
      resources :icons, only: [:index, :edit, :update]
    end

    resources :comments, only: [:index, :edit, :update, :destroy] do
      post :by_user_delete
    end
    resources :search_queries, :only => [:index]
    resources :industries, except: :show
    resources :professions, except: :show
    resources :linkers, :except => :show
    resources :sponsor_banners, :except => :show
    resources :ad_surfaces, :except => :show
    resources :ad_formats, :except => :show
    resources :ad_agencies, :except => :show
    resources :main_blocks
    resources :footer_blocks
    resources :main_sections, only: [:index, :edit, :update]
    resources :redirects, except: :show

    get 'versions' => 'versions#index'
    get 'versions/:item_type/' => 'versions#month', as: :item_type_versions
    get 'versions/:id/diff' => 'versions#diff', as: :version_diff
    get 'versions/:item_type/:item_id' => 'versions#show', as: :item_versions

    resources :edit_statistics

    resources :static_docs, :except => :show

    resources :social_widget_codes
    resources :web_analytics_blocks
    resource :metrika_api_account, :only => [:show, :edit, :update] do
      get :url_phrases
    end

    resources :dictionaries
    resources :dictionary_rubrics, :except => [:show]
    resources :dictionary_objects, :except => [:show] do
      put :toggle_approved, :on => :member
    end

    resources :catalogs, only: [] do
      get :autocomplete, on: :collection
    end

    resources :catalog_rubrics, :except => :show
    resources :event_rubrics, :except => :show
    resources :doc_global_rubrics, :except => :show
    resources :news_rubrics, :except => :show
    resources :photo_rubrics, :except => :show
    resources :doc_rubrics, :except => :show

    resources :site_admins do
      get :users, :on => :collection
    end
    resources :tags do
      collection do
        get :without_description
      end

      #get :semantic, :on => :collection
      delete :remove_from_doc, :on => :member
    end
    resources :site_rubrics, :only => :index

    resources :seo_catalog, :as => :catalog_rubrics

    resources :seos
    resources :users, :only => [:index] do
      put :toggle_ban, :on => :member
      get :become, :on => :member
      get :time_stats, on: :collection
    end

    resources :ad_codes do
      get :list, :on => :collection
      get :rubrics, :on => :collection
      get :section, :on => :collection
    end

    resources :main_menu_links, expect: :show

    get 'news_rss_links' => 'news_rss_links#index', :as => :news_rss_links

    resources :external_docs, except: :show
    resources :external_doc_rubrics, except: :show
    resources :categories
    resources :communities
    resources :questions
    resources :doc_announces, only: :create

    resources :request_forms, only: [:index, :destroy]
    resources :forms, only: [:index, :destroy]
  end

  namespace :design do
    resources :stylesheets, only: :show
  end

  resources :tags, :only => :show do
    get :autocomplete, :on => :collection
    get :news, :docs, :afisha, :photo, :catalog, :dictionary
  end

  resources :map, only: [:index, :show] do
    collection do
      get :search
      get :load_google_marks
      get :load_yandex_marks
      get :get_map_rubrics
      get :load_marks
      get :company, action: :show, as: :show_place
    end
  end
  get '/:controller/:action', :constraints => {
    :controller => /news\/economic|health\/med_dictionary/,
    :action => /yandex_widget|search_term/
  }

  # Редирект каталога недвижимости на новый сайт
  get '/realty/sale', to: redirect('http://realty.420on.cz')
  get '/realty/sale/:path', to: redirect('http://realty.420on.cz')

  # Афиша
  get 'afisha/rss' => redirect('/afisha.rss')
  get 'afisha/:id' => "afisha#rubric", constraints: RubricConstraint.new(:afisha, :id), as: :afisha_rubric
  get 'afisha/:rubric/:id' => "afisha#show_event", :constraints => RubricConstraint.new(:afisha, :rubric)
  get 'afisha/:rubric/:id/comments' => "afisha#comments", :constraints => RubricConstraint.new(:afisha, :rubric)

  resources :events, :path => :afisha, :controller => :afisha do
    get :approve, :on => :member

    collection do
      get 'not_approved/editors' => 'afisha#not_approved', as: :not_approved_editors, defaults: { editor: true }
      get 'not_approved/users' => 'afisha#not_approved', as: :not_approved_users
      get :my, as: :my
    end
  end

  # Погода
  get 'weather' => 'weather#index', :as => :weather

  # Html-sitemap
  get 'sitemap' => 'sitemap#index', as: :sitemap

  # Фото
  get 'photo/list/:old_list_id' => "photo#list"
  get 'photo/show/:old_list_id' => "photo#show"

  constraints RubricConstraint.new(:photo, :global_rubric_link) do
    get 'photo/:global_rubric_link/list/:gallery_id' => 'photo#list'

    get 'photo/:global_rubric_link/show/:gallery_id' => 'photo#show'
    get 'photo/:global_rubric_link/show/:gallery_id/:photo_id' => 'photo#show'

    get 'photo/:global_rubric_link' => 'photo#rubric', :as => :photo_rubrics
    #get 'photo/:global_rubric_link' => 'photo#index', :as => :photo_rubrics

    #redirects
    get 'photo/:global_rubric_link/:second_rubric_link/list/:gallery_id' => redirect('/photo/%{global_rubric_link}/list/%{gallery_id}')
    get 'photo/:global_rubric_link/:second_rubric_link/:third_rubric_link/list/:gallery_id' => redirect('/photo/%{global_rubric_link}/list/%{gallery_id}')

    get 'photo/:global_rubric_link/:second_rubric_link/show/:gallery_id' => redirect('/photo/%{global_rubric_link}/show/%{gallery_id}')
    get 'photo/:global_rubric_link/:second_rubric_link/show/:gallery_id/:photo_id' => redirect('/photo/%{global_rubric_link}/show/%{gallery_id}/%{photo_id}')

    get 'photo/:global_rubric_link/:second_rubric_link/:third_rubric_link/show/:gallery_id' => redirect('/photo/%{global_rubric_link}/show/%{gallery_id}')
    get 'photo/:global_rubric_link/:second_rubric_link/:third_rubric_link/show/:gallery_id/:photo_id' => redirect('/photo/%{global_rubric_link}/show/%{gallery_id}')

    get 'photo/:global_rubric_link/:second_rubric_link' => redirect('/photo/%{global_rubric_link}')
    get 'photo/:global_rubric_link/:second_rubric_link/:third_rubric_link' => redirect('/photo/%{global_rubric_link}')
  end

  resources :galleries, path: :photo, controller: :photo, :except => :show do
    get :approve, on: :member
    collection do
      get 'not_approved/editors' => 'photo#not_approved', as: :not_approved_editors, defaults: { editor: true }
      get 'not_approved/users' => 'photo#not_approved', as: :not_approved_users
      get :my, as: :my
    end
  end

  namespace :forecast, path: 'prognoz' do
    resources :locations, path: '', only: [] do
      get ':days_number' => 'locations#show', constraints: ForecastsAvailableDaysConstraint.new, as: :forecast
    end
  end

  # Справка
  get 'catalog/:rubric_id/show/:id', to: redirect('/catalog/show/%{id}')
  get 'catalog/show/:id' => "catalog#show"
  get 'catalog/:rubric_id/show/:id/comments' => "catalog#comments"
  get 'catalog/list/:id' => "catalog#list", as: :catalog_list
  resources :catalogs, path: :catalog, controller: :catalog, except: [:show] do
    get :approve, on: :member

    collection do
      get 'not_approved/editors' => 'catalog#not_approved', as: :not_approved_editors, defaults: { editor: true }
      get 'not_approved/users' => 'catalog#not_approved', as: :not_approved_users
      get :my, as: :my
    end
  end

  get '/change_photo/:id' => 'application#change_photo', :as => :change_photo

  # OLD REDIRECT
  get 'news/rss' => 'docs#index', default: { format: 'rss', global_rubric: 'news' }

  constraints VoronezhConstraint.new do
    get 'news/economic', :to => redirect('/dictionaries/economic')
    get 'news/economic/:letter', :to => redirect('/dictionaries/economic/letter/%{letter}')
    get 'news/economic/show/:id', :to => redirect('/dictionaries/economic/%{id}?old_model=Economics')
    get '/news/economic/show_news/*id' => 'application#render_404'
    get '/news/show_news/*id' => 'application#render_404'

    get 'health/med_dictionary', :to => redirect("/dictionaries/medical")
    get 'health/med_dictionary/:letter', :to => redirect("dictionaries/medical/letter/%{letter}")
    get 'health/med_dictionary/show/:id', :to => redirect('/dictionaries/medical/%{id}?old_model=Medical')

    get '/persona', :to => redirect('/dictionaries/persona')
    get '/persona/rubric/:id', :to => redirect('/dictionaries/persona/rubric/%{id}')
    get '/persona/letter/:letter', :to => redirect('/dictionaries/persona/letter/%{letter}')
    get '/persona/show/:id', :to => redirect('/dictionaries/persona/%{id}')

    get '/vrn', :to => redirect('/dictionaries/vrn')
    get '/vrn/rubric/:id', :to => redirect('/dictionaries/vrn/rubric/%{id}')
    get '/vrn/letter/:letter', :to => redirect('/dictionaries/vrn/letter/%{letter}')
    get '/vrn/show/:id', :to => redirect('/dictionaries/vrn/%{id}')

    resources :ad_surfaces, :path => '/ads', :only => [:index, :show] do
      get :search, :on => :collection
    end
  end

  # Работа
  get 'job' => 'job#index'#, :format => false

  scope 'job' do
    resources :vacancies, :controller => 'job', :defaults => {:type => 'vacancy'} do
      get :approve, :on => :member
      get :region_cities, :filter, :not_actual, on: :collection
    end
    resources :resumes, :controller => 'job', :defaults => {:type => 'resume'} do
      get :approve, :on => :member
    end
  end

  get '/job/yvl.xml' => 'job#yvl', :defaults => {:format => 'xml'}, :as => :yvl

  get 'job/professions' => 'job#professions'
  get 'job/region_cities' => 'job#region_cities'
  get '/vacancies/not_approved' => 'job#not_approved', :defaults => {:type => 'vacancy'}
  get '/resumes/not_approved' => 'job#not_approved', :defaults => {:type => 'resume'}
  get '/vacancies/my' => 'job#my', :defaults => {:type => 'vacancy'}
  get '/resumes/my' => 'job#my', :defaults => {:type => 'resume'}
  get '/job/vacancies/industry/:industry_id' => 'job#industry', :defaults => {:type => 'vacancy'}, :as => :vacancy_industry
  get '/job/resumes/industry/:industry_id' => 'job#industry', :defaults => {:type => 'resume'}, :as => :resume_industry
  get '/job/vacancies/profession/:profession_id' => 'job#profession', :defaults => {:type => 'vacancy'}, :as => :vacancy_profession
  get '/job/resumes/profession/:profession_id' => 'job#profession', :defaults => {:type => 'resume'}, :as => :resume_profession

  get '/vk_poll' => 'static_docs#vk_poll'
  constraints StaticDocsConstraint.new do
    get '/:id' => 'static_docs#show'
  end

  # Голосование
  post '/doc_ratings/vote' => 'doc_ratings#vote', :as => 'doc_rating'
  get '/doc_ratings/not_allowed' => 'doc_ratings#not_allowed'

  # Общие
  get 'robots.txt' => 'application#robots'

  get "account/login", :to => "sessions#new", :as => "login"
  get "account/signup", :to => "account#signup"
  post "account/signup", :to => "account#signup"

  post "account/login", :to => "sessions#create"
  delete "account/logout", :to => "sessions#destroy", :as => "logout"

  resources :sessions

  #регистрация через соцсети
  # TODO remove match
  match '/auth/:provider/setup' => 'omniauth_sessions#setup'
  match "/auth/:provider/callback" => 'omniauth_sessions#create'
  match '/:action' => 'omniauth_sessions#', :constraints => {:action => /confirm_oauth_sign_up|email_confirm|password_confirm/}
  match '/auth/failure' => "omniauth_sessions#failure"


  get 'news/new', to: "docs#new", defaults: { global_rubric: 'news' }
  resources :news, only: [:index, :show]

  #статейные разделы
  constraints RubricConstraint.new(:docs, :global_rubric) do
    get ':global_rubric/mailru_widget' => 'docs#mailru_widget', defaults: { global_rubric: 'news' }
    get ':global_rubric/new' => 'docs#new'
    post ':global_rubric' => 'docs#create'
    get ':global_rubric/:id/edit' => 'docs#edit'
    put ':global_rubric/:id' => 'docs#update'
    delete ':global_rubric/:id' => 'docs#destroy'

    get ':global_rubric/not_approved/editors' => 'docs#not_approved', defaults: { editor: true }
    get ':global_rubric/not_approved/users' => 'docs#not_approved'

    get ':global_rubric/approve/:id' => 'docs#approve'

    get ':global_rubric/my' => 'docs#my'

    get '/:global_rubric' => 'docs#index'
    get '/:global_rubric/:rubric' => 'docs#rubric'
    get '/:global_rubric/:rubric/:id' => 'docs#show'
    get '/:global_rubric/:rubric/:id/comments' => 'docs#comments'
  end

  get 'health/date/' => redirect('/health')
  get '/magazine/date' => redirect('/magazine')
  get 'travel/date/' => redirect('/travel')

  get 'users/:id' => 'account#profile', :as => :user
  get 'account/restore' => 'account#restore'
  get 'account/restore_password/:id' => 'account#restore_password'

  resources :users, :controller => :account do
    get :friends, :docs, :events, :photos, :comments, :companies,
        :change_avatar, :change_password,
        :messages, :new_message, :close_message,
        :edit
    post :update_avatar, :update_password, :create_message, :friend_approved, :friend_not_approved, :add_friend_approve
    put :update
    get :confirm
    get :not_confirm
    get :reconfirm

    delete :del_friend

    collection do
      post :restore_pwd
    end
  end

  resources :messages, only: [:destroy] do
  end

  root :to => "main#index"
  get 'main/rss' => 'main#rss', :defaults => { :format => :rss }
  get 'main/rambler_rss' => 'main#rambler_rss', :defaults => { :format => :rss }
  get 'main/yandex_rss' => 'main#yandex_rss', :defaults => { :format => :rss }
  get 'main/mailru_rss' => 'main#mailru_rss', :defaults => { :format => :rss }
  get 'main/zen_rss' => 'main#zen_rss', :defaults => { :format => :rss }


  #Старые редиректы
  get 'travel/:id/date' => redirect('/travel'), :defaults => {:controller => :travel}
  get 'health/:id/date' => redirect('/health'), :defaults => {:controller => :health}
  get 'news/list/:id' => redirect("/news/%{id}"), :defaults => {:controller => :news}
  get 'news/rubric/:id' => redirect("/news/%{id}"), :defaults => {:controller => :news}
  get 'news/docs/:id' => redirect("/news/%{id}"), :defaults => {:controller => :news}
  get 'news/show/:id' => redirect("/news/show/%{id}"), :defaults => {:controller => :news}

  get 'deathfish/rubric/:id' => redirect("/deathfish/%{id}"), :defaults => {:controller => :deathfish}
  get 'afisha/rubric/:id' => redirect("/afisha/%{id}"), :defaults => {:controller => :afisha}
  get 'travel/rubric/:id' => redirect("/travel/%{id}"), :defaults => {:controller => :travel}
  get 'health/rubric/:id' => redirect("/health/%{id}"), :defaults => {:controller => :health}

  %w(vacancies resumes).each do |job_type|
    get "/job/#{job_type}/show/:id" => redirect("/job/#{job_type}/%{id}"), :defaults => {:controller => "job/#{job_type}"}
    get "/job/#{job_type}/list" => redirect("/job/#{job_type}/"), :defaults => {:controller => "job/#{job_type}"}
  end

  get '/:controller' => ':controller#index', :constraints => { :controller => %r(search/catalog|search/events|search/photos|search/docs|search/job|search/dictionary_objects) }

  resources :categories do
    resources :communities do
      resources :posts, only: [:index, :show, :edit, :update, :destroy]
    end
    resources :questions, only: [:show, :edit, :update, :destroy] do
      get :popular, on: :collection
    end
  end

  resources :questions, only: [:new, :create] do
    collection do
      get 'not_approved/editors' => 'questions#not_approved', as: :not_approved_editors, defaults: { editor: true }
      get 'not_approved/users' => 'questions#not_approved', as: :not_approved_users
      get :my, as: :my
      get :popular, as: :popular
    end
  end
  resources :posts, only: [:new, :create]
  resources :communities, only: [:new, :create]

  resources :comments, only: [:index, :create, :edit, :update, :destroy] do
    post :by_user_delete
  end

  resource :comment_subscribers, only: [:create, :destroy]

  resources :ratings, only: [:create]

  get 'news/date/:year/:month/:day', to: 'news#index', :defaults => {:day => nil, :month => nil}
  get 'afisha/date/:year/:month/:day', to: 'afisha#index', :defaults => {:day => nil, :month => nil}
  get 'afisha/:rubric/date/:year/:month/:day', to: 'afisha#rubric', :defaults => {:day => nil, :month => nil}

  resource :request_forms, only: [:create]
  resource :forms, only: [:create]
end
