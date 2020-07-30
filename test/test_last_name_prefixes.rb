require 'minitest/autorun'
require 'name_parser'

describe NameParser do

  it "parses `van der` prefix" do
    assert_operator({
      "first_name"       => "Michael",
      "last_name_prefix" => "van der",
      "last_name"        => "Jackson",
      "full_name"        => "Michael van der Jackson"
    }, :<, NameParser.guess("Michael van der Jackson"))
  end

  it "parses `Van Der` prefix" do
    assert_operator({
      "first_name"       => "Michael",
      "last_name_prefix" => "Van Der",
      "last_name"        => "Jackson",
      "full_name"        => "Michael Van Der Jackson"
    }, :<, NameParser.guess("Michael Van Der Jackson"))
  end

  it "parses `de la` prefix" do
    assert_operator({
      "first_name"       => "Michael",
      "last_name_prefix" => "de la",
      "last_name"        => "Jackson",
      "full_name"        => "Michael de la Jackson"
    }, :<, NameParser.guess("Michael de la Jackson"))
  end

  it "parses `de` prefix" do
    assert_operator({
      "first_name"       => "Michael",
      "last_name_prefix" => "de",
      "last_name"        => "Jackson",
      "full_name"        => "Michael de Jackson"
    }, :<, NameParser.guess("Michael de Jackson"))
  end

  it "parses `von` prefix" do
    assert_operator({
      "first_name"       => "Michael",
      "last_name_prefix" => "von",
      "last_name"        => "Jackson",
      "full_name"        => "Michael von Jackson"
    }, :<, NameParser.guess("Michael von Jackson"))
  end

end
