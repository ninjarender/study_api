# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  title      :string
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body
  has_one :user
end
