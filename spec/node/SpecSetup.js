var requirejs = require('requirejs'),
    _ = require('underscore'),
    base_context = {
        baseUrl: __dirname + '/../../target/node/',
        nodeRequire: require,
        paths: {
            'mock': __dirname + '/mock'
        }
    };
requirejs.config(base_context);

var require = requirejs,
    define = requirejs.define,
    createContext = function (stubs) {
        var map = {};

        _.each(stubs, function (value, key) {
            if (! _.isString(value)) {
                var stubname = 'stub/' + key;
                map[key] = stubname;
                define(stubname, [], function () {
                    return value;
                });
            } else {
                map[key] = value;
            }
        });

        var spec_context = _.defaults({
            context: Math.floor(Math.random() * 1000000),
            map: {
                '*': map
            }
        }, base_context);

        return {
            require: function(reqs, callback, err) {
                require.config(spec_context)(reqs, callback, err);
                require.config(base_context);
            }
        };
    };
