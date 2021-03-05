# encoding : utf-8
# test commit to exclude file from CC
class Ability
  include CanCan::Ability

  def initialize user, site_id
    alias_action :read, :create, :edit, :update, :destroy, to: :rest_manage
    alias_action :rest_manage, :rich_edit, to: :rest_rich_manage

    site = Site.find site_id
    rights_for_unauthorized user, site

    if user
      rights_for_authorized user, site

      if user.is_admin?
        can :manage, :all
      else
        can [:read, :create, :update], Site do |site|
          site.site_admins.where(:user_id => user.id, :role => :admin).exists?
        end

        user.site_admins.site(site).each do |site_admin|
          default_site_admins_rights user, site

          case site_admin.role
          when 'admin'
            rights_for_site_admins user, site_admin, site
            when 'editor'
            rights_for_site_editors user, site_admin, site
          when 'moderator'
            rights_for_site_moderators user, site_admin, site
          when 'observer'
            rights_for_site_observers user, site_admin, site
          end
        end
        can :rest_manage, [Catalog, Vacancy, Resume], { :user_id => user.id }
        can :rest_manage, [Doc, Gallery, Event], { :user_id => user.id, :approved => false }
        can :del_friend, User, { :id => user.friend_ids }
      end
    end
  end

  private
  def rights_for_site_admins user, site_admin, site
    if site.id.to_i == site_admin.site.id.to_i
      can :manage, Site, { :id => site.id }
      can :manage, ActsAsTaggableOn::Tag, { :site_id => site_admin.site.id }
      can :create, :all

      can :manage, :all
      can :manage, :all do |obj|
        obj.respond_to?(:site_id) &&
          user.multi_editor? &&
          obj.site.id.in?(Site.active.not_partner.pluck(:id))
      end

      can :view, :fast_admin_panel
    end

    cannot :become, User
    can :manage, AdCode
  end

  def rights_for_site_editors user, site_admin, site
    site_admin.permissions.each do |permission|
      can :manage, permission.controller.to_sym
    end

    can :toggle_ban, User

    can :manage, Doc, { :doc_rubric_id => site_admin.permitted_rubrics(DocRubric) }
    can :manage, Doc if site_admin.has_permission? :docs

    can :manage, Event, { :event_rubric_id => site_admin.permitted_rubrics(EventRubric) }
    can :manage, Event if site_admin.has_permission? :afisha

    can :manage, Gallery, { :photo_rubric_id => site_admin.permitted_rubrics(PhotoRubric) }
    can :manage, Gallery if site_admin.has_permission? :photo

    can :manage, Catalog if site_admin.has_permission? :catalog

    can :manage, ExternalDoc, { :external_doc_rubric_id => site_admin.permitted_rubrics(ExternalDocRubric) }

    if site_admin.has_permission? :job
      can :manage, [Resume, Vacancy]
    end

    if site_admin.has_permission? :dictionary_objects
      can :manage, [Dictionary, DictionaryRubric, DictionaryObject], :site_id => site_admin.site.id
    end

    if site_admin.has_permission? :external_docs
      can :manage, [ExternalDoc, ExternalDocRubric], site_id: site_admin.site.id
    end
  end

  def rights_for_site_moderators user, site_admin, site
    can :rest_rich_manage, Doc, { :doc_rubric_id => site_admin.permitted_rubrics(DocRubric), :user_id => user.id, :approved => false }
    can :rest_rich_manage, Event, { :event_rubric_id => site_admin.permitted_rubrics(EventRubric), :user_id => user.id, :approved => false }
    can :rest_rich_manage, Gallery, { :photo_rubric_id => site_admin.permitted_rubrics(PhotoRubric), :user_id => user.id, :approved => false }

    can :rest_rich_manage, Catalog, { :user_id => user.id } if site_admin.has_permission? :catalog
    can :rest_rich_manage, Doc, { :user_id => user.id } if site_admin.has_permission? :docs
    can :rest_rich_manage, Event, { :user_id => user.id } if site_admin.has_permission? :afisha

    if site_admin.has_permission? :dictionary_objects
      can :rest_manage, [Dictionary, DictionaryRubric], :site_id => site_admin.site.id, :user_id => user.id
    end
  end

  def rights_for_site_observers user, site_admin, site
    can :view_ip, :all do |obj|
      obj.respond_to?(:site_id) &&
        obj.site.id == site_admin.site.id
    end
  end

  def rights_for_unauthorized user, site
    can :read, [DictionaryObject, Catalog, Event, Doc, Vacancy, Resume, Gallery, ExternalDoc, Post], :approved => true
    can [:read, :popular], Question
    can [:read, :news, :docs, :afisha, :catalog, :photo, :dictionary], :'ActsAsTaggableOn::Tag'
  end

  def rights_for_authorized user, site
    can :friends, User, :id => user.id
    can [:add_friend_approve, :friend_approved, :friend_not_approved], User
    can :new_message, User
    cannot [:new, :create, :edit, :update, :destroy], :all unless user.confirm?

    can :read, Post
    can :create, Post do |post|
      post.community.open || user.communities.include?(post.community)
    end
    can [:update, :destroy], Post do |post|
      user == post.user
    end

    can :my, Question
    can :read, Question
    can :create, Question
    can [:update, :destroy], Question do |question|
      user == question.user
    end

    can :create, Comment
    can :update, Comment do |comment|
      user == comment.user && comment.created_at > 1.day.ago
    end

    can :update, Community do |community|
      user == community.user
    end

    can :create, Rating
  end

  def default_site_admins_rights user, site
    can :autocomplete, :'ActsAsTaggableOn::Tag'
    can :autocomplete, Catalog
    can :read, :admin_board if user.can_access_admin_panel?(site)
  end
end
