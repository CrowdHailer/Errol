# Errol

**Repository build on top of [sequel](http://sequel.jeremyevans.net/) to store simple data records.** Errol encourages a separation of concerns in the domain model of a system where data is persisted. It uses these extra components to include a default solution for paginating its records.

They key components are the *Repository* that is responsible for storing and retrieving *Records* in response to various *Inquiries*. Records are not the same as the bloated god objects of active record but should remain simple data stores. The responsibility of a record is representing a database row with domain friendly types, this means serialising data. Where the behaviour that is no longer represented on your model now belongs is dependant on the system. It is often worth having an object that wraps the data record to define extra behaviour as well as methods to save. Errol ships with an entity that can be used as a starting point for these objects.  

```rb
# Without Errol::Entity
class Customer
  def initialize(record)
    @record = record
  end

  attr_reader :record

  def name
    "#{first_name} #{last_name}"
  end

  def first_name
    record.first_name
  end

  def last_name
    record.last_name
  end

  def save
    Customers.save record
  end
end
# With Errol::Entity
class Customer < Errorl::Entity
  repository = Customers
  entity_accessor :first_name, :last_name

  def first_name
    "#{first_name} #{last_name}"
  end
end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'errol'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install errol

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[my-github-username]/errol/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
