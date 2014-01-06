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

### Query Params

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

### HTTP Method

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

### Header

```
{
	"request" :
		{
			"uri" : "/header"
		},
	"response" :
		{
			"text" : "header",
			"headers": {
				"content-type" : "application/json"	
			}
		}
} 
```

### Redirect
Redirect is a common case for normal web development. We can simply redirect a request to different url.

```
{
	"request" :
		{
			"uri" : "/redirect"
		},
	"redirectTo" : "http://www.github.com"
} 
```

### Form
In web development, form is often used to submit information to server side.
```
{
	"request" :
		{
			"uri" : "/form",
			"method" : "post",
			"forms" : {"foo" : "bar"}
		},
	"response" :
		{
			"text" : "form"
		}
} 
```

You can also use both query params and form data.

```
	{
		"request" :
	    {
	      "uri" : "/form_with_params",
	      "method" : "post",
	      "forms" : {"key" : "value"},
	      "queries": {
	      	"params" : {"foo" : "bar"}
	      }
	    },
	  "response" :
	    {
	      "text" : "form"
	    }
	} ,
```

### JSON Request
Json is rising with RESTful style architecture. Just like XML, in the most case, only JSON structure is important, so json operator can be used.

```
	{
		"request" :
	    {
	      "uri" : "/post_json_text",
	      "method" : "post",
	      "text": {
	      	"json" : "{\"foo\":\"bar\"}"	
	      }
	    },
	  "response" :
	    {
	      "text" : "post json text"
	    }
	} 
```
#### NOTE: Please escape the quote in text.

The large request can be put into a file:
```
{
  "request": 
    {
      "uri": "/json",
      "file": 
        {
          "json": "your_file.json"
        }
    },
  "response": 
    {
      "text": "foo"
    }
}
```
#### NOTE: your json file path should be absolute.

### Matcher

You can define your request uri as a regexp using the ruby %r[] syntax.

```
	{
		"request" :
	    {
	      "uri" : "%r[/regexp(\\d)]"
	    },
	  "response" :
	    {
	      "text" : "params['captures']"
	    }
	} 
```
#### Note: if hte return text contains string like params, momo just eval it. So you can use params['captures'] to fetch the regexp mathers.

---------------------------------------

Response
--------

### Content
As you have seen in previous example, response with content is pretty easy.

```
{
	"request" :
		{
			"uri" : "/foo"
		},
	"response" :
		{
			"text" : "bar"
		}
} 
```

If you want make the response more flexable, you can use erb template.Note, you should  place your erb file in views dirctory.

```
{
	"request" :
		{
			"uri" : "/foo"
		},
	"response" :
		{
			"file" : "bar"
		}
} 
```
The above response will render erb template views/bar.erb. 

It is very common to return json and xml with correct header. Momo allow you to do this.

```
{
	"request" :
		{
			"uri" : "/return_json"
		},
	"response" :
		{
			"json" : "{\"foo\":\"bar\"}"	
		}
}, 
{
	"request" :
		{
			"uri" : "/return_xml"
		},
	"response" :
		{
			"xml" : "<name>momo</name><type>mock server</type>"	
		}
} 
```

### Status Code
Momo also supports HTTP status code response.
```
{
	"request" :
		{
			"uri" : "/status_300"
		},
	"response" :
		{
			"text" : "status 300",
			"status": "300"
		}
} 
```

### Header
We can also specify HTTP header in response.

```
{
	"request" :
		{
			"uri" : "/header"
		},
	"response" :
		{
			"text" : "header",
			"headers": {
				"content-type" : "application/json"	
			}
		}
} 
```

### Redirect
Redirect is a common case for normal web development. We can simply redirect a request to different url.
```
{
  "request" :
    {
      "uri" : "/redirect"
    },
  "redirectTo" : "http://www.github.com"
}
```

### Cookie
Cookie can also be in the response.

```
{
	"request" :
		{
			"uri" : "/cookie",
			"method" : "get"
		},
	"response" :
		{
			"text" : "cookie",
			"cookies" : {"foo" : "bar"}
		}
}
```	
### Latency
Sometimes, we need a latency to simulate slow server side operation.

{
  "request" :
    {
      "text" : "foo"
    },
  "response" :
    {
      "latency" : 1s
    }
}

Above response will delay 1s before return.

------------------------------------------------

Command Line
-------------

momo uses Sinatra and Sinatra applications can be run directly:

```
ruby mock_server.rb [-h] [-x] [-e ENVIRONMENT] [-p PORT] [-o HOST] [-s HANDLER]
Options are:
```

* -h # help
* -p # set the port (default is 4567)
* -o # set the host (default is 0.0.0.0)
* -e # set the environment (default is development)
* -s # specify rack server/handler (default is thin)
* -x # turn on the mutex lock (default is off)

