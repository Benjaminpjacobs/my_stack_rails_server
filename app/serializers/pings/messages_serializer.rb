class Pings::MessagesSerializer < ActiveModel::Serializer
  attributes :repo, :from, :link

  def repo
    eval(object.message["repository"])["name"]
  end

  def from
    eval(object.message["pusher"])["name"]
  end

  def link
    object.message["compare"]
  end
end
