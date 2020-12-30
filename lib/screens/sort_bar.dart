import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:reservation_manager/backend/bloc/Data/Data_bloc.dart';
import 'package:reservation_manager/backend/constants.dart';

class SortButton extends StatelessWidget {
  const SortButton({
    Key key,
    @required String sortByText,
    @required String selectedCriteriaButtonText,
    @required DataBloc dataBloc,
  })  : _sortByText = sortByText ?? 'null',
        _selectedCriteriaButtonText = selectedCriteriaButtonText ?? sortByText,
        assert(dataBloc != null),
        _dataBloc = dataBloc,
        super(key: key);

  final String _sortByText;
  final String _selectedCriteriaButtonText;
  final DataBloc _dataBloc;

  @override
  Widget build(BuildContext context) {
    AppConstants appConstants = context.watch<AppConstants>();
    return Container(
      alignment: Alignment.bottomRight,
      height: 20,
      margin: EdgeInsets.symmetric(horizontal: 7),
      child: CupertinoButton(
        padding: EdgeInsets.all(5),
        color: appConstants.getForeGroundColor.shade800,
        disabledColor: Colors.teal[900],
        child: Text(
          _sortByText,
          style: TextStyle(color: Colors.white, fontSize: 10),
        ),
        onPressed: (_sortByText != _selectedCriteriaButtonText)
            ? () => _dataBloc.rebuildReservationsStream(filter: _sortByText)
            : null,
      ),
    );
  }
}

class SortBar extends StatelessWidget {
  const SortBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppConstants _appConstants = context.watch<AppConstants>();
    DataBloc dataBloc = context.watch<DataBloc>();
    bool isAscendingSort = true;
    String selectedCriteriaButtonText = 'Name';

    if (dataBloc.state is InDataState) {
      InDataState state = dataBloc.state;
      isAscendingSort = state.isAscending;
      selectedCriteriaButtonText = state.selectedCriteriaButtonText;
    }

    return Container(
      height: 30,
      margin: EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Sort By: ',
              style: TextStyle(
                color: _appConstants.getForeGroundColor,
              ),
            ),
          ),
          SortButton(
            sortByText: InDataState.sortedByName,
            dataBloc: dataBloc,
            selectedCriteriaButtonText: selectedCriteriaButtonText,
          ),
          SortButton(
            sortByText: InDataState.sortedByReservationTime,
            dataBloc: dataBloc,
            selectedCriteriaButtonText: selectedCriteriaButtonText,
          ),
          SortButton(
            sortByText: InDataState.sortedByMail,
            dataBloc: dataBloc,
            selectedCriteriaButtonText: selectedCriteriaButtonText,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => dataBloc.rebuildReservationsStream(
                  isAscending: !isAscendingSort,
                  filter: selectedCriteriaButtonText,
                ),
                icon: (isAscendingSort)
                    ? Icon(Icons.arrow_downward_rounded)
                    : Icon(Icons.arrow_upward_rounded),
                color: _appConstants.getForeGroundColor.shade800,
                iconSize: 18,
              ),
            ),
          )
        ],
      ),
    );
  }
}
