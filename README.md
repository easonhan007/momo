Momo
=================

Another mock server framework using sinatra and ruby


### Usage:

* git clone

* bundle

* modify config.json

* ruby mock_server.rb

* access localhost:4567/foo and have fun

### API

Request
=======

### URI

Define routes in config.json like this:

```
[
	{
	  "request" :
	    {
	      "uri" : "/foo"
	    },
	  "response" :
	    {
	      "text" : "bar"
	    }
	},

	{
	  "request" :
	    {
	      "uri" : "/foo/bar"
	    },
	  "response" :
	    {
	      "text" : "foo.bar"
	    }
	},

	{
	  "request" :
	    {
	      "uri" : "/foo/bar/whatever"
	    },
	  "response" :
	    {
	      "text" : "foo.bar.whatever"
	    }
	}
]
```

This json will define 3 routes.

* /foo
* /foo/bar
* /foo/bar/whatever

You can access via localhost:4567/foo or localhost:4567/foo/bar


