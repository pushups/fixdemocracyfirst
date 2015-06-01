require 'mandrill'

module Emailer
  def self.email(to_email, to_name, subject, template, options = {})
    options = options.with_indifferent_access
    Mandrill::API.new(ENV['MANDRILL_API_KEY']).messages.send({
      "html" => ERB.new(IO.read("#{Rails.root}/app/views/email_templates/#{template}.html.erb"))
                          .result(OpenStruct.new(options).instance_eval { binding }),
      "subject" => subject,
      "from_email" => "questionr@nhrebellion.org",
      "from_name" => "The Questionr Team",
      "to" => [{ 'email' => to_email, 'name' => to_name }],
      "headers"=> {},
      "track_opens" => true,
      "track_clicks" => true,
      "auto_text" => true,
      "url_strip_qs" => true,
      "preserve_recipients" => true,
      "bcc_address" => "",
      "merge" => false,
      "global_merge_vars" => [],
      "merge_vars" => [],
      "tags" => [],
      "google_analytics_domains" => [ "questionr.us", "questionr.org" ],
      "google_analytics_campaign" => "",
      "metadata" => { 'env' => Rails.env, 'template' => template },
      "recipient_metadata" => [],
      "attachments" => [] }, 
    true)
  end
end

