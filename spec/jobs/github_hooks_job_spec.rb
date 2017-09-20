require 'rails_helper'

RSpec.describe GithubHooksJob, type: :job do
  describe '#perform_later' do
    it 'queues up setting all webhooks' do
      token = '1a2b3c4d'
      ActiveJob::Base.queue_adapter = :test
      expect {
        GithubHooksJob.perform_later(token, 'set_all_web_hooks')
      }.to have_enqueued_job
    end
    
    it 'queues up deleting all webhooks' do
      token = '1a2b3c4d'
      ActiveJob::Base.queue_adapter = :test
      expect {
        GithubHooksJob.perform_later(token, 'delete_all_web_hooks')
      }.to have_enqueued_job
    end

    it 'queues up resetting all webhooks' do
      token = '1a2b3c4d'
      ActiveJob::Base.queue_adapter = :test
      expect {
        GithubHooksJob.perform_later(token, 'reset_hooks')
      }.to have_enqueued_job
    end
  end
end
