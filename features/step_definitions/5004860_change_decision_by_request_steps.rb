Given /^sequencescape is setup for 5004860$/ do
  sample   = Factory :asset
  library1 = Factory :asset, :qc_state => 'pending'
  library1.parents << sample
  lane = Factory :lane, :qc_state => 'pending'
  request_one = Factory :request, :asset => library1, :target_asset => lane
  
  reference = BillingEvent.build_reference(request_one)
  Factory :billing_event, :reference => reference,  :quantity => 7, :kind => "charge"  
     
end
