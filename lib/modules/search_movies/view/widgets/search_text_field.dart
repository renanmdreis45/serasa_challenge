import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:serasa_challenge/core/constants/app_images.dart';

import '../../viewmodel/bloc/movie_search_bloc.dart';
import '../../viewmodel/bloc/movie_search_event.dart';

class SearchTextField extends StatefulWidget {
  final TextEditingController controller;

  const SearchTextField({super.key, required this.controller});

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {
        _hasText = widget.controller.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: 'Buscar filmes...',
        suffixIcon: _hasText
            ? GestureDetector(
                onTap: () {
                  widget.controller.clear();
                  context.read<MovieSearchBloc>().add(ClearSearchResults());
                },
                child: Container(
                  width: 48,
                  height: 48,
                  padding: const EdgeInsets.all(12.0),
                  child: SvgPicture.asset(
                    AppImages.closeIcon,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      Colors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              )
            : Container(
                width: 48,
                height: 48,
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(
                  AppImages.searchIcon,
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
              ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
      ),
      onSubmitted: (query) {
        if (query.trim().isNotEmpty) {
          context.read<MovieSearchBloc>().add(
            SearchMovies(query: query.trim()),
          );
        }
      },
    );
  }
}
