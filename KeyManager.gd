extends Node

signal keys_updated(current: int, needed: int)
signal escape_unlocked

const KEYS_NEEDED := 5

var deposited_keys := 0

func deposit_keys(amount: int) -> void:
	deposited_keys += amount
	deposited_keys = min(deposited_keys, KEYS_NEEDED)
	keys_updated.emit(deposited_keys, KEYS_NEEDED)
	if deposited_keys >= KEYS_NEEDED:
		escape_unlocked.emit()

func is_escape_ready() -> bool:
	return deposited_keys >= KEYS_NEEDED
