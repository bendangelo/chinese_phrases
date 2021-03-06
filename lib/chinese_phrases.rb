require 'httparty'
require 'json'
require 'cgi'
require 'tradsim'
require 'csv'
require "chinese_phrases/version"

module ChinesePhrases

  class << self
    def run input_file, options = {}
      input_index = 0
      output_file = options[:output_file] || "output_phrases.csv"
      to_trad = options[:trad]

      params = {
        page: options[:page] || 1, # page to check on source
        page_size: options[:page_size] || 50, # number of examples from api call
        max_length: options[:max_len] || 15, # only accept examples length than this
        max_per: options[:max_per] || 10, # only accept this number of examples
      }

      puts "Running with params #{params}"

      query_list = []
      total_examples = []

      # read input file to create list of words to query
      CSV.foreach(input_file) do |csv|
        query_list << Tradsim::to_sim(csv[input_index])
      end

      if query_list.empty?
        puts "CSV file is empty!"
      elsif query_list.count > 1000
        puts "[WARNING] CSV file has over 1000 lines, this can take a long time and/or fail! Consider splitting the file."
      end

      # query each word individually and combine to total list
      query_list.each do |q|
        exs = get_examples q, params
        total_examples.push *exs
      end

      # output each example to file
      CSV.open(output_file, "w") do |csv|
        total_examples.each do |a|
          example = a["example"]

          if to_trad
            example = Tradsim::to_trad(example)
          end

          pinyin = a["pinyin"]

          puts "Writing #{a["recentTrslation"]} #{example} #{pinyin}"

          csv << [a["recentTrslation"], example, pinyin]
        end
      end

      puts "Wrote #{output_file}"
    end

    def get_examples query, params
      query_escaped = CGI::escape query
      callback = "jQuery1111013304390430117385_1567195383336"

      puts "Fetching examples for #{query}"

      url = "https://dict.naver.com/linedict/cnen/example/search.dict?callback=#{callback}&query=#{query_escaped}&page=#{params[:page]}&page_size=#{params[:page_size]}&examType=normal&fieldType=&author=&country=&ql=default&format=json&platform=isPC&_=1567195383337"

      response = HTTParty.get(url)

      if !response.success?
        puts "Error from server #{response.code}"
        puts "Server response:"
        puts response.parse_response
        return []
      end

      callback_removed = response.match("#{callback}(.*)")

      if callback_removed == nil
        puts "Callback not found, json error from server. Outputting response."
        puts response
        return []
      end

      cleaned_resp = callback_removed[1][1..-2]

      data = JSON.parse cleaned_resp

      exampleList = data["exampleList"]

      puts "Found #{exampleList.count} examples"

      # collect shortest examples
      examples = exampleList.filter { |i| i["example"].length < params[:max_length] }

      if params[:max_per] > -1
        examples = examples[0..params[:max_per] - 1]
      end

      puts "Filtered down to #{examples.count} examples"

      examples
    end

  end
end
