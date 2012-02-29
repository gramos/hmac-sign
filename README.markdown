Authentication
==============

You must supply the "KeyId" parameter for all requests. There is a
signing mechanism in place that works exactly like the Amazon AWS
signing mechanism (you can actually copy their client code libraries if
you want).

http://docs.amazonwebservices.com/AmazonDevPay/latest/DevPayDeveloperGuide/LSAPI_Auth_REST.html
http://chrisroos.co.uk/blog/2009-01-31-implementing-version-2-of-the-amazon-aws-http-request-signature-in-ruby
https://forums.aws.amazon.com/thread.jspa?threadID=17138
http://www.justinball.com/2009/09/02/amazon-ruby-and-signing_authenticating-your-requests/

A sample transaction:
--------------------

`GET /smrt/:api_version/:account_id/:resource?KeyId=:key_id&Signature=:signature`

*Example:*

`GET /smrt/0.01/df5e707d-9555-4f38-a1e0-cb754169e49d/Projects?KeyId=c69a2fc7-d5ac-4461-b2a4-8ccdde2160b4&Signature=Eqb1Za%2B8hb5QdVnNIanxKfH6yOvlFxRgUc2sgwHsikE%3D`



