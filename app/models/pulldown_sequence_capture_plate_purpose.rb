class PulldownSequenceCapturePlatePurpose < PlatePurpose
  def child_plate_purposes
    [PlatePurpose.find_by_name("Pulldown PCR")]
  end
end
