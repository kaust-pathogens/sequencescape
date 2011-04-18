class Api::BatchRequestIO < Api::Base
  renders_model(::BatchRequest)

  map_attribute_to_json_attribute(:uuid)
  map_attribute_to_json_attribute(:id, 'internal_id')
  map_attribute_to_json_attribute(:created_at)
  map_attribute_to_json_attribute(:updated_at)

  with_association(:batch) do
    map_attribute_to_json_attribute(:uuid, 'batch_uuid')
    map_attribute_to_json_attribute(:id,   'batch_internal_id')
  end

  with_association(:request) do
    map_attribute_to_json_attribute(:uuid, 'request_uuid')
    map_attribute_to_json_attribute(:id,   'request_internal_id')

    with_association(:request_type) do
      map_attribute_to_json_attribute(:name, 'request_type')
    end

    with_association(:asset) do
      map_attribute_to_json_attribute(:uuid, 'source_asset_uuid')
      map_attribute_to_json_attribute(:id,   'source_asset_internal_id')
      map_attribute_to_json_attribute(:name, 'source_asset_name')
    end

    with_association(:target_asset) do
      map_attribute_to_json_attribute(:uuid, 'target_asset_uuid')
      map_attribute_to_json_attribute(:id,   'target_asset_internal_id')
      map_attribute_to_json_attribute(:name, 'target_asset_name')
    end
  end
end
