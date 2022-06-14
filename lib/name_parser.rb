require 'name_parser/female_names'
require 'name_parser/male_names'
require 'name_parser/diminutive_names'

module NameParser
  LETTER = /[[:alpha:]]/
  NAME = /[[[:alpha:]]’'-]{2,}/

  GENERATIONAL_SUFFIX = /
    jr|JR|
    Jr\.?|JR\.?|
    Sr\.?|SR\.?|
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
    le|
    st\.|
  /xi

  LAST_NAME = /
    ((?<last_name_prefix>#{LAST_NAME_PREFIX})\s)?
    (?<last_name>#{NAME})
  /x

  REDUNDANT_DESIGNATIONS = /
    ACCA|
    ARNP|
    B\.ENG\.|
    B\.COMM\.|
    B\.?SC\.?|
    CA|
    CAIA|
    CIC|
    CIPM|
    CFA|
    CFP|
    CMA|
    CMT|
    CPA|
    C\.P\.A\.|
    CTA|
    CTP|
    CPESC|
    DVM|
    Esq\.|
    F\.A\.C\.S\.|
    FACR|
    FPAC|
    FRM|
    ICD\.D|
    JD|
    J\.D\.|
    LHRM|
    MA|
    MBCHB|
    MD|
    MD\.|
    M\.D\.|
    MBA|
    M\.B\.A|
    M\.B\.A\.|
    MHSA|
    MIPP|
    MPACC\.?|
    MPH|
    M\.P\.H|
    MS|
    MSC|
    MSEE|
    MST|
    OBE|
    PE|
    PHARM\.?D\.|
    PhD|
    PHD|
    PH\.\s?D\.|
    Ph\.D\.|
    SPHR
  /x

  REDUNDANT_SALUTATIONS = /
    Admiral|
    LT\.\sGENERAL|
    PROFESSOR|
    PROF\.|
    SIR
  /x

  DOCTOR_SALUTATION = /
    Dr|DR|
    Dr\.|DR\.|
    Doctor|DOCTOR
  /x

  MALE_HONORIFIC = /
    Mr|MR|
    Mr\.|MR\.
  /x

  FEMALE_HONORIFIC = /
    Ms|MS|
    Ms\.|MS\.|
    Mrs|MRS|
    Mrs\.|MRS\.
  /x

  TRANSFORATIONS = []
  FORMATS = []

  # Michael Jackson, CFA
  TRANSFORATIONS << /
    ^
    (?<repeat>.+)
    [\s,]+
    #{REDUNDANT_DESIGNATIONS}
    $
  /x

  # Admiral Michael Jackson
  TRANSFORATIONS << /
    ^
    #{REDUNDANT_SALUTATIONS}
    [\s,]+
    (?<repeat>.+)
    $
  /x

  # Jackson CFA, Michael
  FORMATS << [/
    ^
    (?<first>.+)
    #{REDUNDANT_DESIGNATIONS},+
    (?<second>.+)
    $/x, -> (params) {
      { "repeat" => [params["first"], params["second"]].join(",") }
  }]

  # Michael (Mike) Jackson
  FORMATS << [/
    ^
    (?<first>#{NAME})
    \s?[\("]\s?
    (?<alternative>#{NAME})
    \s?[\)"]\s?
    (?<rest>.+)
    $/x, -> (params) {
      guess_alternative_token({
      "alternative" => params["alternative"],
      "repeat"      => [params["first"], params["rest"]].join(" ")
    })
  }]

  # Mike (Michael) Jackson
  FORMATS << [/
    ^
    (?<alternative>#{NAME})
    \s?[\("]\s?
    (?<first>#{NAME})
    \s?[\)"]\s?
    (?<rest>.+)
    $/x, -> (params) {
    guess_alternative_token({
      "alternative" => params["alternative"],
      "repeat"      => [params["first"], params["rest"]].join(" ")
    })
  }]

  # Mr. Michael Jackson
  FORMATS << [/
    ^
    #{MALE_HONORIFIC}
    \s
    (?<repeat>.+)
    $
  /x, -> (params) {
    params.merge("gender" => "m")
  }]

  # Ms. Michael Jackson
  FORMATS << [/
    ^
    #{FEMALE_HONORIFIC}
    \s
    (?<repeat>.+)
    $
  /x, -> (params) {
    params.merge("gender" => "f")
  }]

  # Dr. Michael Jackson
  FORMATS << [/
    ^
    #{DOCTOR_SALUTATION}
    \s
    (?<repeat>.+)
    $
  /x, -> (params) {
    params.merge("salutation" => "Dr.")
  }]

  # Michael Jackson, Dr.
  FORMATS << [/
    ^
    (?<repeat>.+)
    [\s,]+
    #{DOCTOR_SALUTATION}
    $
  /x, -> (params) {
    params.merge("salutation" => "Dr.")
  }]

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
    params.merge({
      "preferred_name" => params["middle_names"],
      "hide_preferred" => true
    })
  }]

  # Jackson, J. Michael
  FORMATS << [/
    ^
    #{LAST_NAME},\s?
    (?<first_name>#{LETTER}\.?)\s
    (?<middle_names>#{NAME})
    $
  /x, -> (params) {
    params.merge({
      "preferred_name" => params["middle_names"],
      "hide_preferred" => true
    })
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

  def self.capitalize_given_name(name)
    unless name.is_a?(String)
      return name
    end

    unless name == name.upcase || name == name.downcase
      return name
    end

    if name.size < 3
      return name # TODO: account for genuine short names, e.g. Ed or Bo
    end

    name.gsub(/(^|-)([[:alpha:]])([[:alpha:]]+)/) do
      "#{$1}#{$2.upcase}#{$3.downcase}"
    end
  end

  def self.capitalize_prefix(name)
    unless name.is_a?(String)
      return name
    end

    unless name == name.upcase
      return name
    end

    name.downcase
  end

  def self.capitalize_last_name(name)
    unless name.is_a?(String)
      return name
    end

    unless name == name.upcase || name == name.downcase
      return name
    end

    name.gsub(/(^|-)([[:alpha:]][’'])?([[:alpha:]])([[:alpha:]]+)/) do
      "#{$1}#{$2}#{$3.upcase}#{$4.downcase}"
    end
  end

  def self.preprocess(name)
    unless name.is_a?(String)
      return nil
    end

    name = name
      .strip
      .gsub(/\s+/, " ")    # Squash multiple spaces
      .gsub(/\s+,/, ",")   # Remove space before comma
      .gsub(/\s\.\s/, " ") # Remove orphaned dot
      .gsub(/,$/, "")      # Remove trailing comma
      .gsub(/[®]/, "")     # Remove BS characters

    TRANSFORATIONS.each do |fmt|
      next unless match = name.match(fmt)
      return preprocess(match["repeat"])
    end

    name
  end

  def self.postprocess(params)
    gender = params["gender"] ||
      guess_gender(params["first_name"]) ||
      guess_gender(params["preferred_name"])

    params["first_name"] = capitalize_given_name params["first_name"]
    params["preferred_name"] = capitalize_given_name params["preferred_name"]
    params["middle_names"] = capitalize_given_name params["middle_names"]
    params["last_name_prefix"]= capitalize_prefix params["last_name_prefix"]
    params["last_name"] = capitalize_last_name params["last_name"]
  
    # When middle name is used as the preferred name, we don't want to show it
    # separately in paranthesis, since it's already displayed as middle.
    # e.g. M. Joseph Jackson
    preferred = params["hide_preferred"] ? nil : params["preferred_name"]

    full_name = [
      params["salutation"],
      params["first_name"],
      preferred ? "(#{preferred})" : nil,
      params["middle_names"],
      params["last_name_prefix"],
      params["last_name"],
      params["gen_suffix"]
    ].compact.join(" ")

    params.delete("repeat")
    params.delete("hide_preferred")
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
      next if tokens.nil?

      repeat = tokens["repeat"]
      tokens = params.merge(tokens)

      unless repeat
        return postprocess(tokens)
      end

      result = guess(repeat, tokens)
      return result unless result.nil?
    end

    nil
  end

  def self.guess_alternative_token(params)
    unless token = params.delete("alternative")
      return params
    end

    if DIMINUTIVE_NAMES.include?(token.downcase)
      return params.merge({ "preferred_name" => token.capitalize })
    end

    if token.match(/[A-Z]{2}/)
      return params.merge({ "preferred_name" => token })
    end

    # Here're some cases that require further investigation.
    # They will currently fail to parse:
    #
    # [1] Names from non-Engligh natives:
    #   - Zhaoxuan("Charles") Yang
    #   - Doris (Yiyang) Guo
    # [2] Simplified names:
    #   - Greg (Grygorii) Yefremov
    # [3] Alternative last names for ladies
    #   - Celestine (Johnson) Schnugg
    # [4] Simple alternative names:
    #   - Yuliya (Julia) Gudish
    #   - Jack (John) Chimento
    nil
  end

end
