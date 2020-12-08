class Tag < ActsAsTaggableOn::Tag
	validates :name, presence: true
	validates :kind, presence: true
end
