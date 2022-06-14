require 'minitest/autorun'
require 'name_parser'

describe NameParser do

  it "parses all caps" do
    assert_operator({
      "first_name"     => "Michael",
      "last_name"      => "Jackson",
      "full_name"      => "Michael Jackson"
    }, :<, NameParser.guess("MICHAEL JACKSON"))
  end

  it "parses all caps with hypens in given names" do
    assert_operator({
      "first_name"     => "Michael-François",
      "last_name"      => "Jackson",
      "full_name"      => "Michael-François Jackson"
    }, :<, NameParser.guess("MICHAEL-FRANÇOIS JACKSON"))
  end

  it "parses some caps" do
    assert_operator({
      "first_name"     => "Michael",
      "last_name"      => "Jackson",
      "full_name"      => "Michael Jackson"
    }, :<, NameParser.guess("Michael JACKSON"))
  end

  it "parses all caps with hypens in last names" do
    assert_operator({
      "first_name"     => "Michael",
      "last_name"      => "Jackson-O'Grady",
      "full_name"      => "Michael Jackson-O'Grady"
    }, :<, NameParser.guess("MICHAEL JACKSON-O'GRADY"))
  end

  it "preserves last names with prefixes" do
    assert_operator({
      "first_name"     => "Michael",
      "last_name"      => "DeJackson",
      "full_name"      => "Michael DeJackson"
    }, :<, NameParser.guess("Michael DeJackson"))
  end

  it "parses all caps with apostrophe" do
    assert_operator({
      "first_name"     => "Michael",
      "last_name"      => "O’Jackson",
      "full_name"      => "Michael O’Jackson"
    }, :<, NameParser.guess("MICHAEL O’JACKSON"))
  end

  it "parses some caps with apostrophe" do
    assert_operator({
      "first_name"     => "Michael",
      "last_name"      => "O’Jackson",
      "full_name"      => "Michael O’Jackson"
    }, :<, NameParser.guess("Michael O’JACKSON"))
  end

  it "keeps prefix lower case" do
    assert_operator({
      "first_name"       => "Michael",
      "last_name_prefix" => "van der",
      "last_name"        => "Jackson",
      "full_name"        => "Michael van der Jackson"
    }, :<, NameParser.guess("MICHAEL VAN DER JACKSON"))
  end

end
