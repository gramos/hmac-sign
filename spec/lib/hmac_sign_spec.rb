require 'minitest/autorun'
require File.expand_path 'lib/signature'

describe Signature do

  before do
    @host        = 'http://localhost'
    @account_id  = '1b8ffe44-acf7-454a-b78b-d55c18151ee4'
    @path        = "/smrt/0.01/#{@account_id}/Projects"
    @params      = {'KeyId' => 'test'}
    @request     = Net::HTTP::Get.new "#{@host}/#{@path}"
    @secret_key  = '9ca4e1cd-6820-4150-b6b0-1619c0204055'
    @pre_generated_sign = "/500YuMDv5FO4OOKos43GUKFCuRsx0D0oekqDM06MO4="
    @signature = Signature.new @host, @secret_key
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
    uri = "http://localhost/smrt/0.01/#{@account_id}/Projects?KeyId=test&Signature=#{@pre_generated_sign}"
    @signature.gen_uri!(@method, @path, @params).must_equal uri
    # puts @signature.gen_uri!(@method, @path, @params)
  end

  it "gen! should fill @uri" do
    @signature.gen!(@method, @path, @params)
    @signature.uri.must_be_kind_of URI
  end

  it "gen_from_url! should return the signed uri" do
    uri = "http://localhost/smrt/0.01/#{@account_id}/Projects?KeyId=test"
    Signature.gen_from_uri!(uri, 'GET', @secret_key).must_equal "#{uri}&Signature=#{@pre_generated_sign}"
  end
end
