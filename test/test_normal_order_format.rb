require 'minitest/autorun'
require 'name_parser'

describe NameParser do

  it "parses 2-token format" do
    assert_operator({
      "first_name" => "Michael",
      "last_name"  => "Jackson",
      "full_name"  => "Michael Jackson",
    }, :<, NameParser.guess("Michael Jackson"))
  end

  it "parses 3-token format" do
    assert_operator({
      "first_name"   => "Michael",
      "middle_names" => "Joseph",
      "last_name"    => "Jackson",
      "full_name"    => "Michael Joseph Jackson",
    }, :<, NameParser.guess("Michael Joseph Jackson"))
  end

  it "parses name extra spaces" do
    assert_operator({
      "first_name" => "Michael",
      "last_name"  => "Jackson",
      "full_name"  => "Michael Jackson",
    }, :<, NameParser.guess("   Michael     Jackson    "))
  end

  it "parses name with apostrophe" do
    assert_operator({
      "first_name" => "Michael",
      "last_name"  => "O’Jackson",
      "full_name"  => "Michael O’Jackson",
    }, :<, NameParser.guess("Michael O’Jackson"))
  end

  it "parses name with hypens" do
    assert_operator({
      "first_name" => "Michael-François",
      "last_name"  => "Jackson",
      "full_name"  => "Michael-François Jackson",
    }, :<, NameParser.guess("Michael-François Jackson"))
  end

  it "parses middle initial" do
    assert_operator({
      "first_name"   => "Michael",
      "middle_names" => "J.",
      "last_name"    => "Jackson",
      "full_name"    => "Michael J. Jackson"
    }, :<, NameParser.guess("Michael J. Jackson"))
  end

  it "parses middle initial with no dot" do
    assert_operator({
      "first_name"   => "Michael",
      "middle_names" => "J",
      "last_name"    => "Jackson",
      "full_name"    => "Michael J Jackson"
    }, :<, NameParser.guess("Michael J Jackson"))
  end

  it "parses first name initial" do
    assert_operator({
      "first_name"     => "J.",
      "preferred_name" => "Michael",
      "middle_names"   => "Michael",
      "last_name"      => "Jackson",
      "full_name"      => "J. Michael Jackson"
    }, :<, NameParser.guess("J. Michael Jackson"))
  end

end
