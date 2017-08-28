require 'rails_helper'

RSpec.describe "Github Service" do
  before(:each) do
    @service = GithubService.new('b738cee1dd40e951493105ea08cd927333628899')
  end

  it "should get repos" do
    VCR.use_cassette("github_service/get_repos") do
      # service = GithubService.new('b738cee1dd40e951493105ea08cd927333628899')
      response = @service.get_repos
      repos = JSON.parse(response.body, symbolize_names: true)
      repo = repos.first
      owner = repos.first[:owner]
      
      expect(repos.count).to eq(82)
      expect(repo).to have_key(:id)
      expect(repo[:id]).to be_an Integer
      expect(repo).to have_key(:name)
      expect(repo[:name]).to be_a String
      expect(repo).to have_key(:full_name)
      expect(repo[:full_name]).to be_a String
      expect(repo).to have_key(:owner)
      expect(repo[:owner]).to be_a Hash
      expect(owner).to have_key(:id)
      expect(owner[:id]).to be_an Integer
      expect(owner).to have_key(:login)
      expect(owner[:login]).to be_an String
      expect(owner).to have_key(:url)
      expect(owner[:url]).to be_an String
    end
  end

  it "should list repo names" do
    VCR.use_cassette("github_service/get_repos") do
      # service = GithubService.new('b738cee1dd40e951493105ea08cd927333628899')
      repo_list = @service.repo_list
      expect(repo_list).to be_an Array
      expect(repo_list.length).to eq(82)
      expect(repo_list.first).to eq("Benjaminpjacobs/four_principle_examples")
      expect(repo_list.last).to eq("Benjaminpjacobs/benjamin-p-jacobs.github.io")
    end
  end

  it "should set a web hook" do
    VCR.use_cassette("github_service/set_webhook") do
      response = @service.set_web_hook("Benjaminpjacobs/four_principle_examples")
      parsed = JSON.parse(response.body, symbolize_names: true)
      expect(response.status).to eq(201)
      expect(parsed[:type]).to eq('Repository')
      expect(parsed[:id]).to be_an Integer
      expect(parsed[:active]).to be true
      expect(parsed[:events]).to eq(['push', 'pull_request'])
      expect(parsed[:config][:url]).to eq("https://c51ae9a0.ngrok.io/hooks/github")
    end
  end


  it "should get list of hooks" do
    VCR.use_cassette("github_service/list_hooks") do
      response = @service.hook_list
      expect(response).to be_a Hash
      expect(response.keys[0]).to eq('Benjaminpjacobs/four_principle_examples')
      expect(response['Benjaminpjacobs/four_principle_examples']).to be_an Array

      hook = response['Benjaminpjacobs/four_principle_examples'].first

      expect(hook['id']).to be_an Integer
      expect(hook['active']).to be true
    end
  end

  it "should delete a hook" do
    VCR.use_cassette("github_service/delete_webhook") do
      response = @service.delete_web_hook('Benjaminpjacobs/four_principle_examples', 15794216)
      expect(response.status).to eq(204)
    end
  end

end