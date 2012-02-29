require 'minitest/autorun'
require File.expand_path 'lib/hmac_sign'

describe HmacSign do

  before do
    @host        = 'http://mydomain.com'
    @account_id  = '12345'
    @path        = "/#{@account_id}/Projects"
    @params      = {'KeyId' => 'test'}
    @request     = Net::HTTP::Get.new "#{@host}/#{@path}"
    @secret_key  = 'abcd'
    @pre_generated_sign = "KLjzM3z0m42jAmQHZrTAzTAS0iUEWqlUXvrCsvfdE28="
    @signature = HmacSign.new @host, @secret_key
    @method    = 'GET'
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
    uri = "http://mydomain.com/#{@account_id}/Projects?KeyId=test&Signature=#{@pre_generated_sign}"
    @signature.gen_uri!(@method, @path, @params).must_equal uri
  end

  it "gen! should fill @uri" do
    @signature.gen!(@method, @path, @params)
    @signature.uri.must_be_kind_of URI
  end

  it "gen_from_url! should return the signed uri" do
    uri = "http://mydomain.com/#{@account_id}/Projects?KeyId=test"
    HmacSign.gen_from_uri!(uri, 'GET', @secret_key).must_equal "#{uri}&Signature=#{@pre_generated_sign}"
  end
end
