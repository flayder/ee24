FROM ruby:1.9.3

# update apt cache and install general dependencies
RUN apt-get update && apt-get install git curl build-essential libssl-dev libreadline-dev zlib1g-dev sqlite3 libsqlite3-dev -y
# install imagemagick dependencies
RUN apt-get install imagemagick libmagickcore-dev libmagickwand-dev -y
RUN ln -s /usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/bin-Q16/Magick-config /usr/bin/Magick-config
# install dependencies for capybara-webkit
RUN apt-get install g++ qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x -y

# set working directory to project src
WORKDIR /420on
COPY Gemfile Gemfile.lock .rbenv-version ./
COPY vendor/omniauth-vkontakte ./vendor/omniauth-vkontakte/

# install bundler
RUN gem install bundler -v 1.12.2

# install rails app dependencies
RUN bundle install

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
