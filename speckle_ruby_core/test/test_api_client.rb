require 'test/unit'
require_relative 'ruby_test_objects'
require_relative '../../speckle_ruby_core/extra/speckle_api_client'
require_relative '../../speckle_ruby_core/extra/speckle_interop'

class TestApiClient < Test::Unit::TestCase
  def setup
    @test_objects = RubyTestObjects.new
    @interop = SpeckleInterop.new
    @interop.read_user_accounts
    @account = @interop.user_accounts[0]
    @client = SpeckleApiClient.new(@account.rootUrl)
    @client.initialize_sender(@account.apiToken, '', '', '')

  end

  # def teardown
  # end

  def test_send_object
    test_object = @test_objects.polyline
    res = @client.object_create([test_object])
    assert(res.code == "200", res.message)
  end

  def test_get_object
    res = @client.object_get(@test_objects.test_id)
    assert(res.code == "200", res.message)
  end
end