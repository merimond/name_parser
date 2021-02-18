require 'minitest/autorun'
require 'name_parser'

describe NameParser do

  it "associates `Mr` with male gender" do
    assert_operator({
      "first_name" => "Alex",
      "last_name"  => "Jackson",
      "gender"     => "m",
      "full_name"  => "Alex Jackson"
    }, :<, NameParser.guess("Mr. Alex Jackson"))
  end

  it "associates `Mrs` with female gender" do
    assert_operator({
      "first_name" => "Alex",
      "last_name"  => "Jackson",
      "gender"     => "f",
      "full_name"  => "Alex Jackson"
    }, :<, NameParser.guess("Mrs. Alex Jackson"))
  end

  it "associates `Ms` with female gender" do
    assert_operator({
      "first_name" => "Alex",
      "last_name"  => "Jackson",
      "gender"     => "f",
      "full_name"  => "Alex Jackson"
    }, :<, NameParser.guess("Ms. Alex Jackson"))
  end

end
