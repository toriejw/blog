# ActiveRecord's 'joins' method in Rails

The `joins` method in ActiveRecord is one that I find especially confusing to use, so I'm going to go over exactly what it does.

We use `joins` when we want to load data that requires us to go through a join table to get. For example, say we have a Store table and a Product table. Both tables have a name column and an id column. Stores have many products, and products are sold in many stores, so we have a many-to-many relationship. We create a join table called ProductStores.

We want to find all stores that sell green tea. In order to do this, we need to go through our join table ProductStores. We could load a list of the stores from the database, and then ask each store if they have green tea, but that would be a lot of database queries. Instead, we can use the `joins` method.

Since we want a list of stores and not a list of products, we're going to start with the Store table. We call `joins` on the Store table, but we must also give at a table to join with, so we write:

`Store.joins(:products)`

This produces the raw sequel:

`SELECT "stores".* FROM "stores" INNER JOIN "products" ON "products"."store_id"="stores".id`

This tells us that `joins` is performing an inner join between Stores and Products. But what's an inner join? [Noel Herrick](http://www.noelherrick.com/blog/inner-vs-outer-joins) explains this brilliantly, and I'll outline what he says here.

Herrick defines a join as: "when you combine two tables to make a new one". An inner join is when you create a new table from two tables (in our case Store and Product), that only contains rows that have both a store and a product. If a store isn't associated with any products, it won't be returned, and if a product isn't associated with any stores, it won't be returned either.

Knowing the alternative always helps me to understand a concept, so I'll briefly go over outer joins as well (you can give `joins` raw SQL if you'd like to do an outer join instead of an inner join, but I won't talk about that here).

There are two types of outer joins: left outer join and right outer join. A left outer join goes through the list of stores, and returns all of them in the resulting join table, regardless of whether or not a store is associated with any products, but it does not return any products that are not associated with a store. A right outer join does the opposite - it goes through the list of products and returns all products, regardless of their associations, but no stores unless they are associated with a product.

In other words, a left outer join matches the left table to the right table, and a right outer join matches the right table to the left table.

So we call `Store.joins(:products)` and we get a list of all stores that are associated with products. By doing this, we loaded the Store table only, and not the Product table, since we don't actually need any information from the Product table. This is called "lazy loading", because ActiveRecord didn't return anything more than we explicitly asked for.

Since we want only stores that carry green tea, we can now append `where` to our query:

`Store.joins(:products).where(products: {name: "green tea"})`

This will return to us a list of stores that have green tea. `joins` allowed us to only make one database query to do this, and only load into memory the Store table.  

Additional reading: [Rails APIdock](http://apidock.com/rails/ActiveRecord/QueryMethods/joins), [Noel Herrick: Inner vs. Outer Joins](http://www.noelherrick.com/blog/inner-vs-outer-joins), [Tom Dallimore: Includes vs Joins in Rails: When and where?](http://tomdallimore.com/blog/includes-vs-joins-in-rails-when-and-where/), [BIGBinary: Preload, Eagerload, Includes and Joins](http://blog.bigbinary.com/2013/07/01/preload-vs-eager-load-vs-joins-vs-includes.html)
