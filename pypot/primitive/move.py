import json

from .primitive import LoopPrimitive


class Move(object):

    """ Simple class used to represent a movement.

    This class simply wraps a sequence of positions of specified motors. The sequence must be recorded at a predefined frequency. This move can be recorded through the :class:`~pypot.primitive.move.MoveRecorder` class and played thanks to a :class:`~pypot.primitive.move.MovePlayer`.

    """

    def __init__(self, freq):
        self._framerate = freq
        self._positions = []

    def __repr__(self):
        return '<Move framerate={} #keyframes={}>'.format(self.framerate,
                                                          len(self.positions()))

    def __getitem__(self, i):
        return self._positions[i]

    @property
    def framerate(self):
        return self._framerate

    def add_position(self, pos):
        """ Add a new position to the movement sequence.

        Each position is typically stored as a dict of (motor_name, motor_position).
        """
        self._positions.append(pos)

    def iterpositions(self):
        """ Returns an iterator on the stored positions. """
        return iter(self._positions)

    def positions(self):
        """ Returns a copy of the stored positions. """
        return list(self.iterpositions())

    def save(self, file):
        """ Saves the :class:`~pypot.primitive.move.Move` to a json file.

        .. note:: The format used to store the :class:`~pypot.primitive.move.Move` is extremely verbose and should be obviously optimized for long moves.
        """
        d = {
            'framerate': self.framerate,
            'positions': self.positions(),
        }
        json.dump(d, file, indent=2)

    @classmethod
    def load(cls, file):
        """ Loads a :class:`~pypot.primitive.move.Move` from a json file. """
        d = json.load(file)

        move = cls(d['framerate'])
        move._positions = d['positions']
        return move


class MoveRecorder(LoopPrimitive):

    """ Primitive used to record a :class:`~pypot.primitive.move.Move`.

    The recording can be :meth:`~pypot.primitive.primitive.Primitive.start` and :meth:`~pypot.primitive.primitive.Primitive.stop` by using the :class:`~pypot.primitive.primitive.LoopPrimitive` methods.

    .. note:: Re-starting the recording will create a new :class:`~pypot.primitive.move.Move` losing all the previously stored data.

    """

    def __init__(self, robot, freq, tracked_motors):
        LoopPrimitive.__init__(self, robot, freq)
        self.freq = freq

        self.tracked_motors = map(self.get_mockup_motor, tracked_motors)

    def setup(self):
        self._move = Move(self.freq)

    def update(self):
        position = dict([(m.name, m.present_position) for m in self.tracked_motors])
        self._move.add_position(position)

    @property
    def move(self):
        """ Returns the currently recorded :class:`~pypot.primitive.move.Move`. """
        return self._move

    def add_tracked_motors(self, tracked_motors):
        """Add new motors to the recording"""
        new_mockup_motors = map(self.get_mockup_motor, tracked_motors)
        self.tracked_motors = list(set(self.tracked_motors + new_mockup_motors))


class MovePlayer(LoopPrimitive):

    """ Primitive used to play a :class:`~pypot.primitive.move.Move`.

    The playing can be :meth:`~pypot.primitive.primitive.Primitive.start` and :meth:`~pypot.primitive.primitive.Primitive.stop` by using the :class:`~pypot.primitive.primitive.LoopPrimitive` methods.

    .. warning:: You should be careful that you primitive actually runs at the same speed that the move has been recorded. If the player can not run as fast as the framerate of the :class:`~pypot.primitive.move.Move`, it will be played slowly resulting in a slower version of your move.
    """

    # TODO : add position interpolation if framerate < Move.framerate
    def __init__(self, robot, move=None, speed=1.0):
        self.move = move
        self.speed = speed if speed != 0 and isinstance(speed, float) else 1.0
        framerate = self.move.framerate * self.speed if self.move is not None else self.speed * 50
        LoopPrimitive.__init__(self, robot, framerate)

    def setup(self):
        if self.move is None:
            raise AttributeError("Attribute move is not defined")
        self.period = 1.0 / (self.move.framerate * self.speed)
        self.positions = self.move.iterpositions()

    def update(self):
        try:
            position = self.positions.next()

            for m, v in position.iteritems():
                getattr(self.robot, m).goal_position = v

        except StopIteration:
            self.stop()

    # TO_CHECK
    # @property
    # def move(self):
    #     return self.move