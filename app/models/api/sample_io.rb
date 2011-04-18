class Api::SampleIO < Api::Base
  renders_model(::Sample)

  map_attribute_to_json_attribute(:uuid)
  map_attribute_to_json_attribute(:id)
  map_attribute_to_json_attribute(:name)
  map_attribute_to_json_attribute(:new_name_format)
  map_attribute_to_json_attribute(:created_at)
  map_attribute_to_json_attribute(:updated_at)
  map_attribute_to_json_attribute(:sanger_sample_id)
  map_attribute_to_json_attribute(:control)
  map_attribute_to_json_attribute(:sample_manifest_id)
  map_attribute_to_json_attribute(:empty_supplier_sample_name)
  map_attribute_to_json_attribute(:updated_by_manifest)

  with_association(:sample_metadata) do
    map_attribute_to_json_attribute(:organism)
    map_attribute_to_json_attribute(:cohort)
    map_attribute_to_json_attribute(:country_of_origin)
    map_attribute_to_json_attribute(:geographical_region)
    map_attribute_to_json_attribute(:ethnicity)
    map_attribute_to_json_attribute(:volume)
    map_attribute_to_json_attribute(:supplier_plate_id)
    map_attribute_to_json_attribute(:mother)
    map_attribute_to_json_attribute(:father)
    map_attribute_to_json_attribute(:replicate)
    map_attribute_to_json_attribute(:gc_content)
    map_attribute_to_json_attribute(:gender)
    map_attribute_to_json_attribute(:dna_source)
    map_attribute_to_json_attribute(:sample_public_name)
    map_attribute_to_json_attribute(:sample_common_name)
    map_attribute_to_json_attribute(:sample_strain_att)
    map_attribute_to_json_attribute(:sample_taxon_id)
    map_attribute_to_json_attribute(:sample_ebi_accession_number)
    map_attribute_to_json_attribute(:sample_description)
    map_attribute_to_json_attribute(:sample_sra_hold)
    with_association(:reference_genome, :lookup_by => :name) do
      map_attribute_to_json_attribute(:name, 'reference_genome')
    end
    map_attribute_to_json_attribute(:supplier_name)
  end

  self.related_resources = [ :sample_tubes ]

  extra_json_attributes do |object, json_attributes|
    if json_attributes['reference_genome'].blank?
      metadata = object.try(:studies).try(:first).try(:study_metadata)
      json_attributes["reference_genome"] = metadata.reference_genome.name unless metadata.nil?
    end
  end

  # Whenever we create samples through the API we also need to register a sample tube too.  The user
  # can then retrieve the sample tube information through the API.
  def self.create!(parameters)
    super.tap { |sample| SampleTube.create!(:sample => sample) }
  end
end
