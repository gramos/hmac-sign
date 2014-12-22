Amasi (Amazon Signature)
=======================

With this gem you can sign http requests to easily interact with
[Amazon web services](http://aws.amazon.com/documentation/)
using Net::HTTP and plain ruby.
The are other libraries like [aws-sdk-ruby](https://github.com/aws/aws-sdk-ruby)
that does a lot of thinks and you can do almost every action related to AWS,
but the purpose of this gem is only provide request signature
[hmac protocol](http://docs.aws.amazon.com/AmazonS3/latest/API/sigv4-auth-using-authorization-header.html)
by using authorization header way proposed by amazon.

Example PUT an S3 object:
-------------------------

```ruby

# http://docs.aws.amazon.com/AmazonS3/latest/API/RESTObjectPUT.html

require 'net/http'

request      = Net::HTTP::Put.new "/my_image.jpg"
request.body = File.open( './my_image.jpg' )
http         = Net::HTTP.new "#{bucket_name}.s3.amazonaws.com/"

Amasi.new( request ).sign!
response = http.request request
```

Example: GET and s3 object.
---------------------------

```ruby

# http://docs.aws.amazon.com/AmazonS3/latest/API/RESTObjectGET.html

require 'net/http'
require 'uri'

request      = Net::HTTP::Get.new "/my_image.jpg"
http         = Net::HTTP.new "#{bucket_name}.s3.amazonaws.com/"

Amasi.new( request ).sign!
response = http.request request
```
