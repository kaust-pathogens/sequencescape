class Api::PlateIO < Api::Base
  renders_model(::Plate)

  map_attribute_to_json_attribute(:uuid)
  map_attribute_to_json_attribute(:id)
  map_attribute_to_json_attribute(:name)
  map_attribute_to_json_attribute(:barcode)
  map_attribute_to_json_attribute(:size)
  map_attribute_to_json_attribute(:created_at)
  map_attribute_to_json_attribute(:updated_at)

  with_association(:plate_metadata) do 
    map_attribute_to_json_attribute(:infinium_barcode)
  end
  
  with_association(:location) do 
    map_attribute_to_json_attribute(:name, 'location')
  end

  with_association(:plate_purpose, :if_nil_use => :stock_plate_purpose) do
    map_attribute_to_json_attribute(:name, 'plate_purpose_name')
    map_attribute_to_json_attribute(:id,   'plate_purpose_internal_id')
    map_attribute_to_json_attribute(:uuid, 'plate_purpose_uuid')

    def self.stock_plate_purpose
      PlatePurpose.find_by_name('Stock Plate')
    end
  end

  with_association(:barcode_prefix) do
    map_attribute_to_json_attribute(:prefix, 'barcode_prefix')
  end
end
