import { useState, useEffect } from "react";

const PINNED_CHATS_KEY = "oceangram-pinned-chats";
const listeners = new Set();

export function getPinnedChatIds() {
  if (typeof window === "undefined") return [];
  try {
    const raw = localStorage.getItem(PINNED_CHATS_KEY);
    return raw ? JSON.parse(raw) : [];
  } catch {
    return [];
  }
}

export function isChatPinned(chatId) {
  if (!chatId) return false;
  const list = getPinnedChatIds();
  return list.includes(String(chatId));
}

export function togglePinChat(chatId) {
  if (!chatId) return;
  const strId = String(chatId);
  let list = getPinnedChatIds();
  if (list.includes(strId)) {
    list = list.filter((id) => id !== strId);
  } else {
    list = [strId, ...list];
  }
  try {
    localStorage.setItem(PINNED_CHATS_KEY, JSON.stringify(list));
  } catch {}
  listeners.forEach((fn) => fn(list));
}

export function usePinnedChats() {
  const [pinnedIds, setPinnedIds] = useState(getPinnedChatIds);

  useEffect(() => {
    const handler = (next) => setPinnedIds([...next]);
    listeners.add(handler);
    return () => listeners.delete(handler);
  }, []);

  return {
    pinnedIds,
    isChatPinned: (id) => pinnedIds.includes(String(id)),
    togglePinChat,
  };
}
