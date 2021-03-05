# encoding: utf-8
require 'grocer'

class Mobile::ApplePushNotification
  def initialize
    apns_config_path = Rails.root.join('config', 'mobile', 'APNS.yml')
    @apns_converted_yml_config = ERB.new(File.read(apns_config_path)).result
  end

  def send
    Site.all.each do |site|
      docs = site.docs.ready_for_push_notifications_from
      devices = site.mobile_devices

      docs.each do |doc|
        devices.each do |device|
          call_pusher(site).push(notification(device, doc))
        end
      end
    end
  end

  private

  def call_pusher(current_site)
    yml_config = YAML.load(@apns_converted_yml_config)[Rails.env][current_site.domain]
    Grocer.pusher(yml_config)
  end

  def notification(device, doc)
    Grocer::Notification.new device_token: device.token, badge: 1,
                             alert: doc.title,
                             custom: {doc_id: doc.id,
                                      rubric_id: doc.doc_rubric_id }
  end
end
