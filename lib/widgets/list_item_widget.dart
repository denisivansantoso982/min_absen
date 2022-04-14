import 'package:flutter/material.dart';
import 'package:min_absen/templates/colour_template.dart';
import 'package:min_absen/templates/text_style_template.dart';

class ListItemWidget extends StatelessWidget {
  const ListItemWidget({Key? key, required this.name, this.status, this.pretend, this.home})
      : super(key: key);
  final String name;
  final bool? status;
  final String? pretend;
  final String? home;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColourTemplate.whiteColour,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            offset: const Offset(1, 1),
            color: Colors.black.withOpacity(.25),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: TextStyleTemplate.mediumGray(size: 14),
                ),
              ),
              ( status != null
                ? Text(
                  status! ? 'Aktif' : 'Nonaktif',
                  style: status!
                    ? TextStyleTemplate.regularPrimary(size: 12)
                    : TextStyleTemplate.regularNegative(size: 12),
                )
                : const SizedBox()),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          ((pretend != null)
              ? (Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      pretend!,
                      style: TextStyleTemplate.mediumPrimary(size: 14),
                    ),
                    ((home != null)
                        ? (Text(
                            home!,
                            style: TextStyleTemplate.mediumPrimary(size: 14),
                          ))
                        : const SizedBox()),
                  ],
                ))
              : const SizedBox()),
        ],
      ),
    );
  }
}
