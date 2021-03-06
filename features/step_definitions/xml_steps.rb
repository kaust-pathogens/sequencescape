def sort_arrays(xml_data)
  if xml_data.is_a?(Hash)
    xml_data.inject({}) do |hash,(key,value)|
      hash[key] = sort_arrays(value)
      hash
    end
  elsif xml_data.is_a?(Array)
    # Kind of a hack but works for the cases where Hash elements exist
    xml_data.map { |e| sort_arrays(e) }.sort { |a,b| a.to_a <=> b.to_a }
  else
    xml_data
  end
end

def assert_xml_strings_equal(str1, str2)
  expected = sort_arrays(Hash.from_xml(str1))
  received = sort_arrays(Hash.from_xml(str2))
  assert_hash_equal(expected, received, 'XML differs when decoded')
end

Then /^ignoring "([^\"]+)" the XML response should be:$/ do |key_regexp, serialized_xml|
  regexp = Regexp.new(key_regexp)
  block  = lambda { |key| key.to_s =~ regexp }
  assert_hash_equal(
    sort_arrays(walk_hash_structure(Hash.from_xml(serialized_xml), &block)),
    sort_arrays(walk_hash_structure(Hash.from_xml(page.body), &block)),
    'XML differs when decoded'
  )
end


Then /^the XML response should be:/ do |serialized_xml|
  assert_xml_strings_equal(serialized_xml, page.body)
end

Then /^the value of the "([^"]+)" attribute of the XML element "([^"]+)" should be "([^"]+)"/ do |attribute, xpath, value|
  node = page.find(:xpath, xpath.downcase)
  assert node
  assert_equal value, node[attribute.downcase]
end

Then /^the text of the XML element "([^"]+)" should be "([^"]+)"/ do |xpath, value|
  node = page.find(:xpath, xpath.downcase)
  assert node
  assert_equal value, node.text
end
# Use for complete collections of instances E.g. index pages.
When /^I request XML from (.+)$/ do |page_name|
  page.driver.get(path_to(page_name), nil, 'HTTP_ACCEPT' => 'application/xml')
end

# Use for individual instances E.g. the Study named "Something Or Other"
When /^I request XML for (.+)$/ do |page_name|
  page.driver.get(path_to(page_name), nil, 'HTTP_ACCEPT' => 'application/xml')
end

When /^I make a request for XML for a custom text identified by "([^"]*)"$/ do |identifier|
  custom_text = CustomText.find_by_identifier(identifier) or raise StandardError, "Cannot find custom text #{identifier.inspect}"
  page.driver.get("#{path_to('the custom texts admin page')}/#{custom_text.id}", nil, 'HTTP_ACCEPT' => 'application/xml')
end

When /^I (POST|PUT) the following XML to "(\/[^\"]+)":$/ do |action, path, xml|
  page.driver.send(
    action.downcase,
    "#{ path }",
    xml,
    { 'CONTENT_TYPE' => 'application/xml', 'HTTP_ACCEPT' => 'application/xml' }
  )
end

