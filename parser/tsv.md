# tsv

The `tsv` parser plugin parses the TSV format.

## Parameters

See [Parse Section Configurations](../configuration/parse-section.md).

### `keys`

| type | default | version |
| :--- | :--- | :--- |
| array of string | required parameter | 0.14.9 |

The array of names for fields on each line.

### `delimiter`

| type | default | version |
| :--- | :--- | :--- |
| string | `\t` | 0.14.0 |

The delimiter \(character or string\) separating TSV values.

## Example

With this configuration:

```text
<parse>
  @type tsv
  keys time,host,req_id,user
  time_key time
</parse>
```

This incoming event:

```text
2013/02/28 12:00:00\t192.168.0.1\t111\t-
```

is parsed as:

```text
time:
1362020400 (2013/02/28/ 12:00:00)

record:
{
  "host"   : "192.168.0.1",
  "req_id" : "111",
  "user"   : "-"
}
```

If you set `null_value_pattern '-'` in the configuration, `user` field becomes `nil` instead of `"-"`.

{% include "../.gitbook/assets/footer.txt" %}
