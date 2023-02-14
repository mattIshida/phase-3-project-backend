require_relative '../private.rb'
require 'open-uri'
require 'net/http'
require 'json'
require 'pry'
require 'date'

puts "🌱 Seeding spices..."


# Helper Method

def fetch_json url
    JSON.parse(URI.open(url, "X-API-Key"=> API_KEY).read)
end


#Seed legislators

Legislator.destroy_all

def fetch_members body, session
    url = "https://api.propublica.org/congress/v1/#{session}/#{body}/members.json"
    fetch_json(url)["results"]
        .first["members"]
        .map {|h| h.merge({"member_id" => h["id"]})
        .filter {|k,_| Legislator.column_names.reject {|c| c == 'id'}.include?(k.to_s)}}
end

def create_members body, session
    fetch_members(body, session)
        .each {|m| Legislator.find_by(first_name: m[:first_name], last_name: m[:last_name], date_of_birth: m[:date_of_birth])||Legislator.create(m)}
end

(117..118).to_a.reverse.each do |c|
    create_members('senate', c)
    create_members('house', c)
end


# Seed positions
Position.destroy_all
Bill.destroy_all
Vote.destroy_all

def find_rollcall_max body, year
    url = year == Date.today.year ? "https://api.propublica.org/congress/v1/#{body}/votes/recent.json" : "https://api.propublica.org/congress/v1/#{body}/votes/#{year}/12.json"
    fetch_json(url)["results"]["votes"].first["roll_call"]     
end

def find_votes body, year, month
    url = "https://api.propublica.org/congress/v1/#{body}/votes/#{year}/#{"%02d" % month}.json"
    fetch_json(url)["results"]["votes"]
        .filter {|h| h.has_key?("bill") && !h["bill"].empty? && h["bill"]["api_uri"]!=nil}
        .map {|h| {
            roll_call: h["roll_call"],
            chamber: h["chamber"],
            congress: h["congress"],
            date: h["date"],
            time: h["time"],
            bill_id: h["bill"]["bill_id"], 
            api_uri: h["bill"]["api_uri"]
        }}
end

def create_bill vote
    data = fetch_json(vote[:api_uri])["results"].first
    Bill.create(
        bill_id: data["bill_id"], 
        bill: data["bill"], 
        title: data["title"], 
        sponsor_id: data["sponsor_id"], 
        summary: data["summary_short"]
        )
end

def create_vote vote
    Vote.create(vote)
end

def create_positions vote_instance, body, year
    url = "https://api.propublica.org/congress/v1/#{(year-1787)/2}/#{body}/sessions/#{year%2 == 1 ? 1 : 2}/votes/#{vote_instance.roll_call}.json"
    data = fetch_json(url)["results"]["votes"]["vote"]["positions"]
    data.each {|p| Position.create(
        member_id: p["member_id"],
        vote_id: vote_instance.id,
        bill_id: vote_instance.bill_id,
        party: p["party"],
        state: p["state"],
        district: p["district"],
        vote_position: p["vote_position"] 
    )}
end

def create_month body, year, month
    votes = find_votes(body, year, month)
    votes.each do |v|
        create_bill v
        vote_instance = create_vote v
        create_positions vote_instance, body, year
    end
end

start_month = Date.today-Date.today.day+1
#end_month = Date.new(2022, 11, 1)

d = start_month
months = 3
months.times do
    create_month 'senate', d.year, d.month
    puts "Completed Senate votes for #{d.month}/#{d.year}"
    #create_month 'house', d.year, d.month
    #puts "Completed House votes for #{d.month}/#{d.year}"
    d = d << 1
end

# def fetch_vote body, year, number
#     url = "https://api.propublica.org/congress/v1/#{(year-1787)/2}/#{body}/sessions/#{year%2 == 1 ? 1 : 2}/votes/#{number}.json"
#     data = fetch_json(url)["results"]["votes"]["vote"]
#     bill_id = data["bill"] ? data["bill"]["bill_id"] : nil
#     amendment_id = data["amendment"] ? data["amendment"]["amendment_id"] : nil
#     nomination_id = data["nomination"] ? data["nomination"]["nomination_id"] : nil
#     puts data["bill"]
#     puts data['amendment']
#     puts data['nomination']
#     positions = data["positions"].map {|h| h.merge({"bill_id"=> bill_id, "amendment_id"=> amendment_id, "nomination_id"=> nomination_id}).filter{|k,_| Position.column_names.include?(k.to_s)}}
#     positions.each {|p| Position.find_or_create_by(p)}
# end

# binding.pry


puts "✅ Done seeding!"
