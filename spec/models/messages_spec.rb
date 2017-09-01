require 'rails_helper'

RSpec.describe Message do
  it {should belong_to(:user)}
end
