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
> If you prefer to use Docker, you can skip to the [Using Docker](#using-docker) section.

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
It uses `foreman` to run the application.
To run the application, you can use the following command:
```bash
bin/dev
```

## Running the tests
To run the tests, you can use the following command:
```bash
bundle exec rspec
```

## Using Docker
You can use Docker to run the application. Make sure you have Docker and Docker Compose installed and run the following command:
```bash
docker-compose up
```

Once the application is running, you can access it at `http://localhost:3000`

## Data Model
The application has the following data model:

- **Product**: Represents a product available. Each product can have one associated promotion.

- **Promotion**: Defines special offers or discounts applicable to certain products. Each product can have one associated promotion.

- **Cart**: Represents a shopping cart that holds products for a user. Each cart can have multiple products added to it.

- **CartProduct**: Join model representing the association between carts and products. Each cart product belongs to one cart and one product.
