# OmniAuth VKontakte

[![Build Status][travis_badge]][travis]
[![Gem Version][rubygems_badge]][rubygems]
[![Code Climate][codeclimate_badge]][codeclimate]

This is the unofficial [OmniAuth](https://github.com/intridea/omniauth) strategy for authenticating to VKontakte via OAuth.
To use it, you'll need to sign up for an OAuth2 Application ID and Secret
on the [Vkontakte Developers Page](http://vk.com/dev).

## Basic Usage

```ruby
use OmniAuth::Builder do
  provider :vkontakte, ENV['API_KEY'], ENV['API_SECRET']
end
```

## Configuring
You can configure several options, which you pass in to the `provider` method via a `Hash`:

* `scope`: a comma-separated list of access permissions you want to request from the user. [Read the Vkontakte docs for more details](http://vk.com/dev/permissions)
* `display`: the display context to show the authentication page. Valid options include `page`, `popup` and `mobile`.
* `lang`: specifies the language. Optional options include `ru`, `ua`, `be`, `en`, `es`, `fi`, `de`, `it`.
* `image_size`: defines the size of the user's image. Valid options include `mini`(50x50), `bigger`(100x100), `bigger_x2`(200x200), `original`(200x*) and `original_x2`(400x*). Default is `mini`.
* `info_fields`: specify which fields should be added to AuthHash when
  getting the user's info. Value should be a comma-separated string as per http://vk.com/dev/fields.
* `redirect_url`: URL where code will be passed. This URL shall be a part of the domain specified in application settings http://vk.com/dev/auth_sites.
* `https`: 1 - allows you to receive https links to photos and other media. 0 - return an http links (the default).

Here's an example of a possible configuration:

```ruby
use OmniAuth::Builder do
  provider :vkontakte, ENV['API_KEY'], ENV['API_SECRET'],
    {
      :scope => 'friends,audio,photos',
      :display => 'popup',
      :lang => 'en',
      :https => 1,
      :image_size => 'original'
    }
end
```

## Authentication Hash

Here's an example *Auth Hash* available in `request.env['omniauth.auth']`:

```ruby
{"provider"=>"vkontakte",
 "uid"=>"1",
 "info"=>
  {"name"=>"Павел Дуров",
   "nickname"=>"",
   "first_name"=>"Павел",
   "last_name"=>"Дуров",
   "image"=>"http://cs7001.vk.me/c7003/v7003079/374b/53lwetwOxD8.jpg",
   "location"=>"Росiя, Санкт-Петербург",
   "urls"=>{"Vkontakte"=>"http://vk.com/durov"}},
 "credentials"=>
  {"token"=>
    "187041a618229fdaf16613e96e1caabc1e86e46bbfad228de41520e63fe45873684c365a14417289599f3",
   "expires_at"=>1381826003,
   "expires"=>true},
 "extra"=>
  {"raw_info"=>
    {"id"=>1,
     "first_name"=>"Павел",
     "last_name"=>"Дуров",
     "sex"=>2,
     "nickname"=>"",
     "screen_name"=>"durov",
     "bdate"=>"10.10.1984",
     "city"=>{"id"=>2, "title"=>"Санкт-Петербург"},
     "country"=>{"id"=>1, "title"=>"Росiя"},
     "photo"=>"http://cs7001.vk.me/c7003/v7003079/374b/53lwetwOxD8.jpg",
     "photo_big"=>"http://cs7001.vk.me/c7003/v7003736/3a08/mEqSflTauxA.jpg",
     "online"=>1,
     "online_app"=>"3140623",
     "online_mobile"=>1}}}
```

The precise information available may depend on the permissions which you request.


## Supported Rubies

Tested with the following Ruby versions:

- MRI 2.3
- MRI 2.2
- MRI 2.1
- MRI 2.0
- MRI 1.9.3
- JRUBY 1.x

## Contributing to omniauth-vkontakte

* Fork, fix, then send me a pull request.

## License

Copyright (c) 2011-2016 Anton Maminov

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[travis_badge]: http://img.shields.io/travis/mamantoha/omniauth-vkontakte.svg?style=flat
[travis]: https://travis-ci.org/mamantoha/omniauth-vkontakte

[rubygems_badge]: http://img.shields.io/gem/v/omniauth-vkontakte.svg?style=flat
[rubygems]: http://rubygems.org/gems/omniauth-vkontakte

[codeclimate_badge]: http://img.shields.io/codeclimate/github/mamantoha/omniauth-vkontakte.svg?style=flat
[codeclimate]: https://codeclimate.com/github/mamantoha/omniauth-vkontakte

