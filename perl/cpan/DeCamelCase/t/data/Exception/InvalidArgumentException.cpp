/// \file
/// \brief The InvalidArgumentException class definitions.
///

#include "InvalidArgumentException.h"

using namespace std;

/// \brief Constructor for InvalidArgumentException.
InvalidArgumentException::InvalidArgumentException(const string &what_arg ///< The name of the argument that caused the problem (not ideal because the creation of the string could throw)
                                                   ) : invalid_argument(what_arg) {
}

/// \brief Virtual empty destructor for InvalidArgumentException.
InvalidArgumentException::~InvalidArgumentException() throw () {
}
