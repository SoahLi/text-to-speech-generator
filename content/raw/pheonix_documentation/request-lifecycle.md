Here's the cleaned-up text with all non-essential elements removed:

Requirement: This guide expects that you have gone through the introductory guides and got a Phoenix application up and running.

The goal of this guide is to talk about Phoenix's request life-cycle. This guide will take a practical approach where we will learn by doing: we will add two new pages to our Phoenix project and comment on how the pieces fit together along the way.

Let's get on with our first new Phoenix page!

When your browser accesses http://localhost:4000/, it sends a HTTP request to whatever service is running on that address, in this case our Phoenix application. The HTTP request is made of a verb and a path. For example, the following browser requests translate into:

There are other HTTP verbs. For example, submitting a form typically uses the POST verb.

Web applications typically handle requests by mapping each verb/path pair into a specific part of your application. This matching in Phoenix is done by the router. For example, we may map "/articles" to a portion of our application that shows all articles. Therefore, to add a new page, our first task is to add a new route.

The router maps unique HTTP verb/path pairs to controller/action pairs which will handle them. Controllers in Phoenix are simply Elixir modules. Actions are functions that are defined within these controllers.

The route for our "Welcome to Phoenix!" page from the previous Up And Running Guide looks like this.

Let's digest what this route is telling us. Visiting http://localhost:4000/ issues an HTTP GET request to the root path. All requests like this will be handled by the home function in the HelloWeb.PageController module.

The page we are going to build will say "Hello World, from Phoenix!" when we point our browser to http://localhost:4000/hello.

The first thing we need to do is to create the page route for a new page. Let's add a new route to the router that maps a GET request for /hello to the index action of a soon-to-be-created HelloWeb.HelloController.

Controllers are Elixir modules, and actions are Elixir functions defined in them. The purpose of actions is to gather the data and perform the tasks needed for rendering. Our route specifies that we need a HelloWeb.HelloController module with an index function.

All controller actions take two arguments. The first is conn, a struct which holds a ton of data about the request. The second is params, which are the request parameters. Here, we are not using params, and we avoid compiler warnings by prefixing it with _.

The core of this action is render(conn, :index). It tells Phoenix to render the index template. The modules responsible for rendering are called views. By default, Phoenix views are named after the controller and format, so Phoenix is expecting a HelloWeb.HelloHTML to exist and define an index function.

Phoenix views act as the presentation layer. For example, we expect the output of rendering index to be a complete HTML page. To make our lives easier, we often use templates for creating those HTML pages.

A template file has the following structure: NAME.FORMAT.TEMPLATING_LANGUAGE. In our case, let's create an index.html.heex file.

Now that we've got the route, controller, view, and template, we should be able to point our browsers at http://localhost:4000/hello and see our greeting from Phoenix!

There are a couple of interesting things to notice about what we just did. We didn't need to stop and restart the server while we made these changes. Yes, Phoenix has hot code reloading! Also, even though our index.html.heex file consists of only a single section tag, the page we get is a full HTML document. Our index template is actually rendered into layouts.

All HTTP requests start in our application endpoint. You can find it as a module named HelloWeb.Endpoint. Once you open up the endpoint file, you will see that, similar to the router, the endpoint has many calls to plug. Plug is a library and a specification for stitching web applications together. It is an essential part of how Phoenix handles requests.

Each of these plugs have a specific responsibility that we will learn later. The last plug is precisely the HelloWeb.Router module. This allows the endpoint to delegate all further request processing to the router. As we now know, its main responsibility is to map verb/path pairs to controllers. The controller then tells a view to render a template.

At this moment, you may be thinking this can be a lot of steps to simply render a page. However, as our application grows in complexity, we will see that each layer serves a distinct purpose:

endpoint - the endpoint contains the common and initial path that all requests go through. If you want something to happen on all requests, it goes to the endpoint.

router - the router is responsible for dispatching verb/path to controllers. The router also allows us to scope functionality. For example, some pages in your application may require user authentication, others may not.

controller - the job of the controller is to retrieve request information, talk to your business domain, and prepare data for the presentation layer.

view - the view handles the structured data from the controller and converts it to a presentation to be shown to users. Views are often named after the content format they are rendering.

Let's do a quick recap on how the last three components work together by adding another page.

Let's add just a little complexity to our application. We're going to add a new page that will recognize a piece of the URL, label it as a "messenger" and pass it through the controller into the template so our messenger can say hello.

As we did last time, the first thing we'll do is create a new route.

For this exercise, we're going to reuse HelloController created at the previous step and add a new show action. We'll add a line just below our last route.

Notice that we use the :messenger syntax in the path. Phoenix will take whatever value that appears in that position in the URL and convert it into a parameter. For example, if we point the browser at: http://localhost:4000/hello/Frank, the value of "messenger" will be "Frank".

Requests to our new route will be handled by the HelloWeb.HelloController show action. We already have the controller, so all we need to do is edit that controller and add a show action to it. This time, we'll need to extract the messenger from the parameters so that we can pass it to the template.

Within the body of the show action, we also pass a third argument to the render function, a key-value pair where :messenger is the key, and the messenger variable is passed as the value.

If the body of the action needs access to the full map of parameters bound to the params variable, in addition to the bound messenger variable, we could define show function like this.

It's good to remember that the keys of the params map will always be strings, and that the equals sign does not represent assignment, but is instead a pattern match assertion.

For the last piece of this puzzle, we'll need a new template. Since it is for the show action of HelloController, it will go into the hello_html directory and be called show.html.heex. It will look surprisingly like our index.html.heex template, except that we will need to display the name of our messenger.

To do that, we'll use the special HEEx tags for executing Elixir expressions. Notice that EEx tag has an equals sign. That means that any Elixir code that goes between those tags will be executed, and the resulting value will replace the tag in the HTML output. If the equals sign were missing, the code would still be executed, but the value would not appear on the page.

Remember our templates are written in HEEx (HTML+EEx). HEEx is a superset of EEx, and thereby supports the EEx interpolation syntax for interpolating arbitrary blocks of code. In general, the HEEx interpolation syntax is preferred anytime there is HTML-aware intepolation to be done.

The only times EEx interpolation is necessary is for interpolationg arbitrary blocks of markup, such as branching logic that inects separate markup trees, or for interpolating values within script or style tags.

Our messenger appears as @messenger.

The values we passed to the view from the controller are collectively called our "assigns". We could access our messenger value via assigns.messenger but through some metaprogramming, Phoenix gives us the much cleaner @ syntax for use in templates.

We're done. If you point your browser to http://localhost:4000/hello/Frank, you should see a page that looks like this.

Play around a bit. Whatever you put after /hello/ will appear on the page as your messenger.
