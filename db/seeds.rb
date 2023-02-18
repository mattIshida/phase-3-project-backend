require_relative '../private.rb'
require 'open-uri'
require 'net/http'
require 'json'
require 'pry'
require 'date'

puts "🌱 Seeding spices..."

# Clear out existing data

Legislator.destroy_all
Position.destroy_all
Bill.destroy_all
Vote.destroy_all
User.destroy_all
Comment.destroy_all
Follow.destroy_all
Reaction.destroy_all


# Helper Method

def fetch_json url
    JSON.parse(URI.open(url, "X-API-Key"=> API_KEY).read)
end



# Seed legislators

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
    puts "Seeding Senate members for Congress ##{c}"
    create_members('senate', c)    
    #puts "Seeding House members"
    #create_members('house', c)
end


# Seed positions

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

def create_subjects vote, bill
    url = vote[:api_uri].gsub(/\.json/, "/subjects.json")
    data = fetch_json(url)["results"].first["subjects"]
    data.each do |s|
        subject = Subject.find_or_create_by(name: s["name"])
        Tag.find_or_create_by(subject_id: subject.id, bill_id: bill.id)
    end
end

def create_bill vote
    data = fetch_json(vote[:api_uri])["results"].first
    bill = Bill.create(
        bill_id: data["bill_id"], 
        bill: data["bill"], 
        title: data["title"], 
        sponsor_id: data["sponsor_id"], 
        summary: data["summary_short"]
        )
    create_subjects vote, bill
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
        create_bill v unless Bill.exists?(bill_id: v[:bill_id])
        vote_instance = create_vote v
        create_positions vote_instance, body, year
    end
end

start_month = Date.today-Date.today.day+1

d = start_month
months = 6
months.times do
    create_month 'senate', d.year, d.month
    puts "Completed Senate votes for #{d.month}/#{d.year}"
    #create_month 'house', d.year, d.month
    #puts "Completed House votes for #{d.month}/#{d.year}"
    d = d << 1
end

# Seed users, etc.

puts "Seeding users, comments, likes, follows"

10.times do 
    User.create(name: Faker::Name.name)
end

User.all.each do |u|
    [Legislator, Bill, Vote, Position].each do |m|
        m.all.sample(rand(1..10)).each do |c|
            Comment.create(commentable: c, user: u, content: Faker::Lorem.sentence(word_count: 3, supplemental: false, random_words_to_add: 4))
        end
        m.all.sample(rand(1..10)).each do |c|
            Follow.create(followable: c, user: u)
        end
        m.all.sample(rand(1..10)).each do |c|
            Reaction.create(reactable: c, user: u, value: rand(-100..100))
        end
    end 
end


puts "✅ Done seeding!"


#https://api.propublica.org/congress/v1/116/bills/hr502.json
#"https://api.propublica.org/congress/v1/115/bills/hr2810/subjects.json"


#curl "https://api.propublica.org/congress/v1/115/bills/hr2810/subjects.json" -H "X-API-Key: gQi3Nzlbf7VJ87cAIFQiBrTija6T3t7yVZGFKahW"