# Creating a Service for Shortening URLs
A quick implementation of the [Wise Home Assignment](https://gist.github.com/aamikkelsenWH/0adb191e365f9e0ed3540e660a1d706d)
<br>
I did a quick search on [hex.pm](https://hex.pm/packages?search=server&sort=recent_downloads) and read up on some of the options.

### Implementation Considerations:
- **1. DIY Server based on Cowboy**
  - 4 million downloads on hex.pm
  - Latest activity on GitHub was 5 months ago
  - 120 contributors
  - Free to organize code as I wish
  - Documentation link from hex.pm gave a [404](exdocs.pm/cowboy/)
  - [Getting started](https://ninenines.eu/docs/en/cowboy/2.12/guide/getting_started/) guide is for an Erlang application
  - I have worked with Cowboy before

- **2. Phoenix Solution**
  - 3.5 million downloads on hex.pm
  - Latest activity on GitHub was 2 weeks ago
  - 1200 contributors
  - Strict design pattern
  - Comprehensive documentation
  - I have worked with Phoenix before
  - Has an integrated persistance layer

- **3. Raxx**
  - 800k downloads on hex.pm
  - Latest activity on GitHub was 5 years ago 😬
  - 12 contributors
  - [Raxx Kit](https://github.com/CrowdHailer/raxx_kit) project generator
  - No traction

- **4. Bandit**
  - 1.7 million downloads on hex.pm
  - Latest activity on GitHub was last week
  - 31 contributors on GitHub
  - Chris McCord is one of the owners 😄

-  **5. Persistance**
  - Should I implement the persistance layer by myself and then use **Mnesia**, **ETS** or a **GenServer**


Given the above, I decided to create a Phoenix server:
- I'm familiar with Phoenix and know it as the most popular solution for rapid development.
- Bandit and Cowboy are more like adapters. Although there might be less code initially, it could lead to many loose ends.
- Raxx is tempting for its simplicity, but 5 years without any commits is a long time.


So, without further consideration, I'm heading into the land of Phoenix.

### Scaffolding the Phoenix Web App
I looked at the ideas for added features, and since Phoenix comes with some of them 'for free,' I decided to implement the following from the beginning:
- Duplicate URLs return the same shortened URL.
- Persist shortened URLs between application restarts.

I decided to omit the frontend, so I composed a command to generate the app like this:

```bash
$ mix phx.new shorten_url --no-html --no-live --no-mailer --binary-id --no-assets --no-gettext
```

I also wanted a model and a JSON interface, so I scaffolded it like this:

```bash
$ mix phx.gen.json Endpoints ShortUrl short_urls short_url:string url:string
```

Where **Endpoints** is the name of the scope used to handle DB access. The rationale for naming the fields is that they should reflect the expected server response.
<br>
If I were to refactor this, I would name the application something other than `shorten_url` and the DB record something other than `short_url`. There are too many names that look too similar, but that's what it is for now.


### Configuration
I have only configured the dev environment with matching credentials for Postgres; the test environment works out of the box.

### Getting the App Up and Running
```bash
$ docker compose up
$ mix ecto.create
$ mix ecto.migrate
```

### TDD
When I scaffolded the `Endpoints`, I got some tests generated for free, so I could now fire up the tests.
```bash
$ mix test
```
That gave me an overview of where to start. I decided to create an inside-out implementation of the code from the endpoints.

### Routing
There are a few things I changed. Phoenix likes to put the API behind a path like `localhost:4000/api/SOME_PATH`, but I changed the code so the root points to the API.
There is a very nice [LiveDashboard](http://localhost:4000/dev/dashboard/home), so I decided to keep it as the frosting on the cake, but authorization is missing. There is a note in the `routes.ex` file.

### Endpoint
The interface between the controllers and the Repo. I removed unnecessary methods and created a new method `find_or_create_short_url`.
- `find_or_create_short_url`: As the name indicates, it finds a short URL, so if a shortened URL is already created, it just finds it and returns it; otherwise, it creates it and returns it.

### Controllers
Only two methods are needed:
- `def show()`: Used to find a shortened URL and redirect to the long URL. I also implemented a 404 as a little Christmas present.
- `def create()`: Used to create a shortened URL. I added some error handling and handling of duplicates.

### Preparing for Production
I abstracted the fetching of host and port into the `UrlHelper`. This way, it should work in production on whatever domain the app is deployed on, no matter the environment.

### Manual Testing
Automated tests and TDD are great and make me work faster, but... there's always a but.
I fired up Postman and tested it by hand. Yes, I found that I could crash the application by sending bad data and that some of the JSON wasn't formatted as expected.
### Test on localhost with curl
```
curl -X POST http://localhost:4000/shorten-url \
-H "Content-Type: application/json" \
-d '{"url": "https://gist.github.com/aamikkelsenWH/0adb191e365f9e0ed3540e660a1d706d"}'
```

### Test on Gigalixir with curl
```
curl -X POST https://shortenurl.gigalixirapp.com/shorten-url \
-H "Content-Type: application/json" \
-d '{"url": "https://gist.github.com/aamikkelsenWH/0adb191e365f9e0ed3540e660a1d706d"}'
```
```
curl -i http://shortenurl.gigalixirapp.com:80/jgdMbP
```

### Conclusion
I spent more time than 5 hours—more like 10—but I got carried away with this fun little assignment.
In my defense, it's been a year since I last worked with Elixir and Phoenix and it was really fun.

### Further Development
Why not have a little fun tomorow and implement some of the ideas for added features and some of my own
- Expire short URLs.
- Statistic/Logging API
- Put the dashboard behind authorization.
- Make some stress test. When will it break.
- All out, install it on a 6$ esp32.