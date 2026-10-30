import { useEffect, useState } from "react";

const STORAGE_KEY = "oceangram_reactions_v1";
const listeners = new Set();

function getStoredReactions() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    return raw ? JSON.parse(raw) : {};
  } catch {
    return {};
  }
}

let reactionsCache = getStoredReactions();

function notify() {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(reactionsCache));
  } catch (_) {}
  listeners.forEach((listener) => listener(reactionsCache));
}

export function getMessageReactions(messageId) {
  if (!messageId) return [];
  const map = reactionsCache[messageId] || {};
  return Object.entries(map).map(([emoji, count]) => ({ emoji, count }));
}

export function toggleMessageReaction(messageId, emoji) {
  if (!messageId || !emoji) return;
  const current = reactionsCache[messageId] || {};
  const currentCount = current[emoji] || 0;

  if (currentCount > 0) {
    // If already reacted, toggle off or decrement
    const nextCount = currentCount - 1;
    if (nextCount <= 0) {
      delete current[emoji];
    } else {
      current[emoji] = nextCount;
    }
  } else {
    // Add reaction
    current[emoji] = 1;
  }

  reactionsCache = {
    ...reactionsCache,
    [messageId]: { ...current },
  };

  notify();
}

export function useMessageReactions(messageId) {
  const [reactions, setReactions] = useState(() => getMessageReactions(messageId));

  useEffect(() => {
    const update = () => setReactions(getMessageReactions(messageId));
    listeners.add(update);
    return () => listeners.delete(update);
  }, [messageId]);

  return reactions;
}
