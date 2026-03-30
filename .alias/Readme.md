*This project has been created by Florent Cretin.*
<!-- Ceci sont des commentaire pour avec mes font et mes icon personnaliser -->
<!-- 𝔸 𝔹 ℂ 𝔻 𝔼 𝔽 𝔾 ℍ 𝔾 𝕁 𝕂 𝕃 𝕄 ℕ 𝕆 ℙ ℚ ℝ 𝕊 𝕋 𝕌 𝕍 𝕎 𝕏 𝕐 ℤ -->
<!-- 𝕒 𝕓 𝕔 𝕕 𝕖 𝕗 𝕘 𝕙 𝕚 𝕛 𝕜 𝕝 𝕞 𝕟 𝕠 𝕡 𝕢 𝕣 𝕤 𝕥 𝕦 𝕧 𝕨 𝕩 𝕪 𝕫  -->
<!-- 𝟘 𝟙 𝟚 𝟛 𝟜 𝟝 𝟞 𝟟 𝟠 𝟡 -->
<!-- 📘 🗎 🖋 👀 🗣 … 🧪-->
<!-- Double-struck font -->
<!-- 𝔸𝔹ℂ𝔻𝔼𝔽𝔾ℍ𝕀𝕁𝕂𝕃𝕄ℕ𝕆ℙℚℝ𝕊𝕋𝕌𝕍𝕎𝕏𝕐ℤ𝕒𝕓𝕔𝕕𝕖𝕗𝕘𝕙𝕚𝕛𝕜𝕝𝕞𝕟𝕠𝕡𝕢𝕣𝕤𝕥𝕦𝕧𝕨𝕩𝕪𝕫𝟘𝟙𝟚𝟛𝟜𝟝𝟞𝟟𝟠𝟡 -->
<!-- http://github.com/tandpfun/skill-icons#readme -->

<!-- [tag_test]: url "on hover" -->

# All my shell alias


## ~/.zshrc

```sh

    alias nals='nano ~/.zshrc'
    alias als='code ~/.zshrc'
    alias sauce='source ~/.zshrc'


    export spubfcretin="/sgoinfre/fcretin/public"
    export sprivfcretin="/sgoinfre/fcretin/private"
    export dlzozoflo="$spubfcretin/profile"
    export ALIAS="$dlzozoflo/.alias/"
    alias alss='code $ALIAS'


    # Cherche et charge tous les .zsh dans $ALIAS et ses sous-dossiers
    if [ -d "$ALIAS" ]; then
        for file in $(find "$ALIAS" -name "*.zsh"); do
            source "$file"
        done
    fi
    
    
    if [[ "$HOME" == "/home/fcretin" ]]; then
        42_path
        load_blueprint_export
    fi


    if [[ "$USER" != "fcretin" ]]; then
        export sprivuser="/sgoinfre/$USER/private" #chmod 750
        export spubuser="/sgoinfre/$USER/public" #chmod 755
        export ALIAS_USER="$suser/.alias/"
        alias alssu='code $ALIAS_USER'
        # Cherche et charge tous les .zsh dans $ALIAS_USER et ses sous-dossiers
        if [ -d "$ALIAS_USER" ]; then
            for file in $(find "$ALIAS_USER" -name "*.zsh"); do
                source "$file"
            done
        fi
    fi

```

##

<br>

---

<br>

<h2 id="author">🖋 𝔸uthor</h2>

All implementation decisions and documentation were written and validated by the project author.


<br>

---

<br>
