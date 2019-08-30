require 'httparty'
require 'json'
require 'cgi'
require 'tradsim'
require 'csv'
require "chinese_phrases/version"

module ChinesePhrases

  class << self
    def run input_file
      input_index = 0
      output_file = "output_phrases.csv"
      to_trad = true

      options = {
        callback: "jQuery1111013304390430117385_1567195383336",
        page: 1,
        page_size: 100,
        max_length: 15,
        max_examples: 10
      }

      query_list = []
      total_examples = []

      CSV.foreach(input_file) do |csv|
        query_list << Tradsim::to_sim(csv[input_index])
      end

      query_list.each do |q|
        exs = get_examples q, options
        total_examples.push *exs
      end

      CSV.open(output_file, "w") do |csv|
        total_examples.each do |a|
          example = a["example"]

          if to_trad
            example = Tradsim::to_trad(example)
          end

          csv << [a["recentTrslation"], example, a["pinyin"]]
        end
      end
    end

    def get_examples query, params
      query_escaped = CGI::escape query

      url = "https://dict.naver.com/linedict/cnen/example/search.dict?callback=#{params[:callback]}&query=#{query_escaped}&page=#{params[:page]}&page_size=#{params[:page_size]}&examType=normal&fieldType=&author=&country=&ql=default&format=json&platform=isPC&_=1567195383337"

      response = HTTParty.get(url)

      cleaned_resp = response.match("#{params[:callback]}(.*)")[1][1..-2]
      data = JSON.parse cleaned_resp

      exampleList = data["exampleList"]

      # collect shortest examples
      examples = exampleList.filter { |i| i["example"].length < params[:max_length] }

      if params[:max_examples] > -1
        examples = examples[0..params[:max_examples] - 1]
      end

      examples
    end

  end
end
