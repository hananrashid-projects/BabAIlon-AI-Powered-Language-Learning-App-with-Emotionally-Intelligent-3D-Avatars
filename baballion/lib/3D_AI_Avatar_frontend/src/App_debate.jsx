import React from 'react'
import { ChatProvider } from './hooks/useChat'
import MinimalDebateUI from './components/MinimalDebateUI'

export default function App_debate() {
  return (
    <ChatProvider character="rami">
      <MinimalDebateUI />
    </ChatProvider>
  )
}
