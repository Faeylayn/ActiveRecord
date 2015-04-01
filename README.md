#ActiveRecordLite

An implementation of the ActiveRecord Object-Relational Mapping written in Ruby.

##Features
-Implements Associations and Classes that relate to database tables
-Creates SQL objects for Querying with where clauses



##Technical Details
-Uses Ruby’s flexible structure to recreate ActiveRecord’s associations and queries.
-Creates a lazy where clause that only calls a single query when the set is acted upon.
-Extensive testing in Rspec.
