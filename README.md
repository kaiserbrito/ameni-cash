# AmeniCash

Part of Techincal Challenge for Amenitiz

It's a Cash register application that allows you to add products, remove products, and calculate the total price of the products added.

### Assumptions

**Products Registered**
| Product Code | Name | Price |  
|--|--|--|
| GR1 |  Green Tea | 3.11€ |
| SR1 |  Strawberries | 5.00 € |
| CF1 |  Coffee | 11.23 € |

**Special conditions**

- The CEO is a big fan of buy-one-get-one-free offers and green tea.
He wants us to add a  rule to do this.

- The COO, though, likes low prices and wants people buying strawberries to get a price  discount for bulk purchases.
If you buy 3 or more strawberries, the price should drop to 4.50€.

- The VP of Engineering is a coffee addict.
If you buy 3 or more coffees, the price of all coffees should drop to 2/3 of the original price.

Our check-out can scan items in any order, and because the CEO and COO change their minds  often, it needs to be flexible regarding our pricing rules.

## Pre-requisites (running locally)
- Ruby 3.3.0
- Postgres > 9.0

### Dependencies instalation
It's a Rails application, so you need to install the dependencies using the following command:
```bash
bundle install
```

### Database
Make sure the correct database configuration is set in `config/database.yml` and run the following command:
```bash
bundle exec rails db:create db:migrate db:seed
```

## Running the application
To run the application, you can use the following command:
```bash
bundle exec rails s
```

## Running the tests
To run the tests, you can use the following command:
```bash
bundle exec rspec
```
