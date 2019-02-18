require_relative 'speckle_account'
class SpeckleInterop

  def speckle_settings_dir
    #TODO update to support SQLite db
    ENV['LOCALAPPDATA'] + '\SpeckleSettings\MigratedAccounts'
  end

  def read_user_accounts
    @user_accounts = []
    puts "read_user_accounts #{speckle_settings_dir}"
    Dir.foreach(speckle_settings_dir) do |fname|
      full_name = speckle_settings_dir + '\\' + fname
      puts "fname #{fname} #{File.extname(fname)} #{File.exists?(full_name)}"
      next unless File.exists?(full_name) and File.extname(fname) == '.txt'
      text = File.read(full_name).chomp!
      pieces = text.split(',')
      speckle_account = SpeckleAccount.new({email: pieces[0],
                                            apiToken: pieces[1],
                                            serverName: pieces[2],
                                            restApi: pieces[3],
                                            rootUrl: pieces[4],
                                            fileName: fname})
      @user_accounts.push(speckle_account)
    end
    @user_accounts
  end

  def user_accounts
    @user_accounts
  end

  def document_guid
    'TODO'
  end

  def document_name
    'TODO'
  end
end