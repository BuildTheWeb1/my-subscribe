//
//  PopularSubscriptionsData.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 26.01.2026.
//

import Foundation

enum PopularSubscriptionsData {
    
    static let featured: [PopularSubscription] = [
        netflix, spotify, disneyPlus, appleMusic, hboMax, amazonPrimeVideo, youtubeMusic, adobeCreativeCloud
    ]
    
    static let all: [PopularSubscription] = [
        // Streaming Video
        netflix, disneyPlus, hulu, amazonPrimeVideo, hboMax, appleTVPlus, paramountPlus,
        peacock, youtubePremium, crunchyroll, discoveryPlus, espnPlus, starz, showtime, mgmPlus,
        // Music
        spotify, appleMusic, youtubeMusic, amazonMusic, tidal,
        // Productivity
        microsoft365, adobeCreativeCloud, googleOne, dropbox, notion, evernote, onePassword, canvaPro,
        // Gaming
        xboxGamePass, playstationPlus, nintendoSwitchOnline, eaPlay, geforceNow,
        // News & Reading
        newYorkTimes, wallStreetJournal, kindleUnlimited, audible, medium,
        // Fitness & Health
        peloton, appleFitnessPlus, strava, headspace, calm,
        // Cloud Storage
        iCloudPlus, oneDrive,
        // Other
        linkedInPremium, duolingoPlus, chatGPTPlus
    ]
    
    static func services(for category: SubscriptionCategory) -> [PopularSubscription] {
        all.filter { $0.category == category }
    }
    
    // MARK: - Streaming Video
    
    static let netflix = PopularSubscription(
        name: "Netflix",
        iconName: "play.tv.fill",
        category: .streaming,
        priceTiers: [
            PriceTier(name: "Standard with Ads", price: 6.99, billingCycle: .monthly),
            PriceTier(name: "Standard", price: 15.49, billingCycle: .monthly),
            PriceTier(name: "Premium", price: 22.99, billingCycle: .monthly)
        ],
        defaultTierIndex: 1
    )
    
    static let disneyPlus = PopularSubscription(
        name: "Disney+",
        iconName: "sparkles.tv.fill",
        category: .streaming,
        priceTiers: [
            PriceTier(name: "Basic with Ads", price: 7.99, billingCycle: .monthly),
            PriceTier(name: "Premium", price: 13.99, billingCycle: .monthly),
            PriceTier(name: "Premium Annual", price: 139.99, billingCycle: .yearly)
        ],
        defaultTierIndex: 1
    )
    
    static let hulu = PopularSubscription(
        name: "Hulu",
        iconName: "play.rectangle.fill",
        category: .streaming,
        priceTiers: [
            PriceTier(name: "With Ads", price: 7.99, billingCycle: .monthly),
            PriceTier(name: "No Ads", price: 17.99, billingCycle: .monthly)
        ],
        defaultTierIndex: 0
    )
    
    static let amazonPrimeVideo = PopularSubscription(
        name: "Prime Video",
        iconName: "play.square.fill",
        category: .streaming,
        priceTiers: [
            PriceTier(name: "With Ads", price: 8.99, billingCycle: .monthly),
            PriceTier(name: "Ad-Free", price: 11.99, billingCycle: .monthly),
            PriceTier(name: "Prime Monthly", price: 14.99, billingCycle: .monthly),
            PriceTier(name: "Prime Annual", price: 139, billingCycle: .yearly)
        ],
        defaultTierIndex: 2
    )
    
    static let hboMax = PopularSubscription(
        name: "Max",
        iconName: "play.display",
        category: .streaming,
        priceTiers: [
            PriceTier(name: "With Ads", price: 9.99, billingCycle: .monthly),
            PriceTier(name: "Ad-Free", price: 16.99, billingCycle: .monthly),
            PriceTier(name: "Ultimate", price: 20.99, billingCycle: .monthly)
        ],
        defaultTierIndex: 1
    )
    
    static let appleTVPlus = PopularSubscription(
        name: "Apple TV+",
        iconName: "appletv.fill",
        category: .streaming,
        priceTiers: [
            PriceTier(name: "Monthly", price: 9.99, billingCycle: .monthly),
            PriceTier(name: "Annual", price: 99, billingCycle: .yearly)
        ],
        defaultTierIndex: 0
    )
    
    static let paramountPlus = PopularSubscription(
        name: "Paramount+",
        iconName: "mountain.2.fill",
        category: .streaming,
        priceTiers: [
            PriceTier(name: "Essential", price: 7.99, billingCycle: .monthly),
            PriceTier(name: "With Showtime", price: 12.99, billingCycle: .monthly),
            PriceTier(name: "Annual", price: 59.99, billingCycle: .yearly)
        ],
        defaultTierIndex: 0
    )
    
    static let peacock = PopularSubscription(
        name: "Peacock",
        iconName: "bird.fill",
        category: .streaming,
        priceTiers: [
            PriceTier(name: "Premium", price: 7.99, billingCycle: .monthly),
            PriceTier(name: "Premium Plus", price: 13.99, billingCycle: .monthly)
        ],
        defaultTierIndex: 0
    )
    
    static let youtubePremium = PopularSubscription(
        name: "YouTube Premium",
        iconName: "play.rectangle.fill",
        category: .streaming,
        priceTiers: [
            PriceTier(name: "Individual", price: 13.99, billingCycle: .monthly),
            PriceTier(name: "Family", price: 22.99, billingCycle: .monthly),
            PriceTier(name: "Student", price: 7.99, billingCycle: .monthly)
        ],
        defaultTierIndex: 0
    )
    
    static let crunchyroll = PopularSubscription(
        name: "Crunchyroll",
        iconName: "sparkles.tv",
        category: .streaming,
        priceTiers: [
            PriceTier(name: "Fan", price: 7.99, billingCycle: .monthly),
            PriceTier(name: "Mega Fan", price: 9.99, billingCycle: .monthly),
            PriceTier(name: "Ultimate Fan", price: 14.99, billingCycle: .monthly)
        ],
        defaultTierIndex: 0
    )
    
    static let discoveryPlus = PopularSubscription(
        name: "Discovery+",
        iconName: "globe.americas.fill",
        category: .streaming,
        priceTiers: [
            PriceTier(name: "With Ads", price: 4.99, billingCycle: .monthly),
            PriceTier(name: "Ad-Free", price: 8.99, billingCycle: .monthly)
        ],
        defaultTierIndex: 0
    )
    
    static let espnPlus = PopularSubscription(
        name: "ESPN+",
        iconName: "sportscourt.fill",
        category: .streaming,
        priceTiers: [
            PriceTier(name: "Monthly", price: 10.99, billingCycle: .monthly),
            PriceTier(name: "Annual", price: 109.99, billingCycle: .yearly)
        ],
        defaultTierIndex: 0
    )
    
    static let starz = PopularSubscription(
        name: "Starz",
        iconName: "star.fill",
        category: .streaming,
        priceTiers: [
            PriceTier(name: "Monthly", price: 9.99, billingCycle: .monthly)
        ],
        defaultTierIndex: 0
    )
    
    static let showtime = PopularSubscription(
        name: "Showtime",
        iconName: "film.fill",
        category: .streaming,
        priceTiers: [
            PriceTier(name: "Monthly", price: 10.99, billingCycle: .monthly)
        ],
        defaultTierIndex: 0
    )
    
    static let mgmPlus = PopularSubscription(
        name: "MGM+",
        iconName: "lion.fill",
        category: .streaming,
        priceTiers: [
            PriceTier(name: "Monthly", price: 6.99, billingCycle: .monthly),
            PriceTier(name: "Annual", price: 49.99, billingCycle: .yearly)
        ],
        defaultTierIndex: 0
    )
    
    // MARK: - Music
    
    static let spotify = PopularSubscription(
        name: "Spotify",
        iconName: "waveform",
        category: .music,
        priceTiers: [
            PriceTier(name: "Individual", price: 11.99, billingCycle: .monthly),
            PriceTier(name: "Duo", price: 16.99, billingCycle: .monthly),
            PriceTier(name: "Family", price: 19.99, billingCycle: .monthly),
            PriceTier(name: "Student", price: 5.99, billingCycle: .monthly)
        ],
        defaultTierIndex: 0
    )
    
    static let appleMusic = PopularSubscription(
        name: "Apple Music",
        iconName: "music.note",
        category: .music,
        priceTiers: [
            PriceTier(name: "Voice", price: 4.99, billingCycle: .monthly),
            PriceTier(name: "Individual", price: 10.99, billingCycle: .monthly),
            PriceTier(name: "Family", price: 16.99, billingCycle: .monthly),
            PriceTier(name: "Student", price: 5.99, billingCycle: .monthly)
        ],
        defaultTierIndex: 1
    )
    
    static let youtubeMusic = PopularSubscription(
        name: "YouTube Music",
        iconName: "music.note.tv.fill",
        category: .music,
        priceTiers: [
            PriceTier(name: "Individual", price: 10.99, billingCycle: .monthly),
            PriceTier(name: "Family", price: 16.99, billingCycle: .monthly),
            PriceTier(name: "Student", price: 5.49, billingCycle: .monthly)
        ],
        defaultTierIndex: 0
    )
    
    static let amazonMusic = PopularSubscription(
        name: "Amazon Music",
        iconName: "music.quarternote.3",
        category: .music,
        priceTiers: [
            PriceTier(name: "Unlimited", price: 9.99, billingCycle: .monthly),
            PriceTier(name: "Family", price: 15.99, billingCycle: .monthly)
        ],
        defaultTierIndex: 0
    )
    
    static let tidal = PopularSubscription(
        name: "Tidal",
        iconName: "waveform.circle.fill",
        category: .music,
        priceTiers: [
            PriceTier(name: "HiFi", price: 10.99, billingCycle: .monthly),
            PriceTier(name: "HiFi Plus", price: 19.99, billingCycle: .monthly),
            PriceTier(name: "Family", price: 16.99, billingCycle: .monthly)
        ],
        defaultTierIndex: 0
    )
    
    // MARK: - Productivity
    
    static let microsoft365 = PopularSubscription(
        name: "Microsoft 365",
        iconName: "doc.text.fill",
        category: .productivity,
        priceTiers: [
            PriceTier(name: "Personal Monthly", price: 6.99, billingCycle: .monthly),
            PriceTier(name: "Personal Annual", price: 69.99, billingCycle: .yearly),
            PriceTier(name: "Family Monthly", price: 9.99, billingCycle: .monthly),
            PriceTier(name: "Family Annual", price: 99.99, billingCycle: .yearly)
        ],
        defaultTierIndex: 1
    )
    
    static let adobeCreativeCloud = PopularSubscription(
        name: "Adobe Creative Cloud",
        iconName: "paintbrush.fill",
        category: .productivity,
        priceTiers: [
            PriceTier(name: "Photography", price: 9.99, billingCycle: .monthly),
            PriceTier(name: "Single App", price: 22.99, billingCycle: .monthly),
            PriceTier(name: "All Apps", price: 59.99, billingCycle: .monthly),
            PriceTier(name: "Student All Apps", price: 19.99, billingCycle: .monthly)
        ],
        defaultTierIndex: 2
    )
    
    static let googleOne = PopularSubscription(
        name: "Google One",
        iconName: "cloud.fill",
        category: .productivity,
        priceTiers: [
            PriceTier(name: "100 GB", price: 1.99, billingCycle: .monthly),
            PriceTier(name: "200 GB", price: 2.99, billingCycle: .monthly),
            PriceTier(name: "2 TB", price: 9.99, billingCycle: .monthly)
        ],
        defaultTierIndex: 0
    )
    
    static let dropbox = PopularSubscription(
        name: "Dropbox",
        iconName: "shippingbox.fill",
        category: .productivity,
        priceTiers: [
            PriceTier(name: "Plus", price: 11.99, billingCycle: .monthly),
            PriceTier(name: "Professional", price: 19.99, billingCycle: .monthly),
            PriceTier(name: "Plus Annual", price: 119.88, billingCycle: .yearly)
        ],
        defaultTierIndex: 0
    )
    
    static let notion = PopularSubscription(
        name: "Notion",
        iconName: "note.text",
        category: .productivity,
        priceTiers: [
            PriceTier(name: "Plus", price: 10, billingCycle: .monthly),
            PriceTier(name: "Business", price: 18, billingCycle: .monthly)
        ],
        defaultTierIndex: 0
    )
    
    static let evernote = PopularSubscription(
        name: "Evernote",
        iconName: "elephant.fill",
        category: .productivity,
        priceTiers: [
            PriceTier(name: "Personal", price: 10.99, billingCycle: .monthly),
            PriceTier(name: "Professional", price: 14.99, billingCycle: .monthly)
        ],
        defaultTierIndex: 0
    )
    
    static let onePassword = PopularSubscription(
        name: "1Password",
        iconName: "lock.fill",
        category: .productivity,
        priceTiers: [
            PriceTier(name: "Individual", price: 2.99, billingCycle: .monthly),
            PriceTier(name: "Families", price: 4.99, billingCycle: .monthly),
            PriceTier(name: "Individual Annual", price: 35.88, billingCycle: .yearly)
        ],
        defaultTierIndex: 0
    )
    
    static let canvaPro = PopularSubscription(
        name: "Canva Pro",
        iconName: "pencil.and.outline",
        category: .productivity,
        priceTiers: [
            PriceTier(name: "Monthly", price: 12.99, billingCycle: .monthly),
            PriceTier(name: "Annual", price: 119.99, billingCycle: .yearly)
        ],
        defaultTierIndex: 0
    )
    
    // MARK: - Gaming
    
    static let xboxGamePass = PopularSubscription(
        name: "Xbox Game Pass",
        iconName: "gamecontroller.fill",
        category: .gaming,
        priceTiers: [
            PriceTier(name: "Core", price: 9.99, billingCycle: .monthly),
            PriceTier(name: "Standard", price: 14.99, billingCycle: .monthly),
            PriceTier(name: "Ultimate", price: 19.99, billingCycle: .monthly)
        ],
        defaultTierIndex: 1
    )
    
    static let playstationPlus = PopularSubscription(
        name: "PlayStation Plus",
        iconName: "logo.playstation",
        category: .gaming,
        priceTiers: [
            PriceTier(name: "Essential Monthly", price: 9.99, billingCycle: .monthly),
            PriceTier(name: "Extra Monthly", price: 14.99, billingCycle: .monthly),
            PriceTier(name: "Premium Monthly", price: 17.99, billingCycle: .monthly)
        ],
        defaultTierIndex: 0
    )
    
    static let nintendoSwitchOnline = PopularSubscription(
        name: "Nintendo Switch Online",
        iconName: "n.square.fill",
        category: .gaming,
        priceTiers: [
            PriceTier(name: "Individual Monthly", price: 3.99, billingCycle: .monthly),
            PriceTier(name: "Individual Annual", price: 19.99, billingCycle: .yearly),
            PriceTier(name: "Family Annual", price: 34.99, billingCycle: .yearly),
            PriceTier(name: "Expansion Pack", price: 49.99, billingCycle: .yearly)
        ],
        defaultTierIndex: 1
    )
    
    static let eaPlay = PopularSubscription(
        name: "EA Play",
        iconName: "e.square.fill",
        category: .gaming,
        priceTiers: [
            PriceTier(name: "Monthly", price: 5.99, billingCycle: .monthly),
            PriceTier(name: "Annual", price: 39.99, billingCycle: .yearly)
        ],
        defaultTierIndex: 0
    )
    
    static let geforceNow = PopularSubscription(
        name: "GeForce Now",
        iconName: "display",
        category: .gaming,
        priceTiers: [
            PriceTier(name: "Priority", price: 9.99, billingCycle: .monthly),
            PriceTier(name: "Ultimate", price: 19.99, billingCycle: .monthly)
        ],
        defaultTierIndex: 0
    )
    
    // MARK: - News & Reading
    
    static let newYorkTimes = PopularSubscription(
        name: "New York Times",
        iconName: "newspaper.fill",
        category: .news,
        priceTiers: [
            PriceTier(name: "Basic Digital", price: 17, billingCycle: .monthly),
            PriceTier(name: "All Access", price: 25, billingCycle: .monthly)
        ],
        defaultTierIndex: 0
    )
    
    static let wallStreetJournal = PopularSubscription(
        name: "Wall Street Journal",
        iconName: "chart.line.uptrend.xyaxis",
        category: .news,
        priceTiers: [
            PriceTier(name: "Digital", price: 12.99, billingCycle: .monthly),
            PriceTier(name: "Print + Digital", price: 38.99, billingCycle: .monthly)
        ],
        defaultTierIndex: 0
    )
    
    static let kindleUnlimited = PopularSubscription(
        name: "Kindle Unlimited",
        iconName: "books.vertical.fill",
        category: .news,
        priceTiers: [
            PriceTier(name: "Monthly", price: 11.99, billingCycle: .monthly)
        ],
        defaultTierIndex: 0
    )
    
    static let audible = PopularSubscription(
        name: "Audible",
        iconName: "headphones",
        category: .news,
        priceTiers: [
            PriceTier(name: "Plus", price: 7.95, billingCycle: .monthly),
            PriceTier(name: "Premium Plus", price: 14.95, billingCycle: .monthly)
        ],
        defaultTierIndex: 1
    )
    
    static let medium = PopularSubscription(
        name: "Medium",
        iconName: "text.alignleft",
        category: .news,
        priceTiers: [
            PriceTier(name: "Monthly", price: 5, billingCycle: .monthly),
            PriceTier(name: "Annual", price: 50, billingCycle: .yearly)
        ],
        defaultTierIndex: 0
    )
    
    // MARK: - Fitness & Health
    
    static let peloton = PopularSubscription(
        name: "Peloton",
        iconName: "figure.run",
        category: .fitness,
        priceTiers: [
            PriceTier(name: "App", price: 12.99, billingCycle: .monthly),
            PriceTier(name: "All-Access", price: 44, billingCycle: .monthly)
        ],
        defaultTierIndex: 0
    )
    
    static let appleFitnessPlus = PopularSubscription(
        name: "Apple Fitness+",
        iconName: "figure.cooldown",
        category: .fitness,
        priceTiers: [
            PriceTier(name: "Monthly", price: 9.99, billingCycle: .monthly),
            PriceTier(name: "Annual", price: 79.99, billingCycle: .yearly)
        ],
        defaultTierIndex: 0
    )
    
    static let strava = PopularSubscription(
        name: "Strava",
        iconName: "figure.outdoor.cycle",
        category: .fitness,
        priceTiers: [
            PriceTier(name: "Monthly", price: 11.99, billingCycle: .monthly),
            PriceTier(name: "Annual", price: 79.99, billingCycle: .yearly)
        ],
        defaultTierIndex: 0
    )
    
    static let headspace = PopularSubscription(
        name: "Headspace",
        iconName: "brain.head.profile",
        category: .fitness,
        priceTiers: [
            PriceTier(name: "Monthly", price: 12.99, billingCycle: .monthly),
            PriceTier(name: "Annual", price: 69.99, billingCycle: .yearly)
        ],
        defaultTierIndex: 0
    )
    
    static let calm = PopularSubscription(
        name: "Calm",
        iconName: "leaf.fill",
        category: .fitness,
        priceTiers: [
            PriceTier(name: "Monthly", price: 14.99, billingCycle: .monthly),
            PriceTier(name: "Annual", price: 69.99, billingCycle: .yearly),
            PriceTier(name: "Lifetime", price: 399.99, billingCycle: .yearly)
        ],
        defaultTierIndex: 1
    )
    
    // MARK: - Cloud Storage
    
    static let iCloudPlus = PopularSubscription(
        name: "iCloud+",
        iconName: "icloud.fill",
        category: .utilities,
        priceTiers: [
            PriceTier(name: "50 GB", price: 0.99, billingCycle: .monthly),
            PriceTier(name: "200 GB", price: 2.99, billingCycle: .monthly),
            PriceTier(name: "2 TB", price: 9.99, billingCycle: .monthly),
            PriceTier(name: "6 TB", price: 29.99, billingCycle: .monthly),
            PriceTier(name: "12 TB", price: 59.99, billingCycle: .monthly)
        ],
        defaultTierIndex: 1
    )
    
    static let oneDrive = PopularSubscription(
        name: "OneDrive",
        iconName: "cloud.fill",
        category: .utilities,
        priceTiers: [
            PriceTier(name: "100 GB", price: 1.99, billingCycle: .monthly)
        ],
        defaultTierIndex: 0
    )
    
    // MARK: - Other
    
    static let linkedInPremium = PopularSubscription(
        name: "LinkedIn Premium",
        iconName: "person.crop.rectangle.fill",
        category: .other,
        priceTiers: [
            PriceTier(name: "Career", price: 29.99, billingCycle: .monthly),
            PriceTier(name: "Business", price: 59.99, billingCycle: .monthly)
        ],
        defaultTierIndex: 0
    )
    
    static let duolingoPlus = PopularSubscription(
        name: "Duolingo Plus",
        iconName: "character.book.closed.fill",
        category: .education,
        priceTiers: [
            PriceTier(name: "Super", price: 6.99, billingCycle: .monthly),
            PriceTier(name: "Super Annual", price: 83.99, billingCycle: .yearly),
            PriceTier(name: "Family", price: 119.99, billingCycle: .yearly)
        ],
        defaultTierIndex: 0
    )
    
    static let chatGPTPlus = PopularSubscription(
        name: "ChatGPT Plus",
        iconName: "bubble.left.and.bubble.right.fill",
        category: .productivity,
        priceTiers: [
            PriceTier(name: "Plus", price: 20, billingCycle: .monthly),
            PriceTier(name: "Pro", price: 200, billingCycle: .monthly)
        ],
        defaultTierIndex: 0
    )
}
