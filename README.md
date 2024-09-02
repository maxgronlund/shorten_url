# Creating an Service for shortening of URL's 
A quick implementation of the [Wise Home Assignment](https://gist.github.com/aamikkelsenWH/0adb191e365f9e0ed3540e660a1d706d)
<br>
I did a quick search on [search](https://hex.pm/packages?search=server&sort=recent_downloads) on hex.pm and read up on some of the options.
### Implementation considerations.
- 1 DIY server based on Cowboy
  - 4 mill. downloads on hex.pm
  - Latest activity on github is 5 month ago
  - 120 Contributors
  - Free to organize code as I wish. 
  - Documentation lik from hex.pm gave a [404](exdocs.pm/cowboy/)
  - [Getting started](https://ninenines.eu/docs/en/cowboy/2.12/guide/getting_started/) guide is for an erlang application
  - I have been working with Cowboy before

- 2 Phoenix solution
  - 3.5 mill. downloads on hex.pm
  - Latest activity on github is 2 weeks
  - 1200 Contributors
  - Strict design pattern
  - Comprehensive documentation.
  - I have been working with Phoenix before

- 3 Raxx
  - 800 k. downloads on hex.pm
  - Latest activity on github 5 years ago ;-o
  - 12 Contributors
  - [Raxx kit](https://github.com/CrowdHailer/raxx_kit) project generator
  - No pluck

- 4 Bandit
  - 1.7 mill. downloads on hex.pm
  - Latest activity on github was last week.
  - 31 Contributors on github
  - chrismccord is one of the owners ;-D



With the above in mind I have decided to create a phoenix server
- I'm familiar with Phoenix and know it as the most popular solution for rapid development.
- Bandit and Cowboy is more like adapters, althoug there might be less code at the beginning it could end up with a lot of loose ends.
- Raxx is tempting for it's simplicity, but 5 years is a long tim.

So without further considerations I heading into the land of Phoenix.


### Scaffold the Phoenix web app.
I took a look at the help on how to configure a new phoenix app is found like this:

```$ mix help phx.new```  

I desided to omit the frontend so I composed a command to generate the app like this:

```$ mix phx.new shorten_url --no-html --no-live --no-mailer --binary-id --no-assets --no-gettext```

I also wanted a model and a json interface and composed a command to scaffold it like this:

```$ mix phx.gen.json Endpoints ShortUrl short_urls short:string long:string```<br>
Where **Endpoints** is the name of the scope used to handle DB access.

Yes there is a method in Phoenix for interacting with a DB and I selected to stick with the default Postgres database.
To make it a little easier not to conflict with my local installations I created a compose.yml file so I can start postgres in a docker container like this<br>
```$ docker compose up```

### Configuration
I have only configured the dev environment, the test environment works out of the box.

### Getting the app up running.
```
$ mix ecto.create
$ mix ecto.migrate
```

### TDD
When I scaffolded the `Endpoints` I got some tests generated for free. so now I could fire up the tests.
```
$ mix test
```
That gave me an overview of where to start. I desided implement the code 


### Routing
There is a few thing I changed, Phoenix would like to put the api behind a path **localhost:4000/api/SOME_PATH**
but I changed the code so the root pointed to the api.
There is a very nice LiveDashboard, so I decided to keep it as frosting on the cake