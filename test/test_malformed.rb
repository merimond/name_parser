require 'minitest/autorun'
require 'name_parser'

describe NameParser do

  it "skips orphaned dot" do
    assert_operator({
      "first_name" => "Michael",
      "last_name"  => "Jackson",
      "full_name"  => "Michael Jackson"
    }, :<, NameParser.guess("Michael . Jackson"))
  end

end
