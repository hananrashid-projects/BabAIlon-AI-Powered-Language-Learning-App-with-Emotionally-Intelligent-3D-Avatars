import * as THREE from "three";
import { OrbitControls } from "jsm/controls/OrbitControls.js";

const searchBox = document.getElementById("search-box");
const clearBtn = document.getElementById("clear-btn");

// ✅ Show "X" Button Only When There is Text
searchBox.addEventListener("input", () => {
    if (searchBox.value.length > 0) {
        clearBtn.style.display = "block";
    } else {
        clearBtn.style.display = "none";
    }
});

// ✅ Clear Text and Remove Pin/Highlights
clearBtn.addEventListener("click", () => {
    searchBox.value = ""; // Clear search box
    clearBtn.style.display = "none"; // Hide the X button

    // Remove country pin
    const existingPin = scene.getObjectByName("country-pin");
    if (existingPin) {
        scene.remove(existingPin);
    }

    // Remove highlighted regions
    const existingHighlight = scene.getObjectByName("highlight-region");
    if (existingHighlight) {
        scene.remove(existingHighlight);
    }

    console.log("🗑️ Cleared search box, pins, and highlights.");
});

// 🌌 1. Create Scene with Black Background
const scene = new THREE.Scene();
scene.background = new THREE.Color(0x000000);

// 🎥 2. Renderer Setup
const renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
renderer.setSize(window.innerWidth, window.innerHeight);
renderer.setPixelRatio(window.devicePixelRatio);
document.body.appendChild(renderer.domElement);

// 🎥 3. Camera Setup
const camera = new THREE.PerspectiveCamera(60, window.innerWidth / window.innerHeight, 0.1, 100);
camera.position.set(0, 0, 3);

// 🔄 4. Smooth Controls
const controls = new OrbitControls(camera, renderer.domElement);
controls.enableDamping = true;
controls.dampingFactor = 0.08;
controls.rotateSpeed = 0.5;
controls.zoomSpeed = 0.5;
controls.enableZoom = true;
controls.enablePan = false;

// 🌍 5. Load Earth Textures
const textureLoader = new THREE.TextureLoader();
const earthTexture = textureLoader.load("textures/earth_color.jpg");
const bumpMap = textureLoader.load("textures/earth_bump.jpg");
const specularMap = textureLoader.load("textures/earth_specular.jpg");

// 🏔️ 6. Create Earth Sphere
const earthGeometry = new THREE.SphereGeometry(1, 512, 512);
const earthMaterial = new THREE.MeshPhongMaterial({
    map: earthTexture,
    bumpMap: bumpMap,
    bumpScale: 0.03,
    specularMap: specularMap,
    specular: new THREE.Color(0x333333),
    shininess: 5,
});
const earthMesh = new THREE.Mesh(earthGeometry, earthMaterial);
scene.add(earthMesh);

// ☀️ 7. Dynamic Lighting
const sunlight = new THREE.DirectionalLight(0xffffff, 1.5);
scene.add(sunlight);
const ambientLight = new THREE.AmbientLight(0x555555);
scene.add(ambientLight);

function updateLighting() {
    const time = Date.now() * 0.0001;  // Keep sun moving slowly

    const sunX = Math.sin(time) * 5;
    const sunZ = Math.cos(time) * 5;
    
    sunlight.position.set(sunX, 2, sunZ);
    sunlight.lookAt(earthMesh.position);
}


// ✨ 8. Add Stars (Galaxy Effect)
const starsGeometry = new THREE.BufferGeometry();
const starVertices = [];
for (let i = 0; i < 7000; i++) {  // Increase stars count moderately
    let distance = 2000 + Math.random() * 1500; // Keep them slightly farther
    let theta = Math.random() * Math.PI * 2;
    let phi = Math.acos((Math.random() * 2) - 1);
    
    let x = distance * Math.sin(phi) * Math.cos(theta);
    let y = distance * Math.sin(phi) * Math.sin(theta);
    let z = distance * Math.cos(phi);
    
    starVertices.push(x, y, z);
}

starsGeometry.setAttribute("position", new THREE.Float32BufferAttribute(starVertices, 3));
const starsMaterial = new THREE.PointsMaterial({ color: 0xffffff, size: 1 });
const stars = new THREE.Points(starsGeometry, starsMaterial);
scene.add(stars);

// 🌎 9. Load Country Borders from GeoJSON & RestCountries JSON
let countryBorders = [];
let restCountries = [];

Promise.all([
    fetch("data/countries.geojson").then(response => response.json()),
    fetch("data/restcountries.json").then(response => response.json())
])
    .then(([geoData, countryData]) => {
        countryBorders = geoData.features;
        restCountries = countryData;
        console.log("✅ GeoJSON & RestCountries Data Loaded.");
        addCountryBorders(); // ✅ Call function to draw borders
    })
    .catch(error => console.error("❌ Error loading data files:", error));

    function addCountryBorders() {
        console.log("🌍 Adding country borders...");
    
        const borderMaterial = new THREE.LineBasicMaterial({
            color: 0xbbbbbb, // Softer gray instead of pure white
            linewidth: 0.5,  // Reduce thickness
            transparent: true,
            opacity: 0.6     // Make it slightly transparent
        });
        const borderGroup = new THREE.Group(); // Group to hold all borders
        borderGroup.name = "country-borders";
    
        countryBorders.forEach(feature => {
            if (feature.geometry && (feature.geometry.type === "Polygon" || feature.geometry.type === "MultiPolygon")) {
                let borderGeometry = new THREE.BufferGeometry();
                let borderVertices = [];
    
                if (feature.geometry.type === "Polygon") {
                    feature.geometry.coordinates.forEach(polygon => {
                        polygon.forEach(([lon, lat]) => {
                            const { x, y, z } = latLonToXYZ(lat, lon, 1.002); // Slightly above the surface
                            borderVertices.push(x, y, z);
                        });
                    });
                } else if (feature.geometry.type === "MultiPolygon") {
                    feature.geometry.coordinates.forEach(multiPolygon => {
                        multiPolygon.forEach(polygon => {
                            polygon.forEach(([lon, lat]) => {
                                const { x, y, z } = latLonToXYZ(lat, lon, 1.002);
                                borderVertices.push(x, y, z);
                            });
                        });
                    });
                }
    
                borderGeometry.setAttribute("position", new THREE.Float32BufferAttribute(borderVertices, 3));
                const borderMesh = new THREE.LineSegments(borderGeometry, borderMaterial);
                borderGroup.add(borderMesh);
            }
        });
    
        scene.add(borderGroup);
        console.log("✅ Country borders added!");
    }

    function latLonToXYZ(lat, lon, radius = 1) {
        const phi = THREE.MathUtils.degToRad(lat - 90); // Convert latitude to spherical coordinates
        const theta = THREE.MathUtils.degToRad(180 - lon); // Convert longitude
    
        return {
            x: radius * Math.sin(phi) * Math.cos(theta),
            y: radius * Math.cos(phi),
            z: radius * Math.sin(phi) * Math.sin(theta)
        };
    }
    

// 📍 10. Place Pin on the Correct Country (From GeoJSON)
function placePin(countryName) {
    console.log(`🔎 Searching for country: ${countryName}`); // ✅ Debugging log

    if (!countryName) {
        console.error("❌ Error: countryName is undefined!");
        return;
    }

    // ❌ Remove existing pin
    const existingPin = scene.getObjectByName("country-pin");
    if (existingPin) {
        scene.remove(existingPin);
    }
    
    // ❌ Remove any existing highlighted regions
    const existingHighlight = scene.getObjectByName("highlight-region");
    if (existingHighlight) {
        scene.remove(existingHighlight);
    }

    // ✅ Reusing the highlighting logic for country lookup
    const geoCountry = countryBorders.find(feature => {
        const properties = feature.properties;
        return (
            (properties.ADMIN && properties.ADMIN.toLowerCase() === countryName.toLowerCase()) ||
            (properties.name && properties.name.toLowerCase() === countryName.toLowerCase()) ||
            (properties.sovereignt && properties.sovereignt.toLowerCase() === countryName.toLowerCase())
        );
    });

    if (!geoCountry) {
        console.log(`❌ Country not found in GeoJSON: ${countryName}`);
        return;
    }

    console.log(`✅ Country found: ${geoCountry.properties.ADMIN || geoCountry.properties.name}`);

    let lon, lat;

    // ✅ Extract coordinates using same logic as highlight function
    if (geoCountry.properties.centroid) {
        [lon, lat] = geoCountry.properties.centroid;
    } else if (
        geoCountry.geometry &&
        geoCountry.geometry.coordinates.length > 0 &&
        geoCountry.geometry.type === "Polygon"
    ) {
        [lon, lat] = geoCountry.geometry.coordinates[0][0]; // First coordinate of the main polygon
    } else if (
        geoCountry.geometry &&
        geoCountry.geometry.coordinates.length > 0 &&
        geoCountry.geometry.type === "MultiPolygon"
    ) {
        [lon, lat] = geoCountry.geometry.coordinates[0][0][0]; // First coordinate of the first polygon
    } else {
        console.log(`⚠️ No valid coordinates found for ${countryName}`);
        return;
    }

    console.log(`📍 Correcting placement for ${countryName} - lat: ${lat}, lon: ${lon}`);

    // ✅ Same coordinate transformation logic as highlight function
    const radius = 1.02; // Slightly above Earth's surface
    const phi = THREE.MathUtils.degToRad(lat - 90); // Convert latitude to radians
    const theta = THREE.MathUtils.degToRad(180 - lon); // ✅ FIXED: Longitude correction

    const x = radius * Math.sin(phi) * Math.cos(theta);
    const y = radius * Math.cos(phi);
    const z = radius * Math.sin(phi) * Math.sin(theta);

    console.log(`📍 Placing pin at x: ${x}, y: ${y}, z: ${z}`);

    // ✅ Create and place the pin
    const pinGeometry = new THREE.ConeGeometry(0.03, 0.1, 16);
    const pinMaterial = new THREE.MeshBasicMaterial({ color: 0xff0000 });
    const pinMesh = new THREE.Mesh(pinGeometry, pinMaterial);

    pinMesh.position.set(x, y, z);
    pinMesh.lookAt(0, 0, 0);
    pinMesh.name = "country-pin";

    scene.add(pinMesh);

    console.log(`📍 Pin successfully dropped at ${countryName}`);
}


// 🌍 11. Highlight Countries Speaking a Language (Using Local RestCountries Data)
function highlightRegion(language) {
    // ❌ Remove existing pin when highlighting regions
    const existingPin = scene.getObjectByName("country-pin");
    if (existingPin) {
        scene.remove(existingPin);
    }

    // ❌ Remove existing highlights before adding new ones
    if (scene.getObjectByName("highlight-region")) {
        scene.remove(scene.getObjectByName("highlight-region"));
    }

    console.log(`🔎 Searching for language: ${language}`);

    if (!language) {
        console.error("❌ Error: Language is undefined!");
        return;
    }

    // ✅ Convert input language to lowercase for case-insensitive matching
    const lowerCaseLanguage = language.toLowerCase();

    // ✅ Ensure all possible spellings of the language are matched
    const matchingCountries = restCountries.filter(country => 
        country.languages && Object.values(country.languages)
            .map(lang => lang.toLowerCase()) // Convert all language names to lowercase
            .includes(lowerCaseLanguage) // Match the input search
    );

    if (matchingCountries.length === 0) {
        console.log(`❌ No countries found for language: ${language}`);
        return;
    }

    console.log(`🌍 Highlighting ${matchingCountries.length} countries for language: ${language}`);

    const regionGroup = new THREE.Group();
    regionGroup.name = "highlight-region";

    matchingCountries.forEach(country => {
        console.log(`🔎 Searching in GeoJSON for country: ${country.name.common}`);

        // ✅ Match country names correctly from GeoJSON
        const geoCountry = countryBorders.find(feature => {
            const properties = feature.properties;
            return (
                (properties.ADMIN && properties.ADMIN.toLowerCase() === country.name.common.toLowerCase()) ||
                (properties.name && properties.name.toLowerCase() === country.name.common.toLowerCase()) ||
                (properties.sovereignt && properties.sovereignt.toLowerCase() === country.name.common.toLowerCase())
            );
        });

        if (!geoCountry) {
            console.log(`❌ Country not found in GeoJSON: ${country.name.common}`);
            return;
        }

        console.log(`✅ Country found: ${geoCountry.properties.ADMIN || geoCountry.properties.name}`);

        let lon, lat;

        // ✅ Correctly extract coordinates
        if (geoCountry.properties.centroid) {
            [lon, lat] = geoCountry.properties.centroid;
        } else if (
            geoCountry.geometry &&
            geoCountry.geometry.coordinates.length > 0 &&
            geoCountry.geometry.type === "Polygon"
        ) {
            [lon, lat] = geoCountry.geometry.coordinates[0][0]; // First coordinate of the main polygon
        } else if (
            geoCountry.geometry &&
            geoCountry.geometry.coordinates.length > 0 &&
            geoCountry.geometry.type === "MultiPolygon"
        ) {
            [lon, lat] = geoCountry.geometry.coordinates[0][0][0]; // First coordinate of the first polygon
        } else {
            console.log(`⚠️ No valid coordinates found for ${country.name.common}`);
            return;
        }

        console.log(`📍 Correcting placement for ${country.name.common} - lat: ${lat}, lon: ${lon}`);

        const radius = 1.01; // Slightly above the Earth's surface
        const phi = THREE.MathUtils.degToRad(lat - 90); // Convert latitude to radians
        const theta = THREE.MathUtils.degToRad(180 - lon); // ✅ FIXED: Longitude correction

        const x = radius * Math.sin(phi) * Math.cos(theta);
        const y = radius * Math.cos(phi);
        const z = radius * Math.sin(phi) * Math.sin(theta);

        console.log(`🌍 Placing marker at x: ${x}, y: ${y}, z: ${z}`);

        const markerGeometry = new THREE.SphereGeometry(0.03, 16, 16);
        const markerMaterial = new THREE.MeshBasicMaterial({ color: 0x00ff00, transparent: true, opacity: 0.7 });
        const markerMesh = new THREE.Mesh(markerGeometry, markerMaterial);

        markerMesh.position.set(x, y, z);

        regionGroup.add(markerMesh);
    });

    scene.add(regionGroup);
}


// 🔍 12. Search Handling with Fuzzy Matching
document.getElementById("search-btn").addEventListener("click", () => {
    const query = document.getElementById("search-box").value.trim().toLowerCase();
    if (!query) {
        console.log("🚨 No query entered!");
        return;
    }

    console.log(`🔎 Searching for: ${query}`);

    // ✅ Check if input is a country
    const countryData = countryBorders.find(feature => {
        const properties = feature.properties;
        return (
            (properties.ADMIN && properties.ADMIN.toLowerCase() === query) ||
            (properties.name && properties.name.toLowerCase() === query) ||
            (properties.sovereignt && properties.sovereignt.toLowerCase() === query) ||
            (properties.geounit && properties.geounit.toLowerCase() === query) ||
            (properties.subunit && properties.subunit.toLowerCase() === query)
        );
    });
    
    if (countryData) {
        console.log(`✅ Country found in GeoJSON: ${countryData.properties.name}`);
        placePin(countryData.properties.name);
        return;
    } else {
        console.log(`❌ No country found for query: ${query}`);
    }

    // ✅ Check if input is a language
    const matchingCountries = restCountries.filter(country =>
        country.languages && Object.values(country.languages).some(lang => lang.toLowerCase() === query)
    );

    if (matchingCountries.length > 0) {
        console.log(`✅ Language found: ${query}, highlighting regions`);
        highlightRegion(query);
        return;
    }

    // ✅ Fuzzy search as fallback
    console.log(`❓ No exact match, trying fuzzy search for: ${query}`);
    suggestClosestMatch(query);
});

// 🔍 Suggest Closest Match (Fuzzy Search)
function suggestClosestMatch(input) {
    let lowerInput = input.toLowerCase();

    let countryNames = restCountries.flatMap(c => 
        [c.name.common.toLowerCase(), c.name.official.toLowerCase(), ...(c.altSpellings || []).map(a => a.toLowerCase())]
    );

    let languageNames = [];
    restCountries.forEach(country => {
        if (country.languages) {
            Object.values(country.languages).forEach(lang => {
                if (!languageNames.includes(lang.toLowerCase())) {
                    languageNames.push(lang.toLowerCase());
                }
            });
        }
    });

    let allMatches = [...countryNames, ...languageNames];

    // ✅ FIX: If input already exists in dataset, don't suggest anything
    if (allMatches.includes(lowerInput)) {
        console.log(`✅ Exact match found: ${input}`);
        return;
    }

    let closestMatch = findClosestMatch(lowerInput, allMatches);

    if (closestMatch) {
        console.log(`❗ Did you mean: ${closestMatch}?`);
        document.getElementById("search-box").value = closestMatch;
    }
}

// 📏 Find the Closest Match Using Levenshtein Distance
function findClosestMatch(input, possibleMatches) {
    let minDistance = Infinity;
    let bestMatch = null;

    for (let match of possibleMatches) {
        let distance = levenshteinDistance(input, match);
        if (distance < minDistance && distance <= 3) { // Adjust threshold as needed
            minDistance = distance;
            bestMatch = match;
        }
    }

    return bestMatch;
}

// 📏 Compute Levenshtein Distance Between Two Strings
function levenshteinDistance(a, b) {
    const matrix = Array.from(Array(a.length + 1), () => Array(b.length + 1).fill(0));

    for (let i = 0; i <= a.length; i++) matrix[i][0] = i;
    for (let j = 0; j <= b.length; j++) matrix[0][j] = j;

    for (let i = 1; i <= a.length; i++) {
        for (let j = 1; j <= b.length; j++) {
            const cost = a[i - 1] === b[j - 1] ? 0 : 1;
            matrix[i][j] = Math.min(
                matrix[i - 1][j] + 1,     // Deletion
                matrix[i][j - 1] + 1,     // Insertion
                matrix[i - 1][j - 1] + cost // Substitution
            );
        }
    }

    return matrix[a.length][b.length];
}


// 🖱️ 13. Click Detection for Info Box on Hover
document.addEventListener("click", (event) => {
    const mouse = new THREE.Vector2(
        (event.clientX / window.innerWidth) * 2 - 1,
        -(event.clientY / window.innerHeight) * 2 + 1
    );

    const raycaster = new THREE.Raycaster();
    raycaster.setFromCamera(mouse, camera);
    const intersects = raycaster.intersectObject(earthMesh);

    if (intersects.length > 0) {
        console.log("🌍 Click detected on Earth!");

        const point = intersects[0].point;
        const latLon = convertToLatLon(point); // Convert click position to latitude/longitude
        console.log(`📍 Clicked coordinates -> Lat: ${latLon.lat}, Lon: ${latLon.lon}`);

        const country = getCountryFromLatLon(latLon.lat, latLon.lon);

        if (country) {
            console.log(`✅ Country detected: ${country}`);
            showCountryInfo(country);
        } else {
            console.log("❌ No country found for:", latLon.lat, latLon.lon);
            hideCountryInfo();
        }
    } else {
        hideCountryInfo(); // Hide the info card when clicking outside
    }
});



// 📍 14. Convert 3D Point to Lat/Lon
function convertToLatLon(vector) {
    const radius = 1;
    const lat = Math.asin(vector.y / radius) * (180 / Math.PI);
    let lon = -Math.atan2(vector.z, vector.x) * (180 / Math.PI); 

    if (lon < -180) lon += 360;
    if (lon > 180) lon -= 360;

    return { lat: parseFloat(lat.toFixed(5)), lon: parseFloat(lon.toFixed(5)) };
}

// 🌍 15. Find Country from Lat/Lon
function getCountryFromLatLon(lat, lon) {
    for (const feature of countryBorders) {
        const countryName = feature.properties.ADMIN || 
                            feature.properties.name || 
                            feature.properties.name_en || 
                            feature.properties.sovereignt || 
                            feature.properties.admin;

        if (!countryName) continue;

        const geometry = feature.geometry;

        if (geometry.type === "Polygon") {
            for (const ring of geometry.coordinates) {
                if (isPointInPolygon([lon, lat], ring)) return countryName;
            }
        } else if (geometry.type === "MultiPolygon") {
            for (const polygon of geometry.coordinates) {
                for (const ring of polygon) {
                    if (isPointInPolygon([lon, lat], ring)) return countryName;
                }
            }
        }
    }

    return null;
}

// ✅ 16. Point-in-Polygon Check
function isPointInPolygon(point, polygon) {
    let [x, y] = point;
    let inside = false;

    for (let i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
        let xi = polygon[i][0], yi = polygon[i][1];
        let xj = polygon[j][0], yj = polygon[j][1];

        let intersect = ((yi > y) !== (yj > y)) &&
                        (x < (xj - xi) * (y - yi) / (yj - yi) + xi);
        if (intersect) inside = !inside;
    }

    return inside;
}
// function startPractice(language) {
//     // You can also pass the language via query string if needed
//     window.location.href = `avatar.html?lang=${encodeURIComponent(language)}`;
// }

// 🏛️ 17. Show & Hide Country Info
async function showCountryInfo(countryName) {
    const infoBox = document.getElementById("country-info");
    infoBox.style.display = "block";  // ✅ Show it when a country is clicked

    try {
        const response = await fetch(`https://restcountries.com/v3.1/name/${countryName}?fullText=true`);
        const data = await response.json();
        if (!data || data.length === 0) throw new Error("Country not found");

        const country = data[0];
        const flagURL = country.flags?.svg || "";
        const population = country.population?.toLocaleString() || "Unknown";
        const language = country.languages ? Object.values(country.languages)[0] : "Unknown";
        const region = country.region || "Unknown";

        infoBox.innerHTML = `
            <h2>${countryName}</h2>
            <img src="${flagURL}" alt="Flag of ${countryName}">
            <p><b>Region:</b> ${region}</p>
            <p><b>Population:</b> ${population}</p>
            <p><b>Language:</b> ${language}</p>
<button onclick="window.location.href='avatar.html?lang=${encodeURIComponent(language)}'">Practice ${language}</button>
        `;

        infoBox.classList.add("show");

    } catch (error) {
        console.error("❌ Error:", error.message);
    }
}

function hideCountryInfo() {
    const infoBox = document.getElementById("country-info");
    infoBox.style.display = "none";  // ✅ Fully remove it from the page
}


// 🔄 18. Animate
function animate() {
    requestAnimationFrame(animate);
    controls.update();
    updateLighting();
    renderer.render(scene, camera);
}

// 🚀 Start Animation
animate();

document.getElementById("clear-btn").addEventListener("click", () => {
    // 🗑️ Remove country pin safely
    const existingPin = scene.getObjectByName("country-pin");
    if (existingPin) {
        scene.remove(existingPin);
    }

    // 🗑️ Remove highlighted regions safely
    const existingHighlight = scene.getObjectByName("highlight-region");
    if (existingHighlight) {
        scene.remove(existingHighlight);
    }

    // 🗑️ Clear the search box
    document.getElementById("search-box").value = "";

    // 🗑️ Hide the "X" clear button
    document.getElementById("clear-btn").style.display = "none";

    // 🗑️ Hide the country info panel
    hideCountryInfo();

    console.log("🗑️ Cleared search box, pins, highlights, and reset interactions.");
});
