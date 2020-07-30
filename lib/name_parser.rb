require 'name_parser/female_names'
require 'name_parser/male_names'

module NameParser
  LETTER = /[[:alpha:]]/
  NAME = /[[[:alpha:]]’'-]{2,}/

  GENERATIONAL_SUFFIX = /
    Jr|
    Jr\.|
    Sr|
    Sr\.|
    [IV]{1,3}
  /x

  LAST_NAME_PREFIX = /
    van\sder|
    van\sden|
    von\sder|
    von\sdem|
    van\sde|
    de\sla|
    van|
    von|
    dos|
    del|
    den|
    da|
    de|
    di|
    du|
    la|
    le
  /xi

  LAST_NAME = /
    (?<last_name_prefix>#{LAST_NAME_PREFIX})?\s?
    (?<last_name>#{NAME})
  /x

  DESIGNATION = /
    CFA|
    CMA|
    CPA|
    CPESC|
    DVM|
    Esq\.|
    FACR|
    MD|
    M\.D\.|
    MBA|
    M\.B\.A|
    MHSA|
    OBE|
    PE|
    PhD|
    Ph\.D\.|
    SPHR
  /x

  TRANSFORATIONS = []
  FORMATS = []

  # Michael Jackson, CFA
  TRANSFORATIONS << /
    ^
    (?<repeat>.+)
    [\s,]+
    #{DESIGNATION}
    $
  /x

  # Michael Jackson
  FORMATS << [/
    ^
    (?<first_name>#{NAME})\s
    #{LAST_NAME}
    $
  /x]

  # Michael J. Jackson
  FORMATS << [/
    ^
    (?<first_name>#{NAME})\s
    (?<middle_names>#{LETTER}\.?)\s
    #{LAST_NAME}
    $
  /x]

  # Jackson, Michael
  FORMATS << [/
    ^
    #{LAST_NAME},\s?
    (?<first_name>#{NAME})
    $
  /x]

  # Jackson, Michael J.
  FORMATS << [/
    ^
    #{LAST_NAME},\s
    (?<first_name>#{NAME})\s
    (?<middle_names>#{LETTER}\.?)
    $
  /x]

  # Michael Jackson Jr.
  FORMATS << [/
    ^
    (?<repeat>.+)(,|\s)\s?
    (?<gen_suffix>#{GENERATIONAL_SUFFIX})
    $
  /x]

  # J. Michael Jackson
  FORMATS << [/
    ^
    (?<first_name>#{LETTER}\.?)\s
    (?<middle_names>#{NAME})\s
    #{LAST_NAME}
    $
  /x, -> (params) {
    params.merge("preferred_name" => params["middle_names"])
  }]

  # Jackson, J. Michael
  FORMATS << [/
    ^
    #{LAST_NAME},\s?
    (?<first_name>#{LETTER}\.?)\s
    (?<middle_names>#{NAME})
    $
  /x, -> (params) {
    params.merge("preferred_name" => params["middle_names"])
  }]

  # Michael Joseph Jackson
  FORMATS << [/
    ^
    (?<first_name>#{NAME})\s
    (?<middle_names>#{NAME})\s
    #{LAST_NAME}
    $
  /x]

  # Michael Joseph Jackson
  FORMATS << [/
    ^
    #{LAST_NAME},\s?
    (?<first_name>#{NAME})\s
    (?<middle_names>#{NAME})
    $
  /x]

  def self.guess_gender(name)
    unless name.is_a?(String)
      return nil
    end

    sanitized = name.to_s.strip.downcase

    if MALE_NAMES.include?(sanitized)
      return "m"
    end

    if FEMALE_NAMES.include?(sanitized)
      return "f"
    end

    nil
  end

  def self.preprocess(name)
    unless name.is_a?(String)
      return nil
    end

    name = name
      .strip
      .gsub(/\s+/, " ")
      .gsub(/\s+,/, ",")
      .gsub(/,$/, "")

    TRANSFORATIONS.each do |fmt|
      next unless match = name.match(fmt)
      return preprocess(match["repeat"])
    end

    name
  end

  def self.postprocess(params)
    gender = nil ||
      guess_gender(params["first_name"]) ||
      guess_gender(params["preferred_first_name"])

    full_name = [
      params["first_name"],
      params["middle_names"],
      params["last_name_prefix"],
      params["last_name"],
      params["gen_suffix"]
    ].compact.join(" ")

    params.delete("repeat")
    params.merge({
      "full_name" => full_name,
      "gender"    => gender
    })
  end

  def self.guess(name, params = {})
    unless params.is_a?(Hash)
      return nil
    end

    unless name = preprocess(name)
      return nil
    end

    FORMATS.each do |fmt, block|
      unless match = name.match(fmt)
        next
      end

      tokens = match.named_captures
      tokens = block.call(tokens) if block.is_a?(Proc)

      repeat = tokens["repeat"]
      tokens = params.merge(tokens)

      return repeat ?
        guess(repeat, tokens) :
        postprocess(tokens)
    end

    nil
  end

end
