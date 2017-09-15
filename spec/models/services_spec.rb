require 'rails_helper'

RSpec.describe Service do
  it {should validate_presence_of(:name) }
  it {should validate_uniqueness_of(:name)}
  it {should have_many(:messages)}
  
end
