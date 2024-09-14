import 'package:action_chain/constants/global_keys.dart';
import 'package:action_chain/view/chain_wall/chain_detail_page.dart';
import 'package:action_chain/model/ac_category.dart';
import 'package:action_chain/model/ac_chain.dart';
import 'package:flutter/material.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ChainCard extends StatelessWidget {
  final bool isSavedChain;
  final ACCategory categoryOfThisChain;
  final int indexOfThisChainInChains;
  final ACChain chainOfThisCard;
  const ChainCard({
    Key? key,
    required this.isSavedChain,
    required this.categoryOfThisChain,
    required this.indexOfThisChainInChains,
    required this.chainOfThisCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          showCupertinoModalBottomSheet(
              context: context,
              enableDrag: false,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: Colors.white,
              builder: (context) {
                return ChainDetailPage(
                  key: chainDetailPageKey,
                  isSavedChain: isSavedChain,
                  categoryOfThisChain: categoryOfThisChain,
                  indexOfThisChainInChains: indexOfThisChainInChains,
                );
              });
        },
        radius: 15,
        child: ListTile(
          title: Text(
            chainOfThisCard.title,
            style: TextStyle(
                fontSize: 14.5,
                color: Colors.black.withOpacity(0.75),
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
