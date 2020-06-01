require 'open-uri'

class PushNotificationJob < ApplicationJob

  # Ensure  key is present in .env
  SERVER_KEY = ENV["SERVER_KEY"]

  queue_as :default

  def perform(shift)
    u = shift.user
    push("Connuct Notification", "A new shift has been allocated to you", u.push_token) if u.push_token
  end

  # This method is used to hit FCM to push the notification to the user
  def push(title, message, push_token)

  	# Format the msg
    pushMessage = "{\"data\":{\"title\":\"" + title +
      "\",\"message\":\"" + message +
      "\"},\"to\":\"" + push_token + "\"}";

    url = "https://fcm.googleapis.com/fcm/send"
    headers = {
      "Authorization" => "key=" +  SERVER_KEY,
      "Content-Type" => "application/json"
    }


    logger.info("Sending #{pushMessage} to #{url} with headers #{headers}")

    # Send it out
    RestClient.post(url, pushMessage, headers){ |response, request, result|

      logger.debug(response)

      case response.code
      when 200
        logger.info "Push notification successfull"
      else
        logger.info "Push notification failed"
      end
    }

  end

end
