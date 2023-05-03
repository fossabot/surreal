%%% @doc Base module of the library.
-module(surreal).

%%% For external usages.
-export([start_link/1, signin/3, use/3, query/3, query/2]).

%% @doc Connects to a local or remote database endpoint.
-spec start_link(Url :: string()) ->
    {ok, pid()} | {error, term()}.
start_link(Url) ->
    gen_server:start_link(surreal_gen_server, [Url], []).

%% @doc Signs this connection up to a specific authentication scope.
-spec signin(Connection :: pid(), User :: string(), Pass :: string()) ->
    surreal_response:result().
signin(Connection, User, Pass) ->
    gen_server:call(
        Connection,
        {signin, unicode:characters_to_binary(User), unicode:characters_to_binary(Pass)}
    ).

%% @doc Switch to a specific namespace and database.
-spec use(Connection :: pid(), Namespace :: string(), Database :: string()) ->
    surreal_response:result().
use(Connection, Namespace, Database) ->
    gen_server:call(
        Connection,
        {use, unicode:characters_to_binary(Namespace), unicode:characters_to_binary(Database)}
    ).

%% @doc Runs a set of SurrealQL statements against the database with parameters.
-spec query(Connection :: pid(), Query :: string(), Params :: map()) ->
    surreal_response:result().
query(Connection, Query, Params) ->
    gen_server:call(
        Connection,
        {query, unicode:characters_to_binary(Query), Params}
    ).

%% @doc Runs a set of SurrealQL statements against the database.
-spec query(Connection :: pid(), Query :: string()) ->
    surreal_response:result().
query(Connection, Query) ->
    query(Connection, Query, #{}).
