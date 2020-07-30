require 'minitest/autorun'
require 'name_parser'

describe NameParser do

  it "parses Jr generational suffix" do
    assert_operator({
      "first_name" => "Michael",
      "last_name"  => "Jackson",
      "gen_suffix" => "Jr",
      "full_name"  => "Michael Jackson Jr"
    }, :<, NameParser.guess("Michael Jackson Jr"))
  end

  it "parses generational suffix after a space and comma" do
    assert_operator({
      "first_name" => "Michael",
      "last_name"  => "Jackson",
      "gen_suffix" => "Jr",
      "full_name"  => "Michael Jackson Jr"
    }, :<, NameParser.guess("Michael Jackson, Jr"))
  end

  it "parses generational suffix after a comma with no space" do
    assert_operator({
      "first_name" => "Michael",
      "last_name"  => "Jackson",
      "gen_suffix" => "Jr",
      "full_name"  => "Michael Jackson Jr"
    }, :<, NameParser.guess("Michael Jackson,Jr"))
  end

  it "parses Jr generational suffix in phone-book format" do
    assert_operator({
      "first_name" => "Michael",
      "last_name"  => "Jackson",
      "gen_suffix" => "Jr",
      "full_name"  => "Michael Jackson Jr"
    }, :<, NameParser.guess("Jackson, Michael Jr"))
  end

  it "parses latin generational suffix" do
    assert_operator({
      "first_name" => "Michael",
      "last_name"  => "Jackson",
      "gen_suffix" => "III",
      "full_name"  => "Michael Jackson III"
    }, :<, NameParser.guess("Michael Jackson III"))
  end

end
