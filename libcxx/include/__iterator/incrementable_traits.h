// -*- C++ -*-
//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef _LIBCPP___ITERATOR_INCREMENTABLE_TRAITS_H
#define _LIBCPP___ITERATOR_INCREMENTABLE_TRAITS_H

#include <__config>
#include <__iterator/concepts.h>
#include <type_traits>

#if !defined(_LIBCPP_HAS_NO_PRAGMA_SYSTEM_HEADER)
#pragma GCC system_header
#endif

_LIBCPP_PUSH_MACROS
#include <__undef_macros>

_LIBCPP_BEGIN_NAMESPACE_STD

#if !defined(_LIBCPP_HAS_NO_RANGES)

// [incrementable.traits]
template<class> struct incrementable_traits {};

template<class _Tp>
requires is_object_v<_Tp>
struct incrementable_traits<_Tp*> {
  using difference_type = ptrdiff_t;
};

template<class _Ip>
struct incrementable_traits<const _Ip> : incrementable_traits<_Ip> {};

template<class _Tp>
concept __has_member_difference_type = requires { typename _Tp::difference_type; };

template<__has_member_difference_type _Tp>
struct incrementable_traits<_Tp> {
  using difference_type = typename _Tp::difference_type;
};

template<class _Tp>
concept __has_integral_minus =
  requires(const _Tp& __x, const _Tp& __y) {
    { __x - __y } -> integral;
  };

template<__has_integral_minus _Tp>
requires (!__has_member_difference_type<_Tp>)
struct incrementable_traits<_Tp> {
  using difference_type = make_signed_t<decltype(declval<_Tp>() - declval<_Tp>())>;
};

template <class>
struct iterator_traits;

// Let `RI` be `remove_­cvref_­t<I>`. The type `iter_­difference_­t<I>` denotes
// `incrementable_­traits<RI>::difference_­type` if `iterator_­traits<RI>` names a specialization
// generated from the primary template, and `iterator_­traits<RI>::difference_­type` otherwise.
template <class _Ip>
using iter_difference_t = typename conditional_t<__is_primary_template<iterator_traits<remove_cvref_t<_Ip> > >::value,
                                                 incrementable_traits<remove_cvref_t<_Ip> >,
                                                 iterator_traits<remove_cvref_t<_Ip> > >::difference_type;

#endif // !defined(_LIBCPP_HAS_NO_RANGES)

_LIBCPP_END_NAMESPACE_STD

_LIBCPP_POP_MACROS

#endif // _LIBCPP___ITERATOR_INCREMENTABLE_TRAITS_H
