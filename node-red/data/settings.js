module.exports = {
    editorTheme: {
        projects: {
            enabled: true
        }
    },
    adminAuth: {
        type: "credentials",
        users: [{
            username: "admin",
            password: "$2y$08$gg7TEDs499Z.J/3iWHBcq.5amm0VwzQCfOSuYx1E7oEU8vmCudBp.",
            permissions: "*"
        }]
    },
    httpAdminRoot: '/',
    httpNodeRoot: '/',
    uiHost: "0.0.0.0",  // Add this line to allow connections from Cloudflare Tunnel
    uiPort: 1880,
    // This helps with running behind a reverse proxy like Cloudflare
    httpNodeCors: {
        origin: "*",
        methods: "GET,PUT,POST,DELETE"
    },
    webSocketNodeVerifyClient: () => true,
    
    // Add these lines for better security and compatibility with Cloudflare
    requireHttps: false,  // Cloudflare Tunnel handles HTTPS, so this can be false
    trustProxy: true,     // Trust the Cloudflare Tunnel as a proxy

    // Optionally, you can add this for better logging
    logging: {
        console: {
            level: "info",
            metrics: false,
            audit: false
        }
    }
};