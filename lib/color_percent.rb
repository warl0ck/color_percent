require 'rubygems'
require 'RMagick'
require 'color_namer'

module ColorPercentage
	class ImageColor
		attr_accessor :image
		
		
		def initialize (image)
			@image = image
		end

		def find_color
				img = Magick::ImageList.new(@image)

				img.resize_to_fit!(500)
				quantized = img.quantize(16) # reduce number of colors
				img.destroy! # save memory, save the planet!!!

				@colors_hash = {}
				quantized.color_histogram.each_pair do |pixel, frequency| # grab list of colors and frequency
		
					shade = ColorNamer.name_from_html_hash(
								    pixel.to_color(Magick::AllCompliance, false, 8, true)
								  ).last # get shade of the color
		
					# color grouping
		
					if @colors_hash[shade].nil?
						@colors_hash[shade] = frequency.to_i
					else
						@colors_hash[shade] += frequency.to_i
					end
		
				end

				quantized.destroy! # save memory, save the planet!!!

				# normalize color frequency to percentage
				sum = @colors_hash.inject(0){ |s,c| s + c.last.to_i }.to_f
				@colors_hash.keys.each do |a|
					@colors_hash[a] = @colors_hash[a].to_i / sum * 100
				end
				
				@colors_hash
		end

	end

end
