require "test_helper"

class AssetsControllerTest < ActionController::TestCase
  setup do
    @controller = AssetsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  should_require_login

  context "#create a new asset with JSON input" do
    setup do
      @user = Factory :user
      @user.is_administrator
      @controller.stubs(:current_user).returns(@user)
      @barcode  = Factory.next :barcode

      @json_data = json_new_asset(@barcode)
      post :create, ActiveSupport::JSON.decode(@json_data).merge({'Content-Type' => 'application/json', 'Accept' => 'application/json'})
    end

    should_set_the_flash_to  /Asset was successfully created/
    should_change("Asset.count", :by => 1) { Asset.count }
  end

  context "create request with JSON input" do
    setup do
      @sample = Factory :sample
      @asset = Factory :asset, :name => "Asset", :sample => @sample, :requests => []

      @user = Factory :user
      @user.is_administrator
      @controller.stubs(:current_user).returns(@user)

      @study = Factory :study
      @project = Factory :project, :enforce_quotas => true
      @request_type = Factory :request_type
      @workflow = Factory :submission_workflow
      @quota = Factory :project_quota, :project_id => @project.id, :request_type_id => @request_type.id, :limit => 10
      @json_data = valid_json_create_request(@asset,@request_type,@study, @project)

      post :create_request, ActiveSupport::JSON.decode(@json_data).merge({'Content-Type' => 'application/json', 'Accept' => 'application/json'})
    end

    should_change("Submission.count", :by => 1) { Submission.count }
  end

  def valid_json_create_request(asset,request_type,study, project)
    '{
    "api_version": '+"#{RELEASE.api_version}"+',
    "api_key": "abc",
    "study_id": '+"#{study.id}"+',
    "project_id": '+"#{project.id}"+',
    "request_type_id": '+"#{request_type.id}"+',
    "count": 3,
    "comments": "This is a request",
    "id": '+"#{asset.id}"+',
    "request":
    {
      "properties": {
        "library_type": "Standard",
        "fragment_size_required_from": 100,
        "fragment_size_required_to": 500,
        "read_length": 108
        }
      }
    }'
  end

  def json_new_asset(barcode)
    #/assets
    '{
    "api_version": '+"#{RELEASE.api_version}"+',
    "api_key": "abc",
    "asset":{
        "barcode": "'+"#{barcode}"+'",
        "label": "SampleTube"
      }
    }'
  end

end
