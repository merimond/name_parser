require 'minitest/autorun'
require 'name_parser'

describe NameParser do

  it "skips single designations" do
    assert_operator({
      "first_name" => "Michael",
      "last_name"  => "Jackson",
      "full_name"  => "Michael Jackson"
    }, :<, NameParser.guess("Michael Jackson, CFA"))
  end

  it "skips multiple designations" do
    assert_operator({
      "first_name" => "Michael",
      "last_name"  => "Jackson",
      "full_name"  => "Michael Jackson"
    }, :<, NameParser.guess("Michael Jackson, MBA, CPA, CMA"))
  end

  it "skips multiple designations with no spaces" do
    assert_operator({
      "first_name" => "Michael",
      "last_name"  => "Jackson",
      "full_name"  => "Michael Jackson"
    }, :<, NameParser.guess("Michael Jackson,MBA,CPA,CMA"))
  end

end
