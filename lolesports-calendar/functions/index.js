require('dotenv').config();
const functions = require('firebase-functions');
const request = require('request-promise');

// Gets matches
exports.getMatches = functions.https.onCall((data, context) => {
    const league_ids = data.league_ids;
    const begin_date = data.begin_date;
    const end_date = data.end_date;
    const date_range = `${begin_date},${end_date}`;
    
    const options = {
        method: 'GET',
        uri: 'https://api.pandascore.co/matches',
        qs: {
            filter: {
                league_id: league_ids.toString()
            },
            range: {
                begin_at: date_range
            },
            page: {
                size: 100
            },
            sort: "begin_at"
        },
        headers: {
            Authorization: process.env.KEY
        },
        json: true
    };
    
    return request(options)
        .then((response) => {
            return response;
        })
        .catch((err) => {
            console.log(err);

            return {
                error: "Unable to retreive data."
            };
        });
});

// Gets all matches
exports.getAllMatches = functions.https.onCall((data, context) => {
    const league_ids = data.league_ids;
    
    // Configure options for past matches
    const pastOptions = {
        method: 'GET',
        uri: 'https://api.pandascore.co/matches/past',
        qs: {
            filter: {
                league_id: league_ids.toString()
            },
            page: {
                size: 100
            },
            sort: "-begin_at"
        },
        headers: {
            Authorization: process.env.KEY
        },
        json: true
    };

    // Configure options for past matches
    const runningOptions = {
        method: 'GET',
        uri: 'https://api.pandascore.co/matches/running',
        qs: {
            filter: {
                league_id: league_ids.toString()
            },
            page: {
                size: 100
            },
            sort: "-begin_at"
        },
        headers: {
            Authorization: process.env.KEY
        },
        json: true
    };

    // Configure options for past matches
    const upcomingOptions = {
        method: 'GET',
        uri: 'https://api.pandascore.co/matches/upcoming',
        qs: {
            filter: {
                league_id: league_ids.toString()
            },
            page: {
                size: 100
            },
            sort: "-begin_at"
        },
        headers: {
            Authorization: process.env.KEY
        },
        json: true
    };
    
    const pastRequest = request(pastOptions);
    const runningRequest = request(runningOptions);
    const upcomingRequest = request(upcomingOptions);

    return Promise.all([pastRequest, runningRequest, upcomingRequest])
    .then((response) => {
        return response;
    })
    .catch((err) => {
        console.log(err);

        return {
            error: "Unable to retreive data."
        };
    });
});

// Gets past matches
exports.getPastMatches = functions.https.onCall((data, context) => {
    const league_ids = data.league_ids;
    const page_number = data.page_number;
    
    const options = {
        method: 'GET',
        uri: 'https://api.pandascore.co/matches/past',
        qs: {
            filter: {
                league_id: league_ids.toString()
            },
            page: {
                number: page_number,
                size: 100
            },
            sort: "-begin_at"
        },
        headers: {
            Authorization: process.env.KEY
        },
        json: true
    };
    
    return request(options)
        .then((response) => {
            return response;
        })
        .catch((err) => {
            console.log(err);

            return {
                error: "Unable to retreive data."
            };
        });
});

// Gets running matches
exports.getRunningMatches = functions.https.onCall((data, context) => {
    const league_ids = data.league_ids;
    const page_number = data.page_number;
    
    const options = {
        method: 'GET',
        uri: 'https://api.pandascore.co/matches/running',
        qs: {
            filter: {
                league_id: league_ids.toString()
            },
            page: {
                number: page_number,
                size: 100
            },
            sort: "begin_at"
        },
        headers: {
            Authorization: process.env.KEY
        },
        json: true
    };
    
    return request(options)
        .then((response) => {
            return response;
        })
        .catch((err) => {
            console.log(err);

            return {
                error: "Unable to retreive data."
            };
        });
});

// Gets upcoming matches
exports.getUpcomingMatches = functions.https.onCall((data, context) => {
    const league_ids = data.league_ids;
    const page_number = data.page_number;
    
    const options = {
        method: 'GET',
        uri: 'https://api.pandascore.co/matches/upcoming',
        qs: {
            filter: {
                league_id: league_ids.toString()
            },
            page: {
                number: page_number,
                size: 100
            },
            sort: "begin_at"
        },
        headers: {
            Authorization: process.env.KEY
        },
        json: true
    };
    
    return request(options)
        .then((response) => {
            return response;
        })
        .catch((err) => {
            console.log(err);

            return {
                error: "Unable to retreive data."
            };
        });
});