tool
class_name UpgradesController
extends Node


const UNLOCKED_UPGRADE_SETTINGS_KEY_PREFIX := "unlocked_"

# Array<bool>
var _unlocked_upgrades := []
var _unlocked_count := 0

const UNLOCK_ENERGY_COSTS := [
    5000,
    8000,
    12000,
    17000,
    23000,
    30000,
    38000,
    47000,
    57000,
    68000,
    70000,
]

const UNLOCK_ENERGY_THRESHOLDS := []


func _init() -> void:
    var sum := 0
    UNLOCK_ENERGY_THRESHOLDS.resize(UNLOCK_ENERGY_COSTS.size())
    for i in UNLOCK_ENERGY_COSTS.size():
        sum += UNLOCK_ENERGY_COSTS[i]
        UNLOCK_ENERGY_THRESHOLDS[i] = sum


func load_unlocked_upgrades() -> void:
    _unlocked_upgrades.resize(Upgrade.VALUES.size())
    for upgrade in Upgrade.VALUES:
        var unlocked: bool = Sc.save_state.get_setting(
            UNLOCKED_UPGRADE_SETTINGS_KEY_PREFIX + Upgrade.get_string(upgrade),
            false)
        _unlocked_upgrades[upgrade] = unlocked
        if unlocked:
            _unlocked_count += 1


func set_unlocked(
        upgrade: int,
        unlocked := true) -> void:
    var was_unlocked: bool = _unlocked_upgrades[upgrade]
    if was_unlocked != unlocked:
        _unlocked_upgrades[upgrade] = unlocked
        Sc.save_state.set_setting(
            UNLOCKED_UPGRADE_SETTINGS_KEY_PREFIX + Upgrade.get_string(upgrade),
            unlocked)
        if unlocked:
            _unlocked_count += 1
        else:
            _unlocked_count -= 1


func get_unlocked(upgrade: int) -> bool:
    return _unlocked_upgrades[upgrade]


func get_next_upgrade_energy_threshold() -> int:
    if _unlocked_count > UNLOCK_ENERGY_THRESHOLDS.size() - 1:
        var last_cost: int = \
            UNLOCK_ENERGY_THRESHOLDS[UNLOCK_ENERGY_THRESHOLDS.size() - 1]
        var last_cost_diff: int = \
            last_cost - \
            UNLOCK_ENERGY_THRESHOLDS[UNLOCK_ENERGY_THRESHOLDS.size() - 2]
        var upgrades_count_past_end := \
            _unlocked_count - (UNLOCK_ENERGY_THRESHOLDS.size() - 1)
        return last_cost + \
            int(last_cost_diff * pow(1.1, upgrades_count_past_end))
    else:
        return UNLOCK_ENERGY_THRESHOLDS[_unlocked_count]


func get_remaining_energy_until_next_upgrade() -> int:
    return get_next_upgrade_energy_threshold() - Game.cumulative_energy
