require 'minitest/autorun'
require 'name_parser'

describe NameParser do

  it "preserves Dr. designation used at the end" do
    assert_operator({
      "first_name" => "Michael",
      "last_name"  => "Jackson",
      "full_name"  => "Dr. Michael Jackson"
    }, :<, NameParser.guess("Michael Jackson, Dr."))
  end

  it "preserves Dr. designation at the start" do
    assert_operator({
      "first_name" => "Michael",
      "last_name"  => "Jackson",
      "full_name"  => "Dr. Michael Jackson"
    }, :<, NameParser.guess("Dr. Michael Jackson"))
  end

  it "recognizes Dr. with all caps" do
    assert_operator({
      "first_name" => "MICHAEL",
      "last_name"  => "JACKSON",
      "full_name"  => "Dr. MICHAEL JACKSON"
    }, :<, NameParser.guess("DR. MICHAEL JACKSON"))
  end

  it "skips single designations at the end" do
    assert_operator({
      "first_name" => "Michael",
      "last_name"  => "Jackson",
      "full_name"  => "Michael Jackson"
    }, :<, NameParser.guess("Michael Jackson, CFA"))
  end

  it "skips single designations in the middle" do
    assert_operator({
      "first_name" => "Michael",
      "last_name"  => "Jackson",
      "full_name"  => "Michael Jackson"
    }, :<, NameParser.guess("Jackson CFA, Michael"))
  end

  it "skips multiple designations in the middle" do
    assert_operator({
      "first_name" => "Michael",
      "last_name"  => "Jackson",
      "full_name"  => "Michael Jackson"
    }, :<, NameParser.guess("Jackson CFA, CPA, Michael"))
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
