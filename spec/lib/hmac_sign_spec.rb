require 'minitest/autorun'
require File.expand_path 'lib/hmac_sign'

describe HmacSign do

  before do
    @host        = 'mydomain.com'
    @account_id  = '12345'
    @path        = "/#{@account_id}/Projects"
    @params      = {'KeyId' => 'test'}
    @request     = Net::HTTP::Get.new "#{@host}/#{@path}"
    @secret_key  = 'abcd'
    @pre_generated_sign = "OoihvaZkEgfPoJ/jHVIhvFFeCM4fe7iOx7/KOh4EfE4="
    @uri_escaped_sign   = CGI.escape @pre_generated_sign
    @signature = HmacSign.new @host, @secret_key
    @method    = 'GET'
    @uri = "http://mydomain.com/#{@account_id}/Projects?KeyId=test"
    @signed_uri = "#{@uri}&Signature=#{@uri_escaped_sign}"
  end

  it "should return an string with resulting signature" do
    @signature.gen!(@method, @path, @params).must_be_instance_of String
  end

  it "should make the signature for a request using http " +
     "verb, host, uri and params" do
    @signature.gen!(@method, @path, @params).must_equal @pre_generated_sign
  end

  it "should return a hash like 'Signature' => @signature" do
    @hash = { 'Signature' => @pre_generated_sign }
    @signature.gen_hash!(@method, @path, @params).must_equal @hash
  end

  it "gen_uri! should return the uri string" do
    @signature.gen_uri!(@method, @path, @params).must_equal @signed_uri
  end

  it "gen! should fill @uri" do
    @signature.gen!(@method, @path, @params)
    @signature.uri.must_be_kind_of URI
  end

  describe "gen_from_uri!" do

    before do
      @args  = { :url => @uri,
        :method => 'GET',
        :secret_key => @secret_key}
    end

    it "should return the signed uri" do
      HmacSign.gen_from_uri!(@args.merge(:gen_url => true)).
        must_equal @signed_uri
    end

    it "should return the the signature" do
      HmacSign.gen_from_uri!(@args).must_equal @pre_generated_sign
    end

    it "should take params as argument for POST PUT methods
        On POST PUT request the params comes into the body of the request
        so we need to add another way to take the params besides the query
        string" do

      uri = "http://mydomain.com/#{@account_id}/Projects"
      @args.merge!(:KeyId => 'test', :secret_key => @secret_key,
                   :method => 'POST', :url => uri,
                   :params => {:name => 'Bruce', :surname => 'Lee'})

      pre_generated_sign = 'QgvP6mjgvZHkIHOK/Aby9YaCw8s92dfomPAtcm76Yyc='
      HmacSign.gen_from_uri!(@args).must_equal pre_generated_sign
    end
  end
end
