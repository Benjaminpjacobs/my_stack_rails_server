require 'rails_helper'

RSpec.describe User do
  it {should validate_presence_of(:email) }
  it {should validate_uniqueness_of(:email)}
  it {should validate_presence_of(:token)}
  it {should validate_presence_of(:uid)}
  it {should validate_presence_of(:username)}
end
