# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Egranary::Application.config.secret_key_base = '9929c8e80fca9a0ac91747712bd38f6b0ad23d55397d0edeca0addbc9694997078d3e270a7280055ca25deb505f2a2750a82ae97017b67bb7fd7819995017f80'


ENV['SMS_API_ID']='jiunga'
ENV['SMS_API_KEY'] = '60c057f2a1734212f30b89d27928b5f4bbaca69439b3f6e4404535146ccbf33e'