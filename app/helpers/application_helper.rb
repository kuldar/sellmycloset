module ApplicationHelper
	# def render_icon(icon)
 #    render file: Rails.root.join('app/assets/images', icon) if Rails.application.assets.find_asset icon
 #  end

	def options_for_tags
		ActsAsTaggableOn::Tag.all
	end
	
end
