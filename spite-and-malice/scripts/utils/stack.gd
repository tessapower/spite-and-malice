class_name Stack

var stack: Array = []

## Create a new stack with optional starting values. Values will be pushed on
## to the stack in reverse order.
func _init(values: Array = []) -> void:
    push_all(values)


# Push a value onto the stack.
func push(value):
    stack.append(value)


### Push all the given values. Values will be pushed on to the stack in reverse
func push_all(values: Array) -> void:
    values.reverse()
    for value in values:
        push(value)


func pop():
    return stack.pop_back() if !stack.is_empty() else null


func pop_all() -> Array:
    var items = stack.duplicate(true)
    clear()

    return items


func peek() -> Variant:
    return stack[-1] if !stack.is_empty() else null


func is_empty() -> bool:
    return stack.is_empty()


func clear() -> void:
    stack.clear()


func size() -> int:
    return stack.size()
