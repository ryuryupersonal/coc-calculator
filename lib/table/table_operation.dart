import 'package:coc_calculater/model/defense_model.dart';
import 'package:coc_calculater/util.dart';
import 'package:equatable/equatable.dart';

enum SortOrder {
  ascending,
  descending,
  noSort
}

typedef FilterFunction = List<DefenseModel> Function(List<DefenseModel>, FilterCache);
typedef SortFunction = List<DefenseModel> Function(List<DefenseModel>);

class TableOperation {
  final Map<String, FilterFunction> _filterOperations = {};
  SortFunction? _sortFunction;

  final FilterCache _cache;

  TableOperation(int cacheSize) : _cache = FilterCache(cacheSize);

  void addFilter(String key, FilterFunction operation) {
    _filterOperations[key] = operation;
  }

  void removeFilter(String key) {
    _filterOperations.remove(key);
  }

  void setSort(SortFunction operation) {
    _sortFunction = operation;
  }

  List<DefenseModel> apply(List<DefenseModel> source) {
    var result = List<DefenseModel>.from(source);

    for (FilterFunction operation in _filterOperations.values) {
      result = operation(result, _cache);
    }

    result = _sortFunction?.call(result) ?? result;

    return result;
  }
}

/// Wrapper class for all filter conditions.
/// 
/// Guarantees the same hashcode for the same Filter condition.
abstract class FilterCondition extends Equatable {
  const FilterCondition._();
}

class FilterConditionEquals<A> extends FilterCondition {
  final Set<A> values;

  const FilterConditionEquals({
    required this.values
  }) : super._();
  
  @override
  List<Object?> get props => [values];
}

/// Cache for filter conditions with size limit.
class FilterCache<V> {
  final int _maxSize;
  final Map<int, V> _cache = {};
  final List<int> _accessOrder = []; // Tracks access order for LRU eviction.

  /// Creates a cache with a specified maximum size.
  FilterCache(this._maxSize);

  /// Generates a key for the given filter condition.
  int _generateKey(FilterCondition condition) => condition.hashCode;

  /// Retrieves the cached value for the given filter condition.
  V? get(FilterCondition condition) {
    int key = _generateKey(condition);

    if (_cache.containsKey(key)) {
      // Update access order
      _accessOrder.remove(key);
      _accessOrder.add(key);
      return _cache[key];
    }

    return null;
  }

  /// Caches the result for the given filter condition.
  void set(FilterCondition condition, V result) {
    int key = _generateKey(condition);

    if (_cache.containsKey(key)) {
      // Update access order
      _accessOrder.remove(key);
    } else if (_cache.length >= _maxSize) {
      // Evict the least recently used item
      int oldestKey = _accessOrder.removeAt(0);
      _cache.remove(oldestKey);
    }

    // Add the new key-value pair
    _cache[key] = result;
    _accessOrder.add(key);
  }

  /// Clears the entire cache.
  void clear() {
    _cache.clear();
    _accessOrder.clear();
  }
}

SortFunction sortByHp(SortOrder order) {
  return (List<DefenseModel> source) {
    final result = List<DefenseModel>.from(source);

    if (order != SortOrder.noSort) {
      result.sort((a, b) {
        return (order == SortOrder.ascending) ? a.hp - b.hp : b.hp - a.hp;
      });
    }

    return result;
  };
}

FilterFunction filterByTh(FilterConditionEquals<int> condition) {
  return (List<DefenseModel> source, FilterCache cache) {
    var cachedResult = cache.get(condition);

    if (cachedResult != null) {
      return cachedResult;

    } else {
      final result = source.where((model) => hasCommon(condition.values, model.th.toSet())).toList();
      cache.set(condition, result);

      return result;
    }
  };
}

FilterFunction filterByDefense(FilterConditionEquals<String> condition) {
  return (List<DefenseModel> source, FilterCache cache) {
    var cachedResult = cache.get(condition);

    if (cachedResult != null) {
      return cachedResult;

    } else {
      final result = source.where((model) => condition.values.contains(model.defense)).toList();
      cache.set(condition, result);

      return result;
    }
  };
}