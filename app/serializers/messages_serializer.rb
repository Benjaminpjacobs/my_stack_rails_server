class MessagesSerializer < ActiveModel::Serializer
  attributes :repo, :from, :link, :event_type, :id

  def repo
    eval(object.message["repository"])["name"]
  end

  def from
    eval(object.message["sender"])["login"]
  end

  def link
    eval(object.message["pull_request"])["html_url"]
  end

  def event_type
    object.event_type.split('_').map{|word| word.capitalize}.join(' ')
  end
end
