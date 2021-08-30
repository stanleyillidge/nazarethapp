// ignore_for_file: avoid_print

import 'package:data_table_2/paginated_data_table_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nazarethapp/widgets/data_source.dart';

class ListaEstudiantes extends StatefulWidget {
  const ListaEstudiantes({Key? key}) : super(key: key);

  @override
  _ListaEstudiantesState createState() => _ListaEstudiantesState();
}

class _ListaEstudiantesState extends State<ListaEstudiantes> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  bool _sortAscending = true;
  int? _sortColumnIndex;
  late DessertDataSource _dessertsDataSource;
  bool _initialized = false;
  PaginatorController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _dessertsDataSource = DessertDataSource(context);
      _controller = PaginatorController();
      _initialized = true;
    }
  }

  void sort<T>(
    Comparable<T> Function(Dessert d) getField,
    int columnIndex,
    bool ascending,
  ) {
    _dessertsDataSource.sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  void dispose() {
    _dessertsDataSource.dispose();
    super.dispose();
  }

  List<DataColumn> get _columns {
    return [
      DataColumn(
        label: const Text('Desert'),
        onSort: (columnIndex, ascending) =>
            sort<String>((d) => d.name, columnIndex, ascending),
      ),
      DataColumn(
        label: const Text('Calories'),
        numeric: true,
        onSort: (columnIndex, ascending) =>
            sort<num>((d) => d.calories, columnIndex, ascending),
      ),
      DataColumn(
        label: const Text('Fat (gm)'),
        numeric: true,
        onSort: (columnIndex, ascending) =>
            sort<num>((d) => d.fat, columnIndex, ascending),
      ),
      DataColumn(
        label: const Text('Carbs (gm)'),
        numeric: true,
        onSort: (columnIndex, ascending) =>
            sort<num>((d) => d.carbs, columnIndex, ascending),
      ),
      DataColumn(
        label: const Text('Protein (gm)'),
        numeric: true,
        onSort: (columnIndex, ascending) =>
            sort<num>((d) => d.protein, columnIndex, ascending),
      ),
      DataColumn(
        label: const Text('Sodium (mg)'),
        numeric: true,
        onSort: (columnIndex, ascending) =>
            sort<num>((d) => d.sodium, columnIndex, ascending),
      ),
      DataColumn(
        label: const Text('Calcium (%)'),
        numeric: true,
        onSort: (columnIndex, ascending) =>
            sort<num>((d) => d.calcium, columnIndex, ascending),
      ),
      DataColumn(
        label: const Text('Iron (%)'),
        numeric: true,
        onSort: (columnIndex, ascending) =>
            sort<num>((d) => d.iron, columnIndex, ascending),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomCenter, children: [
      PaginatedDataTable2(
        horizontalMargin: 20,
        checkboxHorizontalMargin: 0,
        columnSpacing: 0,
        wrapInCard: false,
        header:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Campeones'),
          if (kDebugMode && getCurrentRouteOption(context) == custPager)
            Row(children: [
              OutlinedButton(
                  onPressed: () => _controller!.goToPageWithRow(25),
                  child: const Text('Go to row 25')),
              OutlinedButton(
                  onPressed: () => _controller!.goToRow(5),
                  child: const Text('Go to row 5'))
            ]),
          if (getCurrentRouteOption(context) == custPager &&
              _controller != null)
            _PageNumber(controller: _controller!)
        ]),
        rowsPerPage: _rowsPerPage,
        autoRowsToHeight: getCurrentRouteOption(context) == autoRows,
        minWidth: 800,
        fit: FlexFit.tight,
        border: const TableBorder(
            // top: const BorderSide(color: Colors.black),
            // bottom: BorderSide(color: Colors.grey[300]!),
            // left: BorderSide(color: Colors.grey[300]!),
            // right: BorderSide(color: Colors.grey[300]!),
            // verticalInside: BorderSide(color: Colors.grey[300]!),
            // horizontalInside: const BorderSide(color: Colors.grey, width: 1),
            ),
        onRowsPerPageChanged: (value) {
          // No need to wrap into setState, it will be called inside the widget
          // and trigger rebuild
          //setState(() {
          _rowsPerPage = value!;
          print(_rowsPerPage);
          //});
        },
        initialFirstRowIndex: 0,
        onPageChanged: (rowIndex) {
          print(rowIndex / _rowsPerPage);
        },
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _sortAscending,
        onSelectAll: _dessertsDataSource.selectAll,
        controller:
            getCurrentRouteOption(context) == custPager ? _controller : null,
        hidePaginator: getCurrentRouteOption(context) == custPager,
        columns: _columns,
        empty: Center(
            child: Container(
                padding: const EdgeInsets.all(20),
                color: Colors.grey[200],
                child: const Text('No data'))),
        source: getCurrentRouteOption(context) == noData
            ? DessertDataSource.empty(context)
            : _dessertsDataSource,
      ),
      if (getCurrentRouteOption(context) == custPager)
        Positioned(bottom: 16, child: _CustomPager(_controller!))
    ]);
  }
}

class _PageNumber extends StatefulWidget {
  const _PageNumber({
    required PaginatorController controller,
  }) : _controller = controller;

  final PaginatorController _controller;

  @override
  _PageNumberState createState() => _PageNumberState();
}

class _PageNumberState extends State<_PageNumber> {
  @override
  void initState() {
    super.initState();
    widget._controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(widget._controller.isAttached
        ? 'Page: ${1 + ((widget._controller.currentRowIndex + 1) / widget._controller.rowsPerPage).floor()} of '
            '${(widget._controller.rowCount / widget._controller.rowsPerPage).ceil()}'
        : 'Page: x of y');
  }
}

class _CustomPager extends StatefulWidget {
  const _CustomPager(this.controller);

  final PaginatorController controller;

  @override
  _CustomPagerState createState() => _CustomPagerState();
}

class _CustomPagerState extends State<_CustomPager> {
  static const List<int> _availableSizes = [3, 5, 10, 20];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Theme(
          data: Theme.of(context).copyWith(
              iconTheme: const IconThemeData(color: Colors.white),
              textTheme:
                  const TextTheme(subtitle1: TextStyle(color: Colors.white))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () => widget.controller.goToFirstPage(),
                  icon: const Icon(Icons.skip_previous)),
              IconButton(
                  onPressed: () => widget.controller.goToPreviousPage(),
                  icon: const Icon(Icons.chevron_left_sharp)),
              DropdownButton<int>(
                  onChanged: (v) => widget.controller.setRowsPerPage(v!),
                  value: _availableSizes.contains(widget.controller.rowsPerPage)
                      ? widget.controller.rowsPerPage
                      : _availableSizes[0],
                  dropdownColor: Colors.grey[800],
                  items: _availableSizes
                      .map((s) => DropdownMenuItem<int>(
                            child: Text(s.toString()),
                            value: s,
                          ))
                      .toList()),
              IconButton(
                  onPressed: () => widget.controller.goToNextPage(),
                  icon: const Icon(Icons.chevron_right_sharp)),
              IconButton(
                  onPressed: () => widget.controller.goToLastPage(),
                  icon: const Icon(Icons.skip_next))
            ],
          )),
      width: 220,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(100),
            blurRadius: 4,
            offset: const Offset(4, 8), // Shadow position
          ),
        ],
      ),
    );
  }
}

String getCurrentRouteOption(BuildContext context) {
  var isEmpty = ModalRoute.of(context) != null &&
          ModalRoute.of(context)!.settings.arguments != null &&
          ModalRoute.of(context)!.settings.arguments is String
      ? ModalRoute.of(context)!.settings.arguments as String
      : '';

  return isEmpty;
}

const hasData = 'Default';
const noData = 'No data';
const autoRows = 'Auto rows';
const showBorders = 'Borders';
const custPager = 'Custom pager';

const Map<String, List<String>> routeOptions = {
  '/datatable2': [hasData, noData, showBorders],
  '/paginated2': [hasData, noData, autoRows, custPager],
};

List<String>? getOptionsForRoute(String route) {
  if (!routeOptions.containsKey(route)) {
    return null;
  }

  return routeOptions[route];
}
