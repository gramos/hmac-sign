require 'base64'
require 'net/http'

class HmacSign

  def initialize(host, secret_key)
    @host       = host
    @secret_key = secret_key
  end

  def self.digest
    OpenSSL::Digest::Digest.new('sha256')
  end

  def to_param(params)
    params.collect do |key, value|
      "#{key}=#{value}"
    end.sort * '&'
  end

  def gen!(method, path, params)
    @params = params if params.kind_of? String
    @params ||= to_param params
    @path = path

    string = "#{method}\n#{@host}\n#{path}\n#{@params}"

    raise "secret_key is nil!!!, I can't make the signature" if @secret_key.nil?

    hmac_digest = OpenSSL::HMAC.digest(HmacSign.digest, @secret_key, string)
    @signature = Base64.encode64(hmac_digest).strip
  end

  def uri
    URI("#{@host}#{@path}?#{@params}&Signature=#{@signature}")
  end

  def gen_hash!(method, path, params)
    { 'Signature' => gen!(method, path, params) }
  end

  def gen_uri!(method, path, params)
    gen!(method, path, params)
    uri.to_s
  end

  def self.gen_from_uri!(uri, method, secret_key)
    uri = URI(uri)
    s = HmacSign.new "#{uri.scheme}://#{uri.host}", secret_key
    query = uri.query || ""
    s.gen_uri! method, uri.path, query
  end
end
