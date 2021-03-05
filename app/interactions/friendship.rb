#encoding: utf-8
class Friendship < Struct.new(:user)
  def add_friend friend_subdomain
    friend = User.find_by_subdomain! friend_subdomain

    user.friends_approve << friend
    user.admin_messages.create(title: "Внимание!", text: "Запрос на подтвержение дружбы отправлен пользователю '#{friend.login}'", buttons: "ok", admin: true)

    friend.admin_messages.create(title: "Внимание!", text: "Пользователь <a href='https://#{user.site.domain}/users/#{user.subdomain}' target='_blank'>#{user.login}</a> хочет добавить вас в друзья. Вы хотите стать другом пользователя?", buttons: "approve_friend", admin: true, sender_id: user.id)
    friend.send_friend_request_notification(user, user.site)
  end

  def approve_friend message_id
    message = Message.find message_id
    friend = User.find message.sender_id

    user.friends_on_approve.delete friend

    user.friends << friend
    friend.friends << user

    message.destroy
    friend.admin_messages.create(title: "Внимание!", text: "Пользователь '#{user.login}' - добавлен в список ваших друзей", buttons: "ok", admin: true)
    friend.send_friend_approved_notification(user, user.site)
  end

  def decline_friend message_id
    message = Message.find message_id
    friend = User.find message.sender_id

    user.friends_on_approve.delete friend
    message.destroy
    friend.admin_messages.create(title: "Внимание!", text: "Пользователь '#{user.login}' - не позволил вам добавить его в список ваших друзей", buttons: "ok", admin: true)
    friend.send_friend_declined_notification(user, user.site)
  end

  def delete_friend friend
    if user.friends.include? friend
      user.friends.delete friend
      friend.friends.delete user
      "Пользователь #{friend.login} был удален из друзей."
    else
      "Пользователя #{friend.login} нету в списке Ваших друзей."
    end
  end
end