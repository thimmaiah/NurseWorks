Geocoder.configure(

  #geocoding service (see below for supported options):
  :lookup => :google, 
  
  :api_key => "AIzaSyAlNyttniOra7NOxX7TfmtKxKKS3G0fD1U",
  
  #geocoding service request timeout, in seconds (default 3):
  :timeout => 5,

  #set default units to kilometers:
  :units => :mi,

  #caching (see below for details):
  #:cache => Redis.new,
  #:cache_prefix => "..."

)
