require 'test/unit'
require_relative 'ruby_test_objects'
require_relative '../../speckle_ruby_core/extra/speckle_api_client'
require_relative '../../speckle_ruby_core/extra/speckle_interop'
require "pstore"

class TestApiClient < Test::Unit::TestCase
  def setup
    @test_objects = RubyTestObjects.new
    @interop = SpeckleInterop.new
    @interop.read_user_accounts
    @account = @interop.user_accounts[0]
    puts "---------------------------------------------"
    puts "Testing using account: #{@account.serverName}"
    @client = SpeckleApiClient.new(@account.rootUrl)
    @client.initialize_sender(@account.apiToken, '', '', '')
    @store = PStore.new("TestApiClient_test_data")
  end

  def test_object
    @test_objects.polyline
  end

  def test_send_object
    res = @client.object_create([test_object])
    # resData = JSON.parse(res.body)
    assert(res.code == "200", res.message)
    @store.transaction do
      test_id = JSON.parse(res.body)['resources'][0]['_id']
      assert(!test_id.nil?, "ID exists")
      @store[:test_id] = test_id
    end
  end

  def test_get_object
    test_id = @store.transaction {@store[:test_id]}
    assert(!test_id.nil?, "Test ID exists")
    res = @client.object_get(test_id)

    assert(res.code == "200", res.message)

    object = JSON.parse(res.body)
    assert(object['success'], 'Success test')
    assert(objects_equal(test_object, object['resource'], ['_id', 'owner', 'hash', 'geometryHash']), 'Object equality test')
  end

  def objects_equal(match, check, ignore) # test object equality - not worrying about string vs hash keys
    unless match.is_a?(Hash) && check.is_a?(Hash)
      return false
    end
    match.each do |k, v|
      next if ignore.include?(k.to_s)
      unless check[k.to_s] == v
        unless objects_equal(v, check[k.to_s], ignore)
          puts "Test failed on property '#{k}': #{check[k.to_s]} vs #{v}"
          return false
        end
      end
    end
    true
  end
end