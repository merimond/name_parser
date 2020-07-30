require 'minitest/autorun'
require 'name_parser'

describe NameParser do

  it "parses reverse 2-token format" do
    assert_operator({
      "first_name" => "Michael",
      "last_name"  => "Jackson",
      "full_name"  => "Michael Jackson"
    }, :<, NameParser.guess("Jackson, Michael"))
  end

  it "parses reverse 3-token format" do
    assert_operator({
      "first_name"   => "Michael",
      "last_name"    => "Jackson",
      "middle_names" => "Joseph",
      "full_name"    => "Michael Joseph Jackson"
    }, :<, NameParser.guess("Jackson, Michael Joseph"))
  end

  it "parses name with extra spaces" do
    assert_operator({
      "first_name" => "Michael",
      "last_name"  => "Jackson",
      "full_name"  => "Michael Jackson"
    }, :<, NameParser.guess("   Jackson   ,   Michael   "))
  end

  it "parses middle initial in reverse format" do
    assert_operator({
      "first_name"   => "Michael",
      "middle_names" => "J.",
      "last_name"    => "Jackson",
      "full_name"    => "Michael J. Jackson"
    }, :<, NameParser.guess("Jackson, Michael J."))
  end

  it "parses first name initial in reverse format" do
    assert_operator({
      "first_name"     => "J.",
      "preferred_name" => "Michael",
      "last_name"      => "Jackson",
      "full_name"      => "J. Michael Jackson"
    }, :<, NameParser.guess("Jackson, J. Michael"))
  end

end
