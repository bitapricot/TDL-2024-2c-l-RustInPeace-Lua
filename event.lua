Event = {}
Event.__index = Event

function Event:new(handler, nextEvent)
    local event = {}
    setmetatable(event, Event)
    event.handler = handler  -- Callback del evento
    event.next = nextEvent or nil
    return event
end

function Event:handle(...)
    if self.handler then
        self.handler(...)
    end
end
