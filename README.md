Momo
=================

Another mock server framework using sinatra and ruby


### Install:

* git clone

* bundle

* modify config.json

* ruby mock_server.rb

* access localhost:4567/foo and have fun

API
=======

Request
--------

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

### Params

You can define routes with params like this 
```
[
	{
		"request" :
	    {
	      "uri" : "/params",
	      "queries" : 
	        {
	          "params" : {"blah": null}
	        }
	    },
	  "response" :
	    {
	      "text" : "bar"
	    }
	}
]
```

Now you get a route like localhost:4567/params?blah, access this url and it will return "bar".

Define params with value like this 
```
[
	{
		"request" :
	    {
	      "uri" : "/multi_params",
	      "queries" : 
	        {
	          "params" : {"foo": null, "bar": null}
	        }
	    },
	  "response" :
	    {
	      "text" : "foo.bar"
	    }
	}
]	
```

### Method

You can define restful routes just like this 

```
[
	{
		"request" :
	    {
	      "uri" : "/simple_get"
	    },
	  "response" :
	    {
	      "text" : "simple get"
	    }
	},

	{
		"request" :
	    {
	      "uri" : "/simple_post",
	      "method" : "post"
	    },
	  "response" :
	    {
	      "text" : "simple post"
	    }
	},

	{
		"request" :
	    {
	      "uri" : "/simple_put",
	      "method" : "put"
	    },
	  "response" :
	    {
	      "text" : "simple put"
	    }
	}, 

	{
		"request" :
	    {
	      "uri" : "/simple_delete",
	      "method" : "delete"
	    },
	  "response" :
	    {
	      "text" : "simple delete"
	    }
	} 
]
```
