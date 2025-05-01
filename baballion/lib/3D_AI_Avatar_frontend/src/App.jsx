import React, { useEffect, useState } from "react";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import { Canvas } from "@react-three/fiber";
import { Loader } from "@react-three/drei";
import { Leva } from "leva";

import { Experience as Experience1 } from "./components/Experience";
import { Experience as Experience2 } from "./components/Experience2";
import { Experience as Experience3 } from "./components/Experience3";
import { UI } from "./components/UI";
import { ChatProvider } from "./hooks/useChat";

function HomeExperience() {
  const [avatarId, setAvatarId] = useState(0);
  const [experienceVersion, setExperienceVersion] = useState(() => {
    return localStorage.getItem("experienceVersion") || "1";
  });

  const getCharacterName = (version) => {
    switch (version) {
      case "1":
        return "lolwa";
      case "2":
        return "kieko";
      case "3":
        return "rami";
      default:
        return "rami";
    }
  };

  const character = getCharacterName(experienceVersion);

  const ExperienceComponent =
    experienceVersion === "1"
      ? Experience1
      : experienceVersion === "2"
      ? Experience2
      : Experience3;

  const handleToggle = () => {
    const next =
      experienceVersion === "1"
        ? "2"
        : experienceVersion === "2"
        ? "3"
        : "1";
    localStorage.setItem("experienceVersion", next);
    window.location.reload();
  };

  return (
    <ChatProvider character={character}>
      <Loader />
      <Leva hidden />
      <UI setAvatarId={setAvatarId} />

      <div
        style={{
          position: "absolute",
          top: 20,
          right: 20,
          zIndex: 1000,
          background: "white",
          padding: "12px",
          borderRadius: "10px",
          fontFamily: "monospace",
          boxShadow: "0 4px 10px rgba(0,0,0,0.2)",
        }}
      >
        <button
          onClick={handleToggle}
          style={{
            background:
              experienceVersion === "1"
                ? "#f44336"
                : experienceVersion === "2"
                ? "#4CAF50"
                : "#2196F3",
            color: "white",
            border: "none",
            padding: "8px 14px",
            fontWeight: "bold",
            borderRadius: "6px",
            cursor: "pointer",
          }}
        >
          Experience: {experienceVersion}
        </button>
      </div>

      <Canvas shadows camera={{ position: [0, 0, 1], fov: 30 }}>
        <ExperienceComponent avatarId={avatarId} />
      </Canvas>
    </ChatProvider>
  );
}

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<HomeExperience />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
