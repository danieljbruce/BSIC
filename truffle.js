// Allows us to use ES6 in our migrations and tests.
require('babel-register')

module.exports = {
    networks: {
        development: {
            host: 'localhost',
            /*host: '192.168.0.193',*/
            /*host: '172.17.0.2',*/
            port: 8545,
            network_id: '*' // Match any network id
        }
    }
}
