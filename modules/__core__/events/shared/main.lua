if IsDuplicityVersion() then

  onRequest('foo', function(client, a, b, c)
    print(a, b, b)
  end)

else

  SetTimeout(2000, function()
    request('foo', 'abc', 123, 'bar')
  end)

end
