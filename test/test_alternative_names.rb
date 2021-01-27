require 'minitest/autorun'
require 'name_parser'

describe NameParser do

  it "parsed alternative name in paranthesis" do
    assert_operator({
      "first_name"     => "Michael",
      "preferred_name" => "Mike",
      "last_name"      => "Jackson",
      "full_name"      => "Michael (Mike) Jackson"
    }, :<, NameParser.guess("Michael (Mike) Jackson"))
  end

  it "parsed reverse alternative name" do
    assert_operator({
      "first_name"     => "Michael",
      "preferred_name" => "Mike",
      "last_name"      => "Jackson",
      "full_name"      => "Michael (Mike) Jackson"
    }, :<, NameParser.guess("Mike (Michael) Jackson"))
  end

  it "parsed alternative name with no spaces" do
    assert_operator({
      "first_name"     => "Michael",
      "preferred_name" => "Mike",
      "last_name"      => "Jackson",
      "full_name"      => "Michael (Mike) Jackson"
    }, :<, NameParser.guess("Michael(Mike)Jackson"))
  end

  it "parsed alternative name with extra spaces" do
    assert_operator({
      "first_name"     => "Michael",
      "preferred_name" => "Mike",
      "last_name"      => "Jackson",
      "full_name"      => "Michael (Mike) Jackson"
    }, :<, NameParser.guess("Michael ( Mike ) Jackson"))
  end

  it "parsed alternative name in quotes" do
    assert_operator({
      "first_name"     => "Michael",
      "preferred_name" => "Mike",
      "last_name"      => "Jackson",
      "full_name"      => "Michael (Mike) Jackson"
    }, :<, NameParser.guess("Michael \"Mike\" Jackson"))
  end

  it "parsed alternative name composed of two caps" do
    assert_operator({
      "first_name"     => "Michael",
      "preferred_name" => "MJ",
      "last_name"      => "Jackson",
      "full_name"      => "Michael (MJ) Jackson"
    }, :<, NameParser.guess("Michael (MJ) Jackson"))
  end

  it "parsed alternative name combined with middle initial" do
    assert_operator({
      "first_name"     => "Michael",
      "preferred_name" => "MJ",
      "middle_names"   => "J.",
      "last_name"      => "Jackson",
      "full_name"      => "Michael (MJ) J. Jackson"
    }, :<, NameParser.guess("Michael \"MJ\" J. Jackson"))
  end

  it "parsed alternative name combined with middle name" do
    assert_operator({
      "first_name"     => "Michael",
      "preferred_name" => "MJ",
      "middle_names"   => "Joseph",
      "last_name"      => "Jackson",
      "full_name"      => "Michael (MJ) Joseph Jackson"
    }, :<, NameParser.guess("Michael \"MJ\" Joseph Jackson"))
  end

  it "parsed alternative name combined with middle and generational suffix" do
    assert_operator({
      "first_name"     => "Michael",
      "preferred_name" => "MJ",
      "middle_names"   => "Joseph",
      "last_name"      => "Jackson",
      "gen_suffix"     => "II",
      "full_name"      => "Michael (MJ) Joseph Jackson II"
    }, :<, NameParser.guess("Michael \"MJ\" Joseph Jackson II"))
  end

end
