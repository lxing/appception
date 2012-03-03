class ApplicationController < ActionController::Base
  protect_from_forgery

  # HTTP response codes
  STATUS = {
    :OK           => 200,
    :CREATE       => 201,
    :UNAUTHORIZED => 401,
    :NOT_FOUND    => 404,
    :INVALID      => 422,
    :UNAVAILABLE  => 503,
    :TIMEOUT      => 504
  }
end
