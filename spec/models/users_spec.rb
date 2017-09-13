require 'rails_helper'

RSpec.describe User do

  it {should have_many(:identities)}
  it {should have_many(:messages)}
end
