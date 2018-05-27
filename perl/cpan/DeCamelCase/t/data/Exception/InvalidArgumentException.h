/// \file
/// \brief The InvalidArgumentException class header.
///

#ifndef INVALID_ARGUMENT_EXCEPTION_H
#define INVALID_ARGUMENT_EXCEPTION_H

#include <boost/exception/all.hpp>

class InvalidArgumentException : public boost::exception, public std::invalid_argument {
public:
	InvalidArgumentException(const std::string &);
	virtual ~InvalidArgumentException() throw ();
};

#endif
