class Map < ActiveRecord::Base
  named_scope :for_position_on_plate, lambda { |position,plate_size| 
    {
      :conditions => {
        :description => horizontal_plate_position_to_description(position, plate_size),
        :asset_size  => plate_size
      }
    } 
  }

  named_scope :where_description, lambda { |*descriptions| { :conditions => { :description => descriptions.flatten } } }
  named_scope :where_plate_size,  lambda { |size| { :conditions => { :asset_size => size } } }

  def self.next_map_position(current_map_id)
    map = Map.find(current_map_id)
    map_position = Map.description_to_horizontal_plate_position(map.description,map.asset_size)
    return nil if map_position +1 >  map.asset_size
    horiz_description = Map.horizontal_plate_position_to_description(map_position +1,map.asset_size)
    Map.find_by_description_and_asset_size(horiz_description,map.asset_size)
  end

  def self.next_vertical_map_position(current_map_id)
    map = Map.find(current_map_id)
    Map.next_vertical_map_position_from_description(map.description,map.asset_size)
  end
  
  def self.next_vertical_map_position_from_description(description,asset_size)
    map_position = Map.description_to_vertical_plate_position(description,asset_size)
    return nil if map_position +1 >  asset_size
    horiz_description = Map.vertical_plate_position_to_description(map_position +1,asset_size)
    Map.find_by_description_and_asset_size(horiz_description,asset_size)
  end
  

  def self.map_96wells
    Map.all(:conditions => {:asset_size => 96})
  end

  def self.map_384wells
    Map.all(:conditions => {:asset_size => 384})
  end

  def self.snp_map_id_to_pipelines_map_id(snp_map_id,plate_size)
    description = Map.horizontal_plate_position_to_description(snp_map_id,plate_size)
    map_id = Map.first(:conditions => ["description like ? AND asset_size = ? ", description, plate_size ]).id
  end

  def self.pipelines_map_id_to_snp_map_id(pipelines_map_id)
    map = Map.find(pipelines_map_id)
    description = Map.description_to_horizontal_plate_position(map.description,map.asset_size)
  end

  def self.description_to_horizontal_plate_position(well_description,plate_size)
    return nil unless valid_well_description_and_plate_size?(well_description,plate_size)
    split_well = split_well_description(well_description)
    width = self.plate_width(plate_size)
    return nil if width.nil?
    (width*split_well[:row]) + split_well[:col]
  end

  def self.description_to_vertical_plate_position(well_description,plate_size)
    return nil unless valid_well_description_and_plate_size?(well_description,plate_size)
    split_well = split_well_description(well_description)
    length = self.plate_length(plate_size)
    return nil if length.nil?
    (length*(split_well[:col]-1)) + split_well[:row]+1
  end

  def self.horizontal_plate_position_to_description(well_position,plate_size)
    return nil unless valid_plate_position_and_plate_size?(well_position,plate_size)
    width = plate_width(plate_size)
    return nil if width.nil?
    horizontal_position_to_description(well_position, width)
  end

  def self.vertical_plate_position_to_description(well_position,plate_size)
    return nil unless valid_plate_position_and_plate_size?(well_position,plate_size)
    length = plate_length(plate_size)
    return nil if length.nil?
    vertical_position_to_description(well_position, length)
  end

  def self.horizontal_to_vertical(well_position,plate_size)
    desc = self.horizontal_plate_position_to_description(well_position,plate_size)
    self.description_to_vertical_plate_position(desc,plate_size)
  end

  def self.vertical_to_horizontal(well_position,plate_size)
    desc = self.vertical_plate_position_to_description(well_position,plate_size)
    self.description_to_horizontal_plate_position(desc,plate_size)
  end

  def self.plate_width(plate_size)
    return nil unless plate_size.is_a? Integer
    if plate_size == 96
      width  = 12
    elsif plate_size == 384
      width = 24
    else
      return nil
    end
    width
  end

  def self.plate_length(plate_size)
    return nil unless plate_size.is_a? Integer
    if plate_size == 96
      length  = 8
    elsif plate_size == 384
      length = 16
    else
      return nil
    end
    length
  end

  def self.valid_plate_size?(plate_size)
    plate_size.is_a?(Integer) && plate_size >0
  end

  def self.valid_well_position?(well_position)
    well_position.is_a?(Integer) && well_position >0
  end

  def self.valid_plate_position_and_plate_size?(well_position,plate_size)
    return false unless valid_well_position?(well_position)
    return false unless valid_plate_size?(plate_size)
    return false if well_position > plate_size
    true
  end

  def self.valid_well_description_and_plate_size?(well_description,plate_size)
    return false if well_description.blank?
    return false unless valid_plate_size?(plate_size)
    true
  end

  def self.vertical_position_to_description(well_position, length)
    desc_letter = (((well_position-1)%length) + 65).chr
    desc_number = ((well_position-1)/length) +1
    (desc_letter+(desc_number.to_s))
  end

  def self.horizontal_position_to_description(well_position, width)
    desc_letter = (((well_position-1)/width) + 65).chr
    desc_number = ((well_position-1)%width) +1
    (desc_letter+(desc_number.to_s))
  end

  def self.split_well_description(well_description)
    { :row=> well_description[0] - 65, :col=> well_description[1,well_description.size].to_i}
  end

  def self.find_for_cell_location(cell_location, asset_size)
    self.find_by_description_and_asset_size(cell_location.sub(/0(\d)$/, '\1'), asset_size)
  end
  
  def self.pad_description(map)
    split_description = split_well_description(map.description)
    return "#{map.description[0].chr}0#{split_description[:col]}" if split_description[:col] < 10
      
    map.description
  end
  

  # Vertically walking the map locations goes A1, B1, C1, ... A2, B2, ...
  def self.walk_plate_vertically(size, &block)
    width, height = Map.plate_width(size), Map.plate_length(size)
    positions     = Map.all(:conditions => {:asset_size => size}, :order => 'location_id ASC')
    (0...size).map { |index| yield(positions[((index % height) * width) + (index / height)]) }
  end
end
