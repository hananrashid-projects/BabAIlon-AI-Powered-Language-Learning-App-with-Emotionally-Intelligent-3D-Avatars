// ThreeDPage.js
import React from 'react';
import { useHistory } from 'react-router-dom';

function ThreeDPage() {
  const history = useHistory();

  const handleGoBack = () => {
    history.push('/'); // Navigate back to the Home Page without reload
  };

  return (
    <div>
      <button onClick={handleGoBack}>&#8592; Go Back to Home</button>
      <h1>3D Page</h1>
    </div>
  );
}

export default ThreeDPage;
