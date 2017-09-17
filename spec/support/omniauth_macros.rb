module OmniauthMacros
  def mock_auth_hash_github
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:github] = OpenStruct.new({
      'provider' => 'github',
      'uid' => '12345',
      'info' => OpenStruct.new({
        'email' => 'mockemail@example.com',
        'image' => 'mock_user_thumbnail_url'
      }),
      'extra' => OpenStruct.new({
        'raw_info' => OpenStruct.new({
          'name' => 'mockname'
          })
      }),
      'credentials' => OpenStruct.new({
        'token' => 'mock_token',
        'secret' => 'mock_secret'
      })
    })
  end
  def mock_auth_hash_google
      
      OmniAuth.config.mock_auth[:google_oauth2] = OpenStruct.new({
        'provider' => 'google',
        'uid' => '12345',
        'info' => OpenStruct.new({
          'email' => 'mockemail@example.com',
          'image' => 'mock_user_thumbnail_url'
          }),
          'extra' => OpenStruct.new({
            'raw_info' => OpenStruct.new({
              'name' => 'mockname'
            })
            }),
            'credentials' => OpenStruct.new({
              'token' => 'mock_token',
              'refresh_token' => 'refresh_token'
            })
          })
          
    end
    def mock_auth_hash_slack
          
          OmniAuth.config.mock_auth[:slack] = OpenStruct.new({
            'provider' => 'slack',
            'uid' => '12345',
            'info' => OpenStruct.new({
              'email' => 'mockemail@example.com',
              'image' => 'mock_user_thumbnail_url'
              }),
              'extra' => OpenStruct.new({
                'raw_info' => OpenStruct.new({
                  'name' => 'mockname'
                })
                }),
                'credentials' => OpenStruct.new({
                  'token' => 'mock_token',
                  'refresh_token' => 'refresh_token'
                })
          })
          
    end
end